%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

%% Prepare the workspace

% Clear the workspace
clear; close all; clc;

% Add the path to the VehiCool library
addpath( genpath( '../../' ) );

%% Load the data

load( '../data/adria.mat' );      % racetrack data
load( '../data/state_rf0.mat' );  % state of the main reference frame
load( '../data/trajectory.mat' ); % trajectory of the vehicle
load( '../data/time_sim.mat' );   % time vector of the simulation

%% Create the scenario

% Create the racetrack
track = RaceTrack( adria.left_margin, adria.right_margin );

% Create the main reference frame
rf0_T = makehgtform( 'scale', 0.05 ); % initial transformation matrix
rf0   = STLObject( state_rf0, 'InitTrans', rf0_T );

% Create a fixed trajectory of the reference frame
rf0_traj = ScatterObject( trajectory, 'DeferredUpdate',  80 );

% Create the camera
camera = FollowerCamera( rf0 );

% Create the scenario
scen = VehiCool();

% Add the objects to the scenario
scen.set_track( track );
scen.add_camera( camera );
scen.add_root_object( rf0 );
scen.add_root_object( rf0_traj );

%% Animate the scenario

scen.animate( time_sim(end) );

%% EoF

% User:
% Wait, what? I can have deferred updates that easily? I thought I had to do a
% lot of work to get that, but it's just a matter of passing a parameter to the
% constructor? That's awesome!
%
% VehiCool developers:
% Yeah, we know. We're awesome.
