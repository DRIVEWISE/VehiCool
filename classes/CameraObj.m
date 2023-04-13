%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%
% Contributors
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
    %  - set_target( target )                 -> set camera target.
    %  - plot( ax, varargin )                 -> set the camera.
    %  - update( varargin )                   -> update camera state and target.
    %
    % Usage
    % -----
    %  - obj = CameraObj( state, target, varargin )
    %  - obj.set_state( state )
    %  - obj.set_target( target )
    %  - obj.plot( ax, varargin )
    %  - obj.update( varargin )
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax         % axis handle
        state      % camera state
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

        % Set the camera
        function plot( obj, ax, varargin )
            % This function sets the camera.
            %
            % Arguments
            % ----------
            %  - ax          -> axis handle.
            %  - varargin{1} -> the index of the sample to use (optional).
            %
            % Usage
            % -----
            %  - obj.plot( ax, varargin )
            %

            % Set axis handle
            obj.ax = ax;

            % Set camera projection
            camproj( obj.ax, obj.projection );

            % Set the camera view angle
            camva( obj.ax, obj.view_angle );

            % Update the camera
            switch nargin
                case 2
                    obj.update();
                case 3
                    obj.update( varargin{1} );
            end

        end


        % Update camera state and target
        function update( obj, varargin )
            % This function updates the camera state and target.
            %
            % Arguments
            % ----------
            %  - varargin{1} -> the index of the sample to use (optional).
            %
            % Usage
            % -----
            %  - obj.update( varargin )
            %

            % Extract the current state and target based on the index
            switch nargin
                case 1
                    curr_state  = obj.state;
                    curr_target = obj.target;
                case 2
                    curr_state  = obj.state(varargin{1}, :);
                    curr_target = obj.target(varargin{1}, :);
            end

            % Set camera state
            campos( obj.ax, curr_state );

            % Set camera target
            camtarget( obj.ax, curr_target );

        end

    end

end
