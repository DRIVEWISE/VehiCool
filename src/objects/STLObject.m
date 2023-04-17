%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef STLObject < BaseObject
    %% STLObject
    % This class creates a STL object in 3D space with 6 Degrees of Freedom
    % (i.e., [x, y, z, roll, pitch, yaw]). It is a subclass of BaseObject,
    % please refer to the documentation of BaseObject for more information.
    %
    % Properties
    % ----------
    %  - stl     -> the stl file.
    %  - colour  -> the colour of the object. It is a triplet of RGB values in
    %               the range [0, 1].
    %  - opacity -> the opacity of the object. It is a value in the range
    %               [0, 1].
    %
    % Methods
    % -------
    %  - STLObject( state, varargin ) -> constructor.
    %  - create_descriptor()          -> create the object's descriptor.
    %
    % Usage
    % -----
    %  - obj = STLObject( state, varargin )
    %  - out = obj.create_descriptor()
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        stl     % the STL file
        colour  % the colour of the object
        opacity % the opacity of the object

    end

    %% Methods
    methods

        % Constructor
        function obj = STLObject( state, varargin )
            % STLObject constructor
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
            %                    '../../models/refernce_frames/Reference_Frame_3D/Reference_Frame_3D.stl'.
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
            %  - obj = STLObject( state, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'state', @isnumeric );
            addParameter( p, 'STLPath', '../../models/reference_frames/Reference_Frame_3D/Reference_Frame_3D.stl', @ischar );
            addParameter( p, 'InitTrans', eye( 4 ), @isnumeric );
            addParameter( p, 'RotSeq', 'zxy', @ischar );
            addParameter( p, 'Colour', rgb( 'DarkGray' ), @ischar );
            addParameter( p, 'Opacity', 1.0, @isnumeric );
            addParameter( p, 'Parent', [], @(x) or( isa( x, 'BaseObject' ), isempty( x ) ) );
            parse( p, state, varargin{:} );

            % Call the superclass constructor
            obj@BaseObject( p.Results.state,                  ...
                          'InitTrans', p.Results.InitTrans, ...
                          'RotSeq', p.Results.RotSeq,       ...
                          'Parent', p.Results.Parent );

            % Set the object properties
            obj.stl     = stlread( p.Results.STLPath );
            obj.colour  = p.Results.Colour;
            obj.opacity = p.Results.Opacity;

        end

        % Create the object's descriptor
        function out = create_descriptor( obj )
            % Create the object's descriptor
            %
            % Usage
            % -----
            %  - out = obj.create_descriptor()
            %

            % Create the patch object from the STL file
            out = patch( obj.ax,                            ...
                         'Faces', obj.stl.ConnectivityList, ...
                         'Vertices', obj.stl.Points,        ...
                         'FaceColor', obj.colour,           ...
                         'FaceAlpha', obj.opacity,          ...
                         'EdgeColor', 'none',               ...
                         'AmbientStrength', 0.5,            ...
                         'DiffuseStrength', 1.0,            ...
                         'SpecularStrength', 1.0 );

        end

    end

end