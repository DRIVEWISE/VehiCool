%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

function skip_children( obj, idx )
    % Skip the object's children to the specified index
    %
    % Usage
    % -----
    %  - obj.skip_children()
    %

    % Unravel the tree of objects
    for i = 1:length( obj.children )
        % Update the root object
        obj.children{i}.skip( idx );

        % Update its children
        if ~isempty( obj.children{i}.children )
            obj.children{i}.skip_children( idx );
        end
    end

end