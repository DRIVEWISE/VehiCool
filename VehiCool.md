# VehiCool

VehiCool is a MATLAB library to visualize vehicles in real-time and generate animations.

This library is capable of:

- visualize the STL of multiple vehicles (whole body, no multi-body modelling yet) and animate them with six degrees of freedom (*i.e.,* x, y, z, yaw, roll, pitch);
- automatically draw a racetrack based on the track edges;
- create videos and/or animations at specific framerates.

## Workflow

A workflow example is the following

```
% Define the scenario
track = RaceTrack( left_margin, right_margin, 0.4 );
cam   = CameraObj( camera_state, target_state );
car   = VehicleObj( car_state, 'models/cars/McLarenP1.stl', 'InitTrans', T );
ghost = VehicleObj( ghost_state, 'models/cars/McLarenP1.stl', 'InitTrans', ...
                    T, 'Opacity', 0.3 );

% Create and populate the scenario
scene = VehiCool();
scene.set_track( track );
scene.add_camera( cam );
scene.add_object( car );
scene.add_object( ghost );

% Animate the scenario
scene.animate( time_sim(end), 'FrameRate', 30, 'SampleTime', 1e-3 );
```
