%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function plot( obj, ax )
    % This function sets the camera.
    %
    % Arguments
    % ----------
    %  - ax -> axis handle.
    %
    % Usage
    % -----
    %  - obj.plot( ax )
    %

    % Set axis handle
    obj.ax = ax;

    % Set camera projection
    camproj( obj.ax, obj.projection );

    % Set the camera view angle
    camva( obj.ax, obj.view_angle );

    % Update the camera
    obj.update();

end