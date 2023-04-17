%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

%% Prepare the workspace

% Clear the workspace
clear all; close all; clc;

% Add the path to the VehiCool library
addpath( genpath( '../../' ) );

%% Load the data

load( '../data/adria.mat' );     % racetrack data
load( '../data/state_rf0.mat' ); % state of the main reference frame
load( '../data/time_sim.mat' );  % time vector of the simulation

%% Create the scenario

% Create the racetrack
track = RaceTrack( adria.left_margin, adria.right_margin );

% Create the main reference frame
rf0_T = makehgtform( 'scale', 0.05 ); % initial transformation matrix
rf0   = STLObject( state_rf0, 'InitTrans', rf0_T );

% Extract the initial state of the reference frame
x_rf0   = state_rf0(:, 1);
y_rf0   = state_rf0(:, 2);
z_rf0   = state_rf0(:, 3);
yaw_rf0 = state_rf0(:, 4);

% Create the camera state and target state
state_camera  = [x_rf0 - 10 * cos( yaw_rf0 ), ...
                 y_rf0 - 10 * sin( yaw_rf0 ), ...
                 z_rf0 + 6];
target_camera = [x_rf0, y_rf0, z_rf0];

% Create the camera
camera = FixedCamera( rf0, 'FixedPosition', [10, 10, 10] );

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
% This is cool, but what if I want to animate the scenario during the
% simulation?
%
% VehiCool developers:
% Fear not, VehiCool is able to do that too! Look at the file example_2.m in
% this folder for more details.
