%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef ScatterObject < BaseObject
    %% ScatterObject
    % This class creates a scatter object in 3D space with 6 Degrees of Freedom
    % (i.e., [x, y, z, roll, pitch, yaw]). It is a subclass of BaseObject,
    % please refer to the documentation of BaseObject for more information.
    %
    % Properties
    % ----------
    %  - data    -> the object's data. It is a N x 3 matrix, where N is the
    %               number of samples and each row contains the [x, y, z]
    %               coordinates of the points for the scatter plot.
    %  - colour  -> the colour for the scatter plot. It can be a triplet of
    %               RGB values in the range [0, 1] or a matrix of N x 3 values
    %               where each row contains the RGB values for the corresponding
    %               point. Default is 'White'.
    %  - size    -> the size for the markers in the scatter plot. Default is 10.
    %
    % Methods
    % -------
    %  - ScatterObject( state, varargin ) -> constructor.
    %  - create_descriptor()              -> create the object's descriptor.
    %
    % Usage
    % -----
    %  - obj = ScatterObject( state, varargin )
    %  - out = obj.create_descriptor()
    %

    %% Properties
    properties (SetAccess = private, Hidden = true)

        data   % the object's data
        colour % the colour of the object
        size   % the size of the markers

    end

    %% Methods
    methods

        % Constructor
        function obj = ScatterObject( data, varargin )
            % ScatterObject constructor
            %
            % Arguments
            % ---------
            %  - data         -> the object's data. It is a N x 3 matrix, where
            %                    N is the number of samples and each row
            %                    contains the [x, y, z] coordinates of the
            %                    points for the scatter plot.
            %  - 'State'      -> the state of the object. It is a N x 3 matrix,
            %                    where N is the number of samples and each row
            %                    contains the object state
            %                    [x, y, z, a1, a2, a3]. a1, a2, a3 are generic
            %                    angles that can be used to represent the object
            %                    orientation. The rotation sequence is defined
            %                    by the 'RotSeq' parameter defined in the
            %                    constructor. Default is [0, 0, 0, 0, 0, 0] for
            %                    all samples.
            %  - 'InitTrans'  -> the initial transformation for the STL. It is a
            %                    4 x 4 transformation matrix. Default is eye(4).
            %  - 'RotSeq'     -> rotation sequence for the transformations. It
            %                    is a string of 3 characters, where each
            %                    character can be 'x', 'y' or 'z'. The rotation
            %                    sequence is defined by the 'RotSeq' parameter
            %                    defined in the constructor. Default is 'zxy'.
            %  - 'Colour'     -> the colour for the scatter plot. It can be a
            %                    triplet of RGB values in the range [0, 1] or a
            %                    matrix of N x 3 values where each row contains
            %                    the RGB values for the corresponding point.
            %                    Default is 'White'.
            %  - 'Size'       -> the size for the markers in the scatter plot.
            %                    Default is 10.
            %  - 'Parent'     -> handle of the parent object. Default is [].
            %
            % Outputs
            % -------
            %  - obj  -> the object.
            %
            % Usage
            % -----
            %  - obj = ScatterObject( state, varargin )
            %

            % Parse the inputs
            p = inputParser;
            addRequired( p, 'data', @isnumeric );
            addParameter( p, 'State', zeros( 1, 6 ), @isnumeric );
            addParameter( p, 'InitTrans', eye( 4 ), @isnumeric );
            addParameter( p, 'RotSeq', 'zxy', @ischar );
            addParameter( p, 'Colour', rgb( 'White' ), @ischar );
            addParameter( p, 'Size', 10, @isnumeric );
            addParameter( p, 'Parent', [], @(x) or( isa( x, 'BaseObject' ), isempty( x ) ) );
            parse( p, data, varargin{:} );

            % Call the superclass constructor
            obj@BaseObject( p.Results.State,                  ...
                          'InitTrans', p.Results.InitTrans, ...
                          'RotSeq', p.Results.RotSeq,       ...
                          'Parent', p.Results.Parent );

            % Set the object properties
            obj.data   = p.Results.data;
            obj.colour = p.Results.Colour;
            obj.size   = p.Results.Size;

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
            out = scatter3( obj.data(:, 1), obj.data(:, 2), obj.data(:, 3), ...
                            'MarkerEdgeColor', obj.colour,                  ...
                            'MarkerFaceColor', obj.colour,                  ...
                            'SizeData', obj.size );

        end

    end

end