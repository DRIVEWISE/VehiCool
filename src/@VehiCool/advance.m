%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function advance( obj, simulation_step )
    % Advance the scenario by one step.
    %
    % Arguments
    % ---------
    %  - simulation_step -> the current simulation step.
    %
    % Usage
    % -----
    %  - obj.advance()
    %

    % Update the objects
    VehiCool.update_objects( obj.objects, simulation_step );

    % Update the camera
    obj.camera.update();

end