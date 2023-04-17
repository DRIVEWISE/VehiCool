%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

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