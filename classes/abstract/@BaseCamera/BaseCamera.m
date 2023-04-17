%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef BaseCamera < handle
    %% BaseCamera
    % This class creates the camera object for the simulation.
    %
    % This is an abstract class. It is meant to be inherited by other classes
    % that represent specific cameras. The inherited classes must implement the
    % 'create_state' method.
    %
    % Properties
    % ----------
    %  - ax         -> axis handle.
    %  - state      -> camera state. It is a N x 3 matrix, where N is the number
    %                  of samples and each row contains the camera position
    %                  [x, y, z].
    %  - target     -> handle of the target. It has to be a BaseObject object.
    %  - projection -> camera projection. Options are 'perspective' and
    %                  'orthographic'. Default is 'perspective'.
    %  - view_angle -> camera viewing angle [deg]. Default is 40 deg.
    %
    % Methods - abstract
    % ------------------
    %  - out = create_state( obj ) -> create the state of the camera.
    %
    % Methods
    % -------
    %  - BaseCamera( state, target, varargin ) -> constructor.
    %  - set_target( target )                  -> set camera target.
    %  - get_target()                          -> get camera current target.
    %  - plot( ax, varargin )                  -> set the camera.
    %  - update( varargin )                    -> update camera state and
    %                                             target.
    %
    % Usage
    % -----
    %  - obj = BaseCamera( state, target, varargin )
    %  - obj.set_target( target )
    %  - out = obj.get_target()
    %  - obj.plot( ax, varargin )
    %  - obj.update( varargin )
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax         % axis handle
        target     % handle of the target
        projection % camera projection
        view_angle % camera viewing angle

    end

    %% Methods - abstract
    methods (Abstract)

        out = create_state( obj ) % create the state of the camera

    end

    %% Methods
    methods

        % Constructor
        function obj = BaseCamera( target, varargin )
            % This function creates the camera object for the simulation.
            %
            % Arguments
            % ----------
            %  - target       -> handle of the target. It has to be a BaseObject
            %                    object.
            %  - 'Projection' -> camera projection. Options are 'perspective'
            %                    and 'orthographic'. Default is 'perspective'.
            %  - 'ViewAngle'  -> camera viewing angle [deg]. Default is 40.
            %
            %
            % Outputs
            % -------
            %  - obj -> camera object.
            %
            % Usage
            % -----
            %  - obj = BaseCamera( target, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'target', @(x) isa( x, 'BaseObject' ) );
            addParameter( p, 'Projection', 'perspective', @ischar );
            addParameter( p, 'ViewAngle', 40, @isnumeric );
            parse( p, target, varargin{:} );

            % Set the object properties
            obj.target     = p.Results.target;
            obj.projection = p.Results.Projection;
            obj.view_angle = p.Results.ViewAngle;

        end

        % Set camera target
        function set_target( obj, target )
            % This function sets the camera target.
            %
            % Arguments
            % ----------
            %  - target -> camera target. It is a N x 3 matrix, where N is the
            %              number of samples and each row contains the camera
            %              target position [x, y, z].
            %
            % Usage
            % -----
            %  - obj.set_target( target )
            %

            obj.target = target;

        end

        % Get the camera current target
        function out = get_target( obj )
            % This function gets the camera current target.
            %
            % Outputs
            % -------
            %  - out -> camera current target.
            %
            % Usage
            % -----
            %  - target = obj.get_target()
            %

            out = obj.target.get_state();

        end

        % Set the camera
        function plot( obj, ax )
            % This function sets the camera.
            %
            % Arguments
            % ----------
            %  - ax -> axis handle.
            %
            % Usage
            % -----
            %  - obj.plot( ax )
            %

            % Set axis handle
            obj.ax = ax;

            % Set camera projection
            camproj( obj.ax, obj.projection );

            % Set the camera view angle
            camva( obj.ax, obj.view_angle );

            % Update the camera
            obj.update();

        end


        % Update camera state and target
        function update( obj )
            % This function updates the camera state and target.
            %
            % Usage
            % -----
            %  - obj.update()
            %

            % Compute the camera state
            curr_state = obj.create_state();

            % Get the current target position
            curr_target = obj.get_target();
            curr_target = curr_target(1, 1:3);

            % Set camera state
            campos( obj.ax, curr_state );

            % Set camera target
            camtarget( obj.ax, curr_target );

        end

    end

end
