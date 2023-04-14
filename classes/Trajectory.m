%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%
% Contributors
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef Trajectory < BaseTrack
    %% Trajectory
    % This class handles the creation of a trajectory object.
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax     % axes handle
        points % points of the trajectory
        msize  % marker size
        cdata  % color data

    end

    %% Methods
    methods

        % Constructor
        function obj = Trajectory( points, varargin )
            %% Trajectory
            % This function creates a trajectory object.
            %
            % Arguments
            % ---------
            %  - points       -> points of the trajectory.
            %  - 'MarkerSize' -> marker size. Default: 10.
            %  - 'CData'      -> color data. Default: [0, 0, 0].
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'points', @isnumeric );
            addParameter( p, 'MarkerSize', 10, @isnumeric );
            addParameter( p, 'CData', [0, 0, 0], @isnumeric );
            parse( p, points, varargin{:} );

            % Set the properties
            obj.points = p.Results.points;
            obj.msize  = p.Results.MarkerSize;
            obj.cdata  = p.Results.CData;

        end

        % Plot the trajectory
        function plot( obj, ax )
            %% plot
            % This function plots the trajectory.
            %
            % Arguments
            % ---------
            %  - ax -> axes handle.
            %

            % Set the axes handle
            obj.ax = ax;

            % Plot the trajectory
            scatter3( obj.ax, ...
                      obj.points(:, 1), obj.points(:, 2), obj.points(:, 3), ...
                      obj.msize, obj.cdata, 'filled' );

        end

    end

end