%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function update_objects( objects, simulation_step )
    % Update the objects of the scenario.
    %
    % Arguments
    % ---------
    %  - objects         -> cell array of objects to update.
    %  - simulation_step -> current simulation step.
    %
    % Usage
    % -----
    %  - VehiCool.update_objects( objects )
    %

    % Update the objects
    for i = 1:length( objects )
        % Update the object if the simulation step is a multiple of the
        % deferred update
        if mod( simulation_step, objects{i}.deferred_update ) == 0
            % Update the root object
            objects{i}.update();
        end

        % Update its children (there is no need to check if the simulation step
        % is a multiple of the deferred update, since we are recursively
        % calling this function)
        if ~isempty( objects{i}.children )
            VehiCool.update_objects( objects{i}.children, simulation_step );
        end
    end

end