%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function skip_to( objects, idx )
    % Skip the scenario to the given index.
    %
    % Arguments
    % ---------
    %  - objects -> cell array of objects to skip for.
    %  - idx     -> index to skip to.
    %
    % Usage
    % -----
    %  - VehiCool.skip( objects, idx )
    %

    % Update the objects
    for i = 1:length( objects )
        % Update the root object
        objects{i}.skip( idx );

        % Update its children
        if ~isempty( objects{i}.children )
            VehiCool.skip_to( objects{i}.children, idx );
        end
    end

end