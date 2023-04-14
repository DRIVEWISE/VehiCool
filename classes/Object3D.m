%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%
% Contributors
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef Object3D < BaseObject
    %% Object3D
    % This class creates a an object in 3D space with 6 Degrees of Freedom
    % (i.e., [x, y, z, roll, pitch, yaw]).
    %
    % Properties
    % ----------
    %  - ax                -> axes handle.
    %  - parent            -> handle of the parent object.
    %  - children          -> cell array of the handles to child objects.
    %  - state             -> the state of the object. It is a N x 3 matrix,
    %                         where N is the number of samples and each row
    %                         contains the object state [x, y, z, a1, a2, a3].
    %                         a1, a2, a3 are generic angles that can be used
    %                         to represent the object orientation. The rotation
    %                         sequence is defined by the 'RotSeq' parameter
    %                         defined in the constructor.
    %  - rot_seq           -> the rotation sequence. It is a string of 3
    %                         characters, where each character can be 'x', 'y'
    %                         or 'z'. The rotation sequence is defined by the
    %                         'RotSeq' parameter defined in the constructor.
    %  - stl               -> the stl file.
    %  - colour            -> the colour of the object. It is a triplet of RGB
    %                         values in the range [0, 1].
    %  - opacity           -> the opacity of the object. It is a value in the
    %                         range [0, 1].
    %  - patch_obj         -> the patch object representing the object.
    %  - patch_transform   -> the transform object for the patch.
    %  - default_transform -> initial transform. It is a 4 x 4 transformation
    %                         matrix.
    %
    % Methods
    % -------
    %  - Object3D( state, varargin )                -> constructor.
    %  - set_state( state )                         -> set the object's state.
    %  - set_default_transform( default_transform ) -> set the object's default
    %                                                  transform.
    %  - get_transform()                            -> get the object's
    %                                                  transform.
    %  - define_tree( parent )                      -> define the object tree.
    %  - transform( T )                             -> transform the object.
    %  - plot( ax, varargin )                       -> plot the object.
    %  - plot_children( ax, varargin )              -> plot the children of the
    %                                                  object.
    %  - update( varargin )                         -> update the object.
    %  - update_children( varargin )                -> update the children of
    %                                                  the object.
    %
    % Usage
    % -----
    %  - obj = Object3D( state, varargin )
    %  - obj.set_state( state )
    %  - obj.set_default_transform( default_transform )
    %  - T = obj.get_transform()
    %  - obj.define_tree( parent )
    %  - obj.transform( T )
    %  - obj.plot( ax, varargin )
    %  - obj.plot_children( ax, varargin )
    %  - obj.update( varargin )
    %  - obj.update_children( varargin )
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        ax                % axes handle
        parent            % handle of the parent object
        children          % list of the handles to child objects
        state             % the state of the object
        rot_seq           % the rotation sequence
        stl               % the stl file
        colour            % the colour of the object
        opacity           % the opacity of the object
        patch_obj         % the patch object representing the object
        patch_transform   % the transform object for the patch
        default_transform % initial transform

    end

    %% Methods
    methods

        % Constructor
        function obj = Object3D( state, varargin )
            % Object3D constructor
            %
            % Arguments
            % ---------
            %  - state        -> the state of the object. It is a N x 3 matrix,
            %                    where N is the number of samples and each row
            %                    contains the object state
            %                    [x, y, z, a1, a2, a3]. a1, a2, a3 are generic
            %                    angles that can be used to represent the object
            %                    orientation. The rotation sequence is defined
            %                    by the 'RotSeq' parameter defined in the
            %                    constructor.
            %  - 'STLPath'    -> the path to the STL file. Default is
            %                    'models/refernce_frames/Reference_Frame_3D/Reference_Frame_3D.stl'.
            %  - 'InitTrans'  -> the initial transformation for the STL. It is a
            %                    4 x 4 transformation matrix. Default is eye(4).
            %  - 'RotSeq'     -> rotation sequence for the transformations. It
            %                    is a string of 3 characters, where each
            %                    character can be 'x', 'y' or 'z'. The rotation
            %                    sequence is defined by the 'RotSeq' parameter
            %                    defined in the constructor. Default is 'zxy'.
            %  - 'Colour'     -> the colour of the object. It is a triplet of
            %                    RGB values in the range [0, 1]. Default is
            %                    'DarkGray'.
            %  - 'Opacity'    -> the opacity of the object. It is a value in the
            %                    range [0, 1]. Default is 1.0.
            %  - 'Parent'     -> handle of the parent object. Default is [].
            %
            % Outputs
            % -------
            %  - obj  -> the object.
            %
            % Usage
            % -----
            %  - obj = Object3D( state, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'state', @isnumeric );
            addParameter( p, 'STLPath', 'models/reference_frames/Reference_Frame_3D/Reference_Frame_3D.stl', @ischar );
            addParameter( p, 'InitTrans', eye(4), @isnumeric );
            addParameter( p, 'RotSeq', 'zxy', @ischar );
            addParameter( p, 'Colour', rgb( 'DarkGray' ), @ischar );
            addParameter( p, 'Opacity', 1.0, @isnumeric );
            addParameter( p, 'Parent', [], @(x) isa(x, 'Object3D') );
            parse( p, state, varargin{:} );

            % Set the object properties
            obj.state             = p.Results.state;
            obj.stl               = stlread( p.Results.STLPath );
            obj.default_transform = p.Results.InitTrans;
            rot_seq               = lower( p.Results.RotSeq );
            obj.rot_seq           = {[rot_seq(1), 'rotate'], ...
                                     [rot_seq(2), 'rotate'], ...
                                     [rot_seq(3), 'rotate']};
            obj.colour            = p.Results.Colour;
            obj.opacity           = p.Results.Opacity;

            % Set the parent
            obj.define_tree( p.Results.Parent );

        end

        % Set the object's state
        function set_state( obj, state )
            % Set the object's state
            %
            % Arguments
            % ---------
            %  - state -> the state of the object. It is a N x 3 matrix, where N
            %             is the number of samples and each row contains the
            %             object state [x, y, z, a1, a2, a3]. a1, a2, a3 are
            %             generic angles that can be used to represent the
            %             object orientation. The rotation sequence is defined
            %             by the 'RotSeq' parameter.
            %
            % Usage
            % -----
            %  - obj.set_state( state )
            %

            % Set the state
            obj.state = state;

        end

        % Set the object's default transform
        function set_default_transform( obj, default_transform )
            % Set the object's default transformation matrix
            %
            % Arguments
            % ---------
            %  - default_transform -> the default transform. It is a 4 x 4
            %                         transformation matrix.
            %
            % Usage
            % -----
            %  - obj.set_default_transform( default_transform )
            %

            % Set the default transform
            obj.default_transform = default_transform;

        end

        % Get the object's transform
        function out = get_transform( obj )
            % Get the object's current transformation matrix
            %
            % Outputs
            % -------
            %  - out -> the transform. It is a 4 x 4 transformation matrix.
            %
            % Usage
            % -----
            %  - transform = obj.get_transform()
            %

            % Get the transform
            out = get( obj.patch_transform, 'Matrix' );

        end

        % Define the object tree
        function define_tree( obj, parent )
            % Define the object tree
            %
            % Arguments
            % ---------
            %  - parent -> the parent object.
            %
            % Usage
            % -----
            %  - obj.define_tree( parent )
            %

            % Set the parent
            obj.parent = parent;

            % Add the object to the parent's list of children
            if ~isempty( obj.parent )
                obj.parent.children{end + 1} = obj;
            end

        end

        % Transform the object
        function transform( obj, T )
            % Transform the object
            %
            % Arguments
            % ---------
            %  - T -> the transformation matrix.
            %
            % Usage
            % -----
            %  - obj.transform( T )
            %

            % Apply the transformation
            if ~isempty( obj.parent )
                % Remove the parent's default transform
                R = obj.parent.get_transform() / obj.parent.default_transform;
                set( obj.patch_transform, ...
                     'Matrix', R * obj.default_transform * T );
            else
                set( obj.patch_transform, 'Matrix', T * obj.default_transform );
            end

        end

        % Plot the object
        function plot( obj, ax, varargin )
            % Plot the object
            %
            % Arguments
            % ---------
            %  - ax          -> the axes handle.
            %  - varargin{1} -> the index of the sample to use (optional).
            %
            % Usage
            % -----
            %  - obj.plot( ax, varargin )
            %

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

            % Update the object's position
            obj.update( varargin{:} );

        end

        % Plot the object's children
        function plot_children( obj, ax, varargin )
            % Plot the object's children
            %
            % Arguments
            % ---------
            %  - ax          -> the axes handle.
            %  - varargin{1} -> the index of the sample to use (optional).
            %
            % Usage
            % -----
            %  - obj.plot_children( ax, varargin )
            %

            % Unravel the tree of objects
            for i = 1:length( obj.children )
                % Plot the root object
                obj.children{i}.plot( ax, varargin{:} );

                % Plot its children
                if ~isempty( obj.children{i}.children )
                    obj.children{i}.plot_children( ax, varargin{:} );
                end
            end

        end

        % Update the object's position
        function update( obj, varargin )
            % Update the object's position
            %
            % Arguments
            % ---------
            %  - varargin{1} -> the index of the sample to use (optional). If it
            %                   is not provided, the current state is assumed to
            %                   be the a vector of the form
            %                   [x, y, z, a1, a2, a3].
            %
            % Usage
            % -----
            %  - obj.update( varargin )
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
                             obj.rot_seq{1}, a1,     ...
                             obj.rot_seq{2}, a2,     ...
                             obj.rot_seq{3}, a3 );

            % Apply the transform
            obj.transform( T );

        end

        % Update the object's children
        function update_children( obj, varargin )
            % Update the object's children
            %
            % Arguments
            % ---------
            %  - varargin{1} -> the index of the sample to use (optional).
            %
            % Usage
            % -----
            %  - obj.update_children( varargin )
            %

            % Unravel the tree of objects
            for i = 1:length( obj.children )
                % Update the root object
                obj.children{i}.update( varargin{:} );

                % Update its children
                if ~isempty( obj.children{i}.children )
                    obj.children{i}.update_children( varargin{:} );
                end
            end

        end

    end

end