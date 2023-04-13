%------------------------------------------------------------------------------%
% Latest revision: 08/04/2023.
%
% Authors:
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef RaceTrack < BaseTrack
    %% RaceTrack
    % This class handles the creation of a racetrack object. It contains all the
    % information about the map of the racetrack.
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax           % axes handle
        centreline   % nx2 array of X and Y coordinates of the centreline
        angles       % nx1 array of angles of the centreline
        offsets      % nx1 array of offsets from the centreline
        left_margin  % nx2 array of X and Y coordinates of the left margin
        right_margin % nx2 array of X and Y coordinates of the right margin
        left_kerb    % nx2 array of X and Y coordinates of the left kerb
        right_kerb   % nx2 array of X and Y coordinates of the right kerb

    end

    %% Methods
    methods

        % Constructor
        function obj = RaceTrack( left_margin, right_margin, kerb_width )
            % RaceTrack constructor.
            %
            % Arguments
            % ---------
            %  - left_margin  -> nx2 array of X and Y coordinates of the left
            %                    margin.
            %  - right_margin -> nx2 array of X and Y coordinates of the right
            %                    margin.
            %  - kerb_width   -> width of the kerb.
            %

            % Create the centreline
            obj.centreline = (left_margin + right_margin) ./ 2;

            % Create the angles for the centreline
            obj.angles = atan2( left_margin(:, 2) - right_margin(:, 2), ...
                                left_margin(:, 1) - right_margin(:, 1) );

            % Create the offsets
            obj.offsets = sqrt( sum( (right_margin - left_margin).^2, 2 ) ) ...
                          ./ 2;

            % Create the margins and kerbs
            obj.create_margins_kerbs( kerb_width );

        end

        % Create the margins and kerbs
        function create_margins_kerbs( obj, kerb_width )
            % Create the margins and kerbs.
            %
            % Arguments
            % ---------
            %  - kerb_width -> width of the kerb.
            %

            % Create a clothoid from the centreline
            CL_angles = obj.angles - pi / 2;
            CL_centre = ClothoidList();
            CL_centre.build_G1( obj.centreline(:, 1), obj.centreline(:, 2), ...
                                CL_angles(:, 1) );

            % Sample the centreline every ~ 10 cm
            sample_dist = linspace( 0, CL_centre.length(), ...
                                    floor( CL_centre.length() / 0.1 ) );

            % Interpolate the offsets based on the clothoid curvilinear
            % coordinate at each sample distance
            [~, ~, curv_coord, ~, ~, ~] = CL_centre.closest_point( ...
                obj.centreline(:, 1),                              ...
                obj.centreline(:, 2) );
            offs_intp  = interp1( curv_coord, obj.offsets, sample_dist );

            % Create the left margin
            obj.left_margin = CL_centre.eval( sample_dist, offs_intp )';

            % Create the right margin
            obj.right_margin = CL_centre.eval( sample_dist, -offs_intp )';

            % Create the left kerb
            obj.left_kerb = CL_centre.eval( sample_dist, ...
                                            offs_intp + kerb_width )';

            % Create the right kerb
            obj.right_kerb = CL_centre.eval( sample_dist, ...
                                             -offs_intp - kerb_width )';

        end

        % Plot the racetrack
        function plot( obj, ax )
            % Plot the racetrack.
            %
            % Arguments
            % ---------
            %  - ax -> axes handle.
            %

            % Set the axes handle
            obj.ax = ax;

            % Resample every 20 samples (~ 2 m)
            colour_flag  = true;
            sample_skip  = 20;
            sample_sf    = 10; % samples reserved for the start/finish line
            sample_start = floor( sample_sf / 2 );
            sample_end   = floor( (size( obj.left_kerb, 1 ) - sample_skip - ...
                                   sample_start) / sample_skip ) *          ...
                           sample_skip + sample_start;
            samples = sample_start:sample_skip:sample_end + sample_skip;

            % Get the edges of the racetrack
            x_min = min( [obj.left_margin(:, 1); obj.right_margin(:, 1)] );
            x_max = max( [obj.left_margin(:, 1); obj.right_margin(:, 1)] );
            y_min = min( [obj.left_margin(:, 2); obj.right_margin(:, 2)] );
            y_max = max( [obj.left_margin(:, 2); obj.right_margin(:, 2)] );

            % Plot the ground with a 100 m padding and carve out the racetrack
            ground_pad = 100;
            patch( ax, ...
                   [x_min - ground_pad, x_max + ground_pad, ...
                    x_max + ground_pad, x_min - ground_pad, ...
                    x_min - ground_pad,                     ...
                    obj.right_kerb(samples, 1)',            ...
                    obj.right_kerb(sample_start, 1)],       ...
                   [y_min - ground_pad, y_min - ground_pad, ...
                    y_max + ground_pad, y_max + ground_pad, ...
                    y_min - ground_pad,                     ...
                    obj.right_kerb(samples, 2)',            ...
                    obj.right_kerb(sample_start, 2)],       ...
                   zeros( 1, length( samples ) + 6 ),       ...
                   rgb( 'ForestGreen' ),                    ...
                   'EdgeColor', 'none',                     ...
                   'FaceLighting', 'none',                  ...
                   'FaceAlpha', 1.0 );

            patch( ax,                            ...
                   obj.left_kerb(samples, 1)',    ...
                   obj.left_kerb(samples, 2)',    ...
                   zeros( 1, length( samples ) ), ...
                   rgb( 'ForestGreen' ),          ...
                   'EdgeColor', 'none',           ...
                   'FaceLighting', 'none',        ...
                   'FaceAlpha', 1.0 );

            % Plot the kerbs
            for i = sample_start:sample_skip:sample_end

                % Alternate the colour of the kerbs
                if colour_flag
                    left_colour  = rgb( 'Red' );
                    right_colour = rgb( 'White' );
                    colour_flag  = false;
                else
                    left_colour  = rgb( 'White' );
                    right_colour = rgb( 'Red' );
                    colour_flag  = true;
                end

                % Plot the left kerb
                patch( ax,                                   ...
                       [obj.left_margin(i, 1),               ...
                        obj.left_margin(i + sample_skip, 1), ...
                        obj.left_kerb(i + sample_skip, 1),   ...
                        obj.left_kerb(i, 1)],                ...
                       [obj.left_margin(i, 2),               ...
                        obj.left_margin(i + sample_skip, 2), ...
                        obj.left_kerb(i + sample_skip, 2),   ...
                        obj.left_kerb(i, 2)],                ...
                       zeros( 1, 4 ),                        ...
                       left_colour,                          ...
                       'EdgeColor', 'none',                  ...
                       'FaceLighting', 'none',               ...
                       'FaceAlpha', 1.0 );

                % Plot the right kerb
                patch( ax,                                    ...
                       [obj.right_margin(i, 1),               ...
                        obj.right_margin(i + sample_skip, 1), ...
                        obj.right_kerb(i + sample_skip, 1),   ...
                        obj.right_kerb(i, 1)],                ...
                       [obj.right_margin(i, 2),               ...
                        obj.right_margin(i + sample_skip, 2), ...
                        obj.right_kerb(i + sample_skip, 2),   ...
                        obj.right_kerb(i, 2)],                ...
                       zeros( 1, 4 ),                         ...
                       right_colour,                          ...
                       'EdgeColor', 'none',                   ...
                       'FaceLighting', 'none',                ...
                       'FaceAlpha', 1.0 );

            end

            % Extract edge points for the start/finish line checkerboard
            xcb_1 = obj.left_kerb(sample_start, 1);
            xcb_2 = obj.right_kerb(sample_start, 1);
            xcb_3 = obj.right_kerb(sample_end + sample_skip, 1);
            ycb_1 = obj.left_kerb(sample_start, 2);
            ycb_2 = obj.right_kerb(sample_start, 2);
            ycb_3 = obj.right_kerb(sample_end + sample_skip, 2);

            % Create the vectors along the width and height of the start/finish
            % line
            u = [xcb_2 - xcb_1; ycb_2 - ycb_1];
            v = [xcb_3 - xcb_2; ycb_3 - ycb_2];

            % Create a nx4 checkerboard pattern where n is define such that each
            % square is ~ 0.25 m x 0.25 m
            col_squares = 4;
            row_squares = ceil( norm( u ) / (norm( v ) / col_squares) );

            x_u = linspace( xcb_1, xcb_2, row_squares + 1 );
            y_u = linspace( ycb_1, ycb_2, row_squares + 1 );
            x_v = linspace( 0, v(1), col_squares + 1 );
            y_v = linspace( 0, v(2), col_squares + 1 );

            for i = 1:row_squares
                for j = 1:col_squares

                    % Select the colour of the rectangle
                    if mod( i + j, 2 ) == 0
                        checkerboard_colour = rgb( 'White' );
                    else
                        checkerboard_colour = rgb( 'Black' );
                    end

                    patch( ax,                       ...
                           [x_u(i) + x_v(j),         ...
                            x_u(i + 1) + x_v(j),     ...
                            x_u(i + 1) + x_v(j + 1), ...
                            x_u(i) + x_v(j + 1)],    ...
                           [y_u(i) + y_v(j),         ...
                            y_u(i + 1) + y_v(j),     ...
                            y_u(i + 1) + y_v(j + 1), ...
                            y_u(i) + y_v(j + 1)],    ...
                           zeros( 1, 4 ),            ...
                           checkerboard_colour,      ...
                           'EdgeColor', 'none',      ...
                           'FaceLighting', 'none',   ...
                           'FaceAlpha', 1.0 );

                end
            end

            % Plot the racetrack and carve out the start/finish line
            patch( ax, ...
                   [obj.left_margin(samples, 1);             ...
                    flipud( obj.right_margin(samples, 1) )], ...
                   [obj.left_margin(samples, 2);             ...
                    flipud( obj.right_margin(samples, 2) )], ...
                   zeros( 1, 2 * length( samples ) ),        ...
                   rgb( 'DarkSlateGray' ),                   ...
                   'EdgeColor', 'none',                      ...
                   'FaceLighting', 'none',                   ...
                   'FaceAlpha', 1.0 );

        end

    end

end

