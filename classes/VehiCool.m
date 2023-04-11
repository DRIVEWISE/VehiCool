%------------------------------------------------------------------------------%
% Latest revision: 08/04/2023.
%
% Authors:
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef VehiCool < handle
    %% VehiCool
    % This class handles the creation of a scenario (i.e., a track, a set of
    % vehicles, etc.). It also handles the simulation of the scenario.
    %

    %% Properties - all private
    properties (SetAccess = private, Hidden = true)

        track       % track of the scenario
        camera      % camera view of the scenario
        objects     % cell array of objects in the scenario
        sample_time % sample time of the data
        frame_rate  % frame rate of the animation

    end

    %% Methods
    methods

        % Constructor
        function obj = VehiCool( )
            % VehiCool constructor.
            %
            % Useful ah?
            %

        end

        % Set the track
        function set_track( obj, track )
            % Set the track of the scenario.
            %
            % Arguments
            % ---------
            %  - track -> track to add to the scenario.
            %

            obj.track = track;

        end

        % Add a camera
        function add_camera( obj, camera )
            % Add a camera to the scenario.
            %
            % Arguments
            % ---------
            %  - camera -> camera to add to the scenario.
            %

            obj.camera = camera;

        end

        % Add an object
        function add_object( obj, object )
            % Add an object to the scenario.
            %
            % Arguments
            % ---------
            %  - object -> object to add to the scenario.
            %

            obj.objects{end + 1} = object;

        end

        % Render the scenario
        function [fig, ax] = render( obj, varargin )
            % Render the scenario.
            %
            % Arguments
            % ---------
            %  - 'FigSize'     -> size of the figure. Default is [960, 540].
            %  - 'ShowFigure'  -> flag to show the figure or not. Default is
            %                     'on'.
            %
            % Outputs
            % -------
            %  - fig -> figure handle.
            %  - ax  -> axes handle.
            %

            % Parse the inputs
            p = inputParser;
            addParameter( p, 'FigSize', [960, 540], @isnumeric );
            addParameter( p, 'ShowFigure', 'on', @ischar );
            parse( p, varargin{:} );

            % Create the figure and axes
            fig = figure( 'Name', 'VehiCool', 'NumberTitle', 'off', ...
                          'Position', [0, 0, p.Results.FigSize],    ...
                          'Visible', p.Results.ShowFigure );
            ax  = axes( 'Parent', fig, 'Visible', 'off' );

            % Set the figure properties
            hold( ax, 'on' );
            pbaspect( ax, [1 1 1] ); % axis aspect ratio
            daspect( ax, [1 1 1] );  % axis ticks aspect ratio

            % Set the scene lighting
            light( ax, 'Style', 'infinite' );
            lighting( ax, 'gouraud' );

            % Plot the track
            obj.track.plot( ax );

            % Plot the camera
            obj.camera.plot( ax );

            % Plot the objects
            for i = 1:length( obj.objects )
                obj.objects{i}.plot( ax );
            end

        end

        % Advance the scenario
        function advance( obj, varargin )
            % Advance the scenario by one step.
            %
            % Arguments
            % ---------
            %  - varargin{1} -> index of the current step.
            %

            % Advance to a specific step
            if nargin == 2
                % Update the objects
                for i = 1:length( obj.objects )
                    obj.objects{i}.update( idx );
                end

                % Update the camera
                obj.camera.update( idx );
            else
                % Update the objects
                for i = 1:length( obj.objects )
                    obj.objects{i}.update();
                end

                % Update the camera
                obj.camera.update();
            end

        end

        % Animate the scenario
        function animate( obj, tf, varargin )
            % Animate the scenario.
            %
            % Arguments
            % ---------
            %  - tf            -> total animation time.
            %  - 'FrameRate'   -> frame rate of the animation. Default is 30.
            %  - 'SampleTime'  -> sample time of the data. Default is 0.01.
            %  - 'FigSize'     -> size of the figure. Default is [960, 540].
            %  - 'ShowProgress'-> flag to show the progress bar or not. Default
            %                     is true.
            %  - 'ShowFigure'  -> flag to show the figure or not. Default is
            %                     'on'.
            %  - 'SaveVideo'   -> flag to save the video or not. Default is
            %                     false.
            %  - 'FileName'    -> name of the video file. Default is 'VehiCool'.
            %  - 'FileFormat'  -> format of the video file. Default is 'MPEG-4'.
            %  - 'FileQuality' -> quality of the video file. Default is 100.
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'tf', @isnumeric );
            addParameter( p, 'FrameRate', 30, @isnumeric );
            addParameter( p, 'SampleTime', 0.01, @isnumeric );
            addParameter( p, 'FigSize', [960, 540], @isnumeric );
            addParameter( p, 'ShowProgress', true, @islogical );
            addParameter( p, 'ShowFigure', 'on', @ischar );
            addParameter( p, 'SaveVideo', false, @islogical );
            addParameter( p, 'FileName', 'VehiCool', @ischar );
            addParameter( p, 'FileFormat', 'MPEG-4', @ischar );
            addParameter( p, 'FileQuality', 100, @isnumeric );
            parse( p, tf, varargin{:} );

            % Render the scenario
            [fig, ax] = obj.render( 'FigSize', p.Results.FigSize, ...
                                    'ShowFigure', p.Results.ShowFigure );

            % Create the video file if needed
            if p.Results.SaveVideo
                vidfile           = VideoWriter( p.Results.FileName, ...
                                                 p.Results.FileFormat );
                vidfile.FrameRate = p.Results.FrameRate;
                vidfile.Quality   = p.Results.FileQuality;
                open( vidfile );
            end

            % Simulate the scenario
            idx = 1;
            for t = 0:p.Results.SampleTime:tf

                % Simulate the scenario only at the specified frame rate
                if mod( t, 1 / p.Results.FrameRate ) == 0
                    % Advance the scenario
                    obj.advance( idx );

                    % Check if the user wants to save the animation
                    if p.Results.SaveVideo
                        A = getframe( fig );
                        writeVideo( vidfile, A );
                    else
                        % Pause to animate
                        pause( 1 / p.Results.FrameRate );
                    end
                end

                % Advance the progress bar
                if p.Results.ShowProgress
                    progress_bar( 0, tf, p.Results.SampleTime, t, 1 );
                end

                % Increment the index
                idx = idx + 1;

            end

            % Stop holding onto the figure
            hold( ax, 'off' );

            % Close the video if needed
            if p.Results.SaveVideo
                close( vidfile );
            end

        end

    end

end
