%------------------------------------------------------------------------------%
%% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

%------------------------------------------------------------------------------%
%% Prepare the workspace
%------------------------------------------------------------------------------%

% Clear the workspace
clear; close all; clc;

% Add the path to the VehiCool library
addpath( genpath( '../' ) );

%------------------------------------------------------------------------------%
%% Load the data
%------------------------------------------------------------------------------%

load( 'data/adria.mat' );         % racetrack data
load( 'data/state_rf0.mat' );     % state of the main reference frame
load( 'data/state_chassis.mat' ); % state of the chassis
load( 'data/state_wheel_r.mat' ); % state of the rear wheels
load( 'data/state_wheel_f.mat' ); % state of the front wheels
load( 'data/time_sim.mat' );      % time vector of the simulation

%------------------------------------------------------------------------------%
%% Create the scenario
%------------------------------------------------------------------------------%

% Create a racetrack using the RaceTrack class. This class enables you to render
% any (we hope) flat racetrack. The only thing you need to do is to provide the
% left and right margins of the track. The margins are defined as a matrix
% where each row is a point of the margin. The first column is the x coordinate,
% the second column is the y coordinate and the third column is the z coordinate
% of the point.
track = RaceTrack( adria.left_margin, adria.right_margin );

% Create the main reference frame using the STLObject class. This class enables
% you to render any STL object (which by default is a 3D reference frame). The
% only thing you need to do is to provide the state of the object as a N x 6
% matrix where each row is the state of the object at a given time. The first
% three columns are the position of the object, the last three columns are the
% orientation of the object.
rf0_T = makehgtform( 'scale', 0.01 ); % initial transformation matrix
rf0   = STLObject( state_rf0(1, :), 'InitTrans', rf0_T, 'Opacity', 0.0 );

% Create the chassis of the vehicle using the STLObject class.
chassis_T = makehgtform( 'scale', 0.25, 'translate', [0, 0, 2.5] );
chassis   = STLObject( state_chassis(1, :),                                                                          ...
                       'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Chassis.stl', ...
                       'InitTrans', chassis_T,                                                                       ...
                       'Parent', rf0 );

% Create the rear wheels of the vehicle using the STLObject class.
T_wheel_rr = makehgtform( 'scale', 0.25, 'translate', [-4.7, -3.1, -1.1], ...
                          'translate', [0, 0, 2.5] );
T_wheel_rl = makehgtform( 'scale', 0.25, 'translate', [-4.7,  3.1, -1.1], ...
                          'translate', [0, 0, 2.5] );
wheel_rr = STLObject( state_wheel_r(1, :),                                                                          ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', ...
                      'InitTrans', T_wheel_rr,                                                                      ...
                      'Parent', rf0 );
wheel_rl = STLObject( state_wheel_r(1, :),                                                                          ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', ...
                      'InitTrans', T_wheel_rl,                                                                      ...
                      'Parent', rf0 );

% Create the front wheels of the vehicle using the STLObject class.
T_wheel_fr = makehgtform( 'scale', 0.25, 'translate', [ 5.6, -3,   -1.2], ...
                          'translate', [0, 0, 2.5] );
T_wheel_fl = makehgtform( 'scale', 0.25, 'translate', [ 5.6,  3,   -1.2], ...
                          'translate', [0, 0, 2.5] );
wheel_fr = STLObject( state_wheel_f(1, :),                                                                          ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', ...
                      'InitTrans', T_wheel_fr,                                                                      ...
                      'Parent', rf0 );
wheel_fl = STLObject( state_wheel_f(1, :),                                                                          ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', ...
                      'InitTrans', T_wheel_fl,                                                                      ...
                      'Parent', rf0 );

% Create the camera using the FollowerCamera class. This class enables you to
% render a camera that follows a given object. The only thing you need to do is
% to provide the object to follow.
camera = FollowerCamera( rf0 );

% Create the scenario using the VehiCool class. This is the main class of the
% entire library.
scen = VehiCool();

% Add the objects to the scenario
scen.set_track( track );     % set the racetrack, we use “set” because every
                             % scenario has only one racetrack
scen.add_camera( camera );   % add the camera, which in theory could be more
                             % than one
scen.add_root_object( rf0 ); % add the main reference frame as a root object,
                             % which in theory could be more than one

% Note
% The terminology “root object” is used to indicate an object that is not
% attached to any other object. In other words, it is an object that is not the
% child of any other object. In VehiCool, the root objects are the objects that
% are attached to the world frame. There is no need to add child objects to the
% scenario, because they are automatically added when you add a root object
% (doing so will result in an error).

%------------------------------------------------------------------------------%
%% Animate the scenario one step at a time
%------------------------------------------------------------------------------%

% Render the scenario using the render() method. This method returns the figure
% and the axes of the rendered scenario.
[fig, ax] = scen.render();

% Animate the scenario one step at a time
for i = 1 : length( time_sim )

    % Update the state of the reference frame using the set_state() method
    rf0.set_state( state_rf0(i, :) );

    % Update the state of the chassis using the set_state() method
    chassis.set_state( state_chassis(i, :) );

    % Update the state of the rear wheels using the set_state() method
    wheel_rr.set_state( state_wheel_r(i, :) );
    wheel_rl.set_state( state_wheel_r(i, :) );

    % Update the state of the front wheels using the set_state() method
    wheel_fr.set_state( state_wheel_f(i, :) );
    wheel_fl.set_state( state_wheel_f(i, :) );

    % Update the scenario using the advance() method
    scen.advance();

    % Draw the scenario
    drawnow limitrate nocallbacks; % this limits the frame rate to 20 fps and
                                   % avoids unwanted interactions with the
                                   % figure

end

%------------------------------------------------------------------------------%
%% End of file
%------------------------------------------------------------------------------%

% User:
% Ok VehiCool developers, I've changed my mind. It looks very powerful and user
% friendly! I will use it for my next project.
%
% VehiCool developers:
% Great! We are happy to hear that. We hope you will enjoy using VehiCool. Stay
% tuned for more updates!
