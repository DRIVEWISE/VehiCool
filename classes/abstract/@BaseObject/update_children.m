%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function update_children( obj )
    % Update the object's children
    %
    % Usage
    % -----
    %  - obj.update_children()
    %

    % Unravel the tree of objects
    for i = 1:length( obj.children )
        % Update the root object
        obj.children{i}.update();

        % Update its children
        if ~isempty( obj.children{i}.children )
            obj.children{i}.update_children();
        end
    end

end