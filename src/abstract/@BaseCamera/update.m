%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function update( obj )
    % This function updates the camera state and target.
    %
    % Usage
    % -----
    %  - obj.update()
    %

    % Compute the camera state
    curr_state = obj.create_state();

    % Get the current target position
    curr_target = obj.get_target();
    curr_target = curr_target(1, 1:3); % this 1 is here because get_target()
                                       % returns a 1 x 6 array, ensuring that
                                       % under any circumstances the target will
                                       % have only one row.

    % Set camera state
    campos( obj.ax, curr_state );

    % Set camera target
    camtarget( obj.ax, curr_target );

end