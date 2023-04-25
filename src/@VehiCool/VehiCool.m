%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef VehiCool < handle
    %% VehiCool
    % This class handles the creation of a scenario (i.e., a track, a set of
    % vehicles, etc.) as well as the animation of the scenario.
    %
    % Properties
    % ----------
    %  - track       -> track of the scenario.
    %  - camera      -> camera view of the scenario.
    %  - objects     -> cell array of root objects in the scenario.
    %  - sample_time -> sample time of the data.
    %  - frame_rate  -> frame rate of the animation.
    %
    % Methods
    % -------
    %  - VehiCool()                     -> constructor.
    %  - set_track( track )             -> set the track of the scenario.
    %  - add_camera( camera )           -> add a camera to the scenario.
    %  - add_root_object( root_object ) -> add a root object to the scenario.
    %  - plot_objects( ax, varargin )   -> plot the objects of the scenario.
    %  - render( varargin )             -> render the scenario.
    %  - update_objects( varargin )     -> update the objects of the scenario.
    %  - advance( varargin )            -> advance the scenario by one step.
    %  - animate( tf, varargin )        -> animate the scenario.
    %
    % Usage
    % -----
    %  - obj = VehiCool()
    %  - obj.set_track( track )
    %  - obj.add_camera( camera )
    %  - obj.add_root_object( object )
    %  - obj.plot_objects( ax, varargin )
    %  - obj.render( varargin )
    %  - obj.update_objects( varargin )
    %  - obj.advance( varargin )
    %  - obj.animate( tf, varargin )
    %

    %% Properties - all private
    properties (SetAccess = private, Hidden = true)

        track       % track of the scenario
        camera      % camera view of the scenario
        objects     % cell array of root objects in the scenario
        sample_time % sample time of the data
        frame_rate  % frame rate of the animation

    end

    %% Methods
    methods

        % Constructor
        function obj = VehiCool()
            % VehiCool constructor.
            %
            % Outputs
            % -------
            %  - obj -> the scenario object.
            %
            % Usage
            % -----
            %  - obj = VehiCool()
            %

            % Useful ah?

        end

        % Set the track
        function set_track( obj, track )
            % Set the track of the scenario.
            %
            % Arguments
            % ---------
            %  - track -> track to add to the scenario.
            %
            % Usage
            % -----
            %  - obj.set_track( track )
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
            % Usage
            % -----
            %  - obj.add_camera( camera )
            %

            obj.camera = camera;

        end

        % Add an object
        function add_root_object( obj, object )
            % Add a root object to the scenario.
            %
            % Arguments
            % ---------
            %  - object -> object to add to the scenario.
            %
            % Usage
            % -----
            %  - obj.add_root_object( object )
            %

            obj.objects{end + 1} = object;

        end

        % Render the scenario
        [fig, ax] = render( obj, varargin );

        % Advance the scenario
        advance( obj, simulation_step );

        % Animate the scenario
        animate( obj, tf, varargin );

    end

    %% Methods - static
    methods (Static)

        % Plot the objects
        plot_objects( objects, ax );

        % Update the objects
        update_objects( objects, simulation_step );

        % Skip the scenario to the given index
        skip_to( objects, idx );

    end

end
