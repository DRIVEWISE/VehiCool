%------------------------------------------------------------------------------%
% Latest revision: 08/04/2023.
%
% Authors:
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef VehicleObj < BaseObject
    %% VehicleObj
    % This class represents a vehicle in the simulation.
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax                % axes handle
        state             % the state of the vehicle
        rot_seq           % the rotation sequence
        stl               % the stl file
        colour            % the colour of the vehicle
        opacity           % the opacity of the vehicle
        patch_obj         % the patch object representing the vehicle
        patch_transform   % the transform object for the patch
        default_transform % initial transform

    end

    %% Methods
    methods

        % Constructor
        function obj = VehicleObj( state, stl_filepath, varargin )
            % VehicleObj constructor
            %
            % Arguments
            % ---------
            %  - state        -> the state of the vehicle.
            %  - stl_filepath -> the filepath to the stl file.
            %  - 'InitTrans'  -> the initial transformation for the STL. Default
            %                    is eye(4).
            %  - 'RotSeq'     -> rotation sequence for the transformations.
            %                    Default is 'zyx'.
            %  - 'Colour'     -> the colour of the vehicle. Default is
            %                    'DarkGray'.
            %  - 'Opacity'    -> the opacity of the vehicle. Default is 1.0.
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'state', @isnumeric );
            addRequired( p, 'stl_filepath', @ischar );
            addParameter( p, 'InitTrans', eye(4), @isnumeric );
            addParameter( p, 'RotSeq', 'zyx', @ischar );
            addParameter( p, 'Colour', rgb( 'DarkGray' ), @ischar );
            addParameter( p, 'Opacity', 1.0, @isnumeric );
            parse( p, state, stl_filepath, varargin{:} );

            % Set the object properties
            obj.state             = p.Results.state;
            obj.stl               = stlread( p.Results.stl_filepath );
            obj.default_transform = p.Results.InitTrans;
            rot_seq               = lower( p.Results.RotSeq );
            obj.rot_seq           = {[rot_seq(1), 'rotate'], ...
                                     [rot_seq(1), 'rotate'], ...
                                     [rot_seq(1), 'rotate']};
            obj.colour            = p.Results.Colour;
            obj.opacity           = p.Results.Opacity;

        end

        % Set the vehicle's state
        function set_state( obj, state )
            % Set the vehicle's state
            %
            % Arguments
            % ---------
            %  - state -> the state of the vehicle.
            %

            % Set the state
            obj.state = state;

        end

        % Plot the vehicle
        function plot( obj, ax, varargin )
            % Plot the vehicle
            %
            % Arguments
            % ---------
            %  - ax          -> the axes handle.
            %  - varargin{1} -> the index of the state to use (optional).

            % Set the axes handle
            obj.ax = ax;

            % Create the patch object
            obj.patch_obj = patch( obj.ax,                            ...
                                   'Faces', obj.stl.ConnectivityList, ...
                                   'Vertices', obj.stl.Points,        ...
                                   'FaceColor', obj.colour,           ...
                                   'FaceAlpha', obj.opacity,          ...
                                   'EdgeColor', 'none',               ...
                                   'AmbientStrength', 0.5,            ...
                                   'DiffuseStrength', 1.0,            ...
                                   'SpecularStrength', 1.0 );

            % Create the transform object
            obj.patch_transform = hgtransform( 'Parent', obj.ax );

            % Set the patch object to be a child of the transform object
            set( obj.patch_obj, 'Parent', obj.patch_transform );

            % Set the initial transform
            set( obj.patch_transform, 'Matrix', obj.default_transform );

            % Update the vehicle's position
            switch nargin
                case 2
                    obj.update( 1 );
                case 3
                    obj.update( varargin{1} );
            end

        end

        % Update the vehicle's position
        function update( obj, varargin )
            % Update the vehicle's position
            %
            % Arguments
            % ---------
            %  - varargin{1} -> the index of the state to use (optional).
            %

            % Extract the current state based on the index
            switch nargin
                case 1
                    x  = obj.state(1);
                    y  = obj.state(2);
                    z  = obj.state(3);
                    a1 = obj.state(4);
                    a2 = obj.state(5);
                    a3 = obj.state(6);
                case 2
                    x  = obj.state(varargin{1}, 1);
                    y  = obj.state(varargin{1}, 2);
                    z  = obj.state(varargin{1}, 3);
                    a1 = obj.state(varargin{1}, 4);
                    a2 = obj.state(varargin{1}, 5);
                    a3 = obj.state(varargin{1}, 6);
            end

            % Create the transform matrix
            T = makehgtform( 'translate', [x, y, z], ...
                             obj.rot_seq{1}, a1, ...
                             obj.rot_seq{2}, a2, ...
                             obj.rot_seq{3}, a3 );

            % Apply the transform
            set( obj.patch_transform, 'Matrix', T * obj.default_transform );

        end

    end

end