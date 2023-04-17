%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef CameraObj < BaseObject
    %% CameraObj
    % This class creates the camera object for the simulation.
    %
    % Properties
    % ----------
    %  - ax         -> axis handle.
    %  - state      -> camera state. It is a N x 3 matrix, where N is the number
    %                  of samples and each row contains the camera position
    %                  [x, y, z].
    %  - target     -> camera target. It is a N x 3 matrix, where N is the
    %                  number of samples and each row contains the camera target
    %                  position [x, y, z].
    %  - projection -> camera projection. Options are 'perspective' and
    %                  'orthographic'. Default is 'perspective'.
    %  - view_angle -> camera viewing angle [deg]. Default is 40 deg.
    %
    % Methods
    % -------
    %  - CameraObj( state, target, varargin ) -> constructor.
    %  - set_state( state )                   -> set camera state.
    %  - get_state()                          -> get camera current state.
    %  - set_target( target )                 -> set camera target.
    %  - get_target()                         -> get camera current target.
    %  - skip( idx )                          -> skip to the idx-th state.
    %  - plot( ax, varargin )                 -> set the camera.
    %  - update( varargin )                   -> update camera state and target.
    %
    % Usage
    % -----
    %  - obj = CameraObj( state, target, varargin )
    %  - obj.set_state( state )
    %  - out = obj.get_state()
    %  - obj.set_target( target )
    %  - out = obj.get_target()
    %  - obj.skip( idx )
    %  - obj.plot( ax, varargin )
    %  - obj.update( varargin )
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax         % axis handle
        state      % camera state
        idx        % index of the current state
        target     % camera target
        projection % camera projection
        view_angle % camera viewing angle

    end

    %% Methods
    methods

        % Constructor
        function obj = CameraObj( state, target, varargin )
            % This function creates the camera object for the simulation.
            %
            % Arguments
            % ----------
            %  - state        -> camera state. It is a N x 3 matrix, where N is
            %                    the number of samples and each row contains the
            %                    camera position [x, y, z].
            %  - target       -> camera target. It is a N x 3 matrix, where N is
            %                    the number of samples and each row contains the
            %                    camera target position [x, y, z].
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
            %  - obj = CameraObj( state, target, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'state',  @isnumeric );
            addRequired( p, 'target', @isnumeric );
            addParameter( p, 'Projection', 'perspective', @ischar );
            addParameter( p, 'ViewAngle', 40, @isnumeric );
            parse( p, state, target, varargin{:} );

            % Set the object properties
            obj.state      = p.Results.state;
            obj.idx        = 1;
            obj.target     = p.Results.target;
            obj.projection = p.Results.Projection;
            obj.view_angle = p.Results.ViewAngle;

        end

        % Set camera state
        function set_state( obj, state )
            % This function sets the camera state.
            %
            % Arguments
            % ----------
            %  - state -> camera state. It is a N x 3 matrix, where N is the
            %             number of samples and each row contains the camera
            %             position [x, y, z].
            %
            % Usage
            % -----
            %  - obj.set_state( state )
            %

            obj.state = state;

        end

        % Get the camera current state
        function out = get_state( obj )
            % This function gets the camera current state.
            %
            % Outputs
            % -------
            %  - out -> camera current state.
            %
            % Usage
            % -----
            %  - state = obj.get_state()
            %

            if size( obj.state, 1 ) == 1
                out = obj.state;
            else
                out     = obj.state( obj.idx, : );
                obj.idx = obj.idx + 1;
            end

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

            if size( obj.target, 1 ) == 1
                out = obj.target;
            else
                out     = obj.target( obj.idx, : );
                obj.idx = obj.idx + 1;
            end

        end

        % Skip to the idx-th state
        function skip( obj, idx )
            % This function skips to the idx-th state.
            %
            % Arguments
            % ----------
            %  - idx -> index of the state.
            %
            % Usage
            % -----
            %  - obj.skip( idx )
            %

            obj.idx = idx;

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

            % Extract the current state and target
            curr_state  = obj.get_state();
            curr_target = obj.get_target();

            % Set camera state
            campos( obj.ax, curr_state );

            % Set camera target
            camtarget( obj.ax, curr_target );

        end

    end

end
