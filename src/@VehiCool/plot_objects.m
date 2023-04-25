%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function plot_objects( objects, ax )
    % Plot the objects of the scenario.
    %
    % Arguments
    % ---------
    %  - objects -> cell array of objects.
    %  - ax      -> axes handle.
    %
    % Usage
    % -----
    %  - VehiCool.plot_objects( objects, ax )
    %

    % Unravel the tree of objects
    for i = 1:length( objects )
        % Plot the root object
        objects{i}.plot( ax );

        % Plot its children
        if ~isempty( objects{i}.children )
            VehiCool.plot_objects( objects{i}.children, ax );
        end
    end

end