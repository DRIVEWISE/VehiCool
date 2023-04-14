%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%
% Contributors
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

        % Plot the objects
        function plot_objects( obj, ax, varargin )
            % Plot the objects of the scenario.
            %
            % Arguments
            % ---------
            %  - ax          -> axes handle.
            %  - varargin{1} -> index of the current step.
            %
            % Usage
            % -----
            %  - obj.plot_objects( ax, varargin )
            %

            % Unravel the tree of objects
            for i = 1:length( obj.objects )
                % Plot the root object
                obj.objects{i}.plot( ax, varargin{:} );

                % Plot its children
                if ~isempty( obj.objects{i}.children )
                    obj.objects{i}.plot_children( ax, varargin{:} );
                end
            end

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
            %  - 'StartStep'   -> index of the first step to plot. If it is not
            %                     provided, the current state is assumed to be
            %                     the a vector of the form 1 x num_states.
            %
            % Outputs
            % -------
            %  - fig -> figure handle.
            %  - ax  -> axes handle.
            %
            % Usage
            % -----
            %  - obj.render( varargin )
            %

            % Parse the inputs
            p = inputParser;
            addParameter( p, 'FigSize', [960, 540], @isnumeric );
            addParameter( p, 'ShowFigure', 'on', @ischar );
            addParameter( p, 'StartStep', 0, @isnumeric );
            parse( p, varargin{:} );

            % Create the figure and axes
            fig = figure( 'Name', 'VehiCool', 'NumberTitle', 'off', ...
                          'Position', [0, 0, p.Results.FigSize],    ...
                          'Visible', p.Results.ShowFigure );
            ax  = axes( 'Parent', fig, 'Visible', 'off' );

            % Set the figure properties
            hold( ax, 'on' );
            pbaspect( ax, [1, 1. 1] ); % axis aspect ratio
            daspect( ax, [1, 1, 1] );  % axis ticks aspect ratio

            % Set the scene lighting
            light( ax, 'Style', 'infinite' );
            lighting( ax, 'gouraud' );

            % Plot the track
            obj.track.plot( ax );

            % Plot the camera
            if p.Results.StartStep == 0
                obj.camera.plot( ax );
            else
                obj.camera.plot( ax, p.Results.StartStep );
            end

            % Plot the objects
            if p.Results.StartStep == 0
                obj.plot_objects( ax );
            else
                obj.plot_objects( ax, p.Results.StartStep );
            end

        end

        % Update the objects
        function update_objects( obj, varargin )
            % Update the objects of the scenario.
            %
            % Arguments
            % ---------
            %  - varargin{1} -> index of the current step.
            %
            % Usage
            % -----
            %  - obj.update_objects( varargin )
            %

            % Update the objects
            for i = 1:length( obj.objects )
                % Update the root object
                obj.objects{i}.update( varargin{:} );

                % Update its children
                if ~isempty( obj.objects{i}.children )
                    obj.objects{i}.update_children( varargin{:} );
                end
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
            % Usage
            % -----
            %  - obj.advance( varargin )
            %

            % Update the objects
            obj.update_objects( varargin{:} );

            % Update the camera
            obj.camera.update( varargin{:} );

        end

        % Animate the scenario
        function animate( obj, tf, varargin )
            % Animate the scenario.
            %
            % Arguments
            % ---------
            %  - tf            -> total animation time.
            %  - 'FrameRate'   -> frame rate of the animation. Default is 30.
            %  - 'SampleTime'  -> sample time of the data. Default is 0.001.
            %  - 'FigSize'     -> size of the figure. Default is [960, 540].
            %  - 'ShowProgress'-> flag to show the progress bar or not. Default
            %                     is false.
            %  - 'ShowFigure'  -> flag to show the figure or not. Default is
            %                     'on'.
            %  - 'SaveVideo'   -> flag to save the video or not. Default is
            %                     false.
            %  - 'FileName'    -> name of the video file. Default is 'VehiCool'.
            %  - 'FileFormat'  -> format of the video file. Default is 'MPEG-4'.
            %  - 'FileQuality' -> quality of the video file. Default is 100.
            %
            % Usage
            % -----
            %  - obj.animate( tf, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'tf', @isnumeric );
            addParameter( p, 'FrameRate', 30, @isnumeric );
            addParameter( p, 'SampleTime', 0.001, @isnumeric );
            addParameter( p, 'FigSize', [960, 540], @isnumeric );
            addParameter( p, 'ShowProgress', false, @islogical );
            addParameter( p, 'ShowFigure', 'on', @ischar );
            addParameter( p, 'SaveVideo', false, @islogical );
            addParameter( p, 'FileName', 'VehiCool', @ischar );
            addParameter( p, 'FileFormat', 'MPEG-4', @ischar );
            addParameter( p, 'FileQuality', 100, @isnumeric );
            parse( p, tf, varargin{:} );

            % Check that SampleTime <= 1 / FrameRate
            if p.Results.SampleTime > 1 / p.Results.FrameRate
                error( 'ERROR: SampleTime > 1 / FrameRate.' );
            end

            % Render the scenario
            [fig, ax] = obj.render( 'FigSize', p.Results.FigSize, ...
                                    'ShowFigure', p.Results.ShowFigure, ...
                                    'StartStep', 1 );

            % Create the video file if needed
            if p.Results.SaveVideo
                vidfile           = VideoWriter( p.Results.FileName, ...
                                                 p.Results.FileFormat );
                vidfile.FrameRate = p.Results.FrameRate;
                vidfile.Quality   = p.Results.FileQuality;
                open( vidfile );
            end

            % Round the inverse of the frame rate to the same order of the
            % sample time
            frame_time = round( 1 / p.Results.FrameRate, ...
                                -floor( log10( p.Results.SampleTime ) ) );

            % Simulate the scenario
            idx = 1;
            tic
            for t = 0:p.Results.SampleTime:tf

                % Simulate the scenario only at the specified frame rate
                if mod( t, frame_time ) == 0
                    % Advance the scenario
                    s_t = tic;
                    obj.advance( idx );
                    drawnow nocallbacks;
                    e_t = toc( s_t );

                    % Check if the user wants to save the animation
                    if p.Results.SaveVideo
                        A = getframe( fig );
                        writeVideo( vidfile, A );
                    else
                        % Try to pause for the remaining time
                        if e_t < 1 / p.Results.FrameRate
                            pause( 1 / p.Results.FrameRate - e_t );
                        end
                    end
                end

                % Advance the progress bar
                if p.Results.ShowProgress
                    progress_bar( 0, tf, p.Results.SampleTime, t, 1 );
                end

                % Increment the index
                idx = idx + 1;

            end
            toc

            % Stop holding onto the figure
            hold( ax, 'off' );

            % Close the video if needed
            if p.Results.SaveVideo
                close( vidfile );
            end

        end

    end

end
