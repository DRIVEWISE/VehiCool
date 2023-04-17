%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

%% Prepare the workspace

% Clear the workspace
clear all; close all; clc;

% Add the path to the VehiCool library
addpath( genpath( '../' ) );

%% Load the data

load( 'data/adria.mat' );         % racetrack data
load( 'data/state_rf0.mat' );     % state of the main reference frame
load( 'data/state_chassis.mat' ); % state of the chassis
load( 'data/state_wheel_r.mat' ); % state of the rear wheels
load( 'data/state_wheel_f.mat' ); % state of the front wheels
load( 'data/time_sim.mat' );      % time vector of the simulation

%% Create the scenario

% Create the racetrack
track = RaceTrack( adria.left_margin, adria.right_margin );

% Create the main reference frame
rf0_T = makehgtform( 'scale', 0.01 ); % initial transformation matrix
rf0   = STLObject( state_rf0, 'InitTrans', rf0_T, 'Opacity', 0.0 );

% Create the chassis
chassis_T = makehgtform( 'scale', 0.25, 'translate', [0, 0, 2.5] );
chassis   = STLObject( state_chassis,                                                                                ...
                       'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Chassis.stl', ...
                       'InitTrans', chassis_T,                                                                       ...
                       'Parent', rf0 );

% Create the rear wheels
T_wheel_rr = makehgtform( 'scale', 0.25, 'translate', [-4.7, -3.1, -1.1], ...
                          'translate', [0, 0, 2.5] );
T_wheel_rl = makehgtform( 'scale', 0.25, 'translate', [-4.7,  3.1, -1.1], ...
                          'translate', [0, 0, 2.5] );
wheel_rr = STLObject( state_wheel_r,                                                                                ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', ...
                      'InitTrans', T_wheel_rr,                                                                      ...
                      'Parent', rf0 );
wheel_rl = STLObject( state_wheel_r,                                                                                ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', ...
                      'InitTrans', T_wheel_rl,                                                                      ...
                      'Parent', rf0 );

% Create the front wheels
T_wheel_fr = makehgtform( 'scale', 0.25, 'translate', [ 5.6, -3,   -1.2], ...
                          'translate', [0, 0, 2.5] );
T_wheel_fl = makehgtform( 'scale', 0.25, 'translate', [ 5.6,  3,   -1.2], ...
                          'translate', [0, 0, 2.5] );
wheel_fr = STLObject( state_wheel_f,                                                                                ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', ...
                      'InitTrans', T_wheel_fr,                                                                      ...
                      'Parent', rf0 );
wheel_fl = STLObject( state_wheel_f,                                                                                ...
                      'STLPath', '../../models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', ...
                      'InitTrans', T_wheel_fl,                                                                      ...
                      'Parent', rf0 );

% Extract the initial state of the reference frame
x_rf0   = state_rf0(:, 1);
y_rf0   = state_rf0(:, 2);
z_rf0   = state_rf0(:, 3);
yaw_rf0 = state_rf0(:, 4);

% Create the camera state and target state
state_camera  = [x_rf0 - 10 * cos( yaw_rf0 ), ...
                 y_rf0 - 15 * sin( yaw_rf0 ), ...
                 z_rf0 + 6];
target_camera = [x_rf0, y_rf0, z_rf0];

% Create the camera
camera = CameraObj( state_camera, target_camera );

% Create the scenario
scen = VehiCool();

% Add the objects to the scenario
scen.set_track( track );
scen.add_camera( camera );
scen.add_root_object( rf0 );

%% Animate the scenario

scen.animate( time_sim(end) );

%% EoF

% User:
% Quite impressive, VehiCool developers. Still, I am certain that it is very
% complex to animate this multi-body system during the simulation!
%
% VehiCool developers:
% Thing again, user. Take a look at the file example_2.m in this folder and see
% if we can change your mind!
