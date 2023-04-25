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

load( '../data/adria.mat' );     % racetrack data
load( '../data/state_rf0.mat' ); % state of the main reference frame
load( '../data/time_sim.mat' );  % time vector of the simulation

%% Create the scenario

% Create the racetrack
track = RaceTrack( adria.left_margin, adria.right_margin );

% Create the main reference frame
rf0_T = makehgtform( 'scale', 0.05 ); % initial transformation matrix
rf0   = STLObject( state_rf0, 'InitTrans', rf0_T );

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
% I must admit, this is not the most exciting example. But creating a camera
% is not the most exciting thing to do, either. The point is that VehiCool
% is able to do that in an incredibly easy way, and that's what matters.
%
% VehiCool developers:
% Wait, weren't we supposed to be the ones to say that? Well, thank you user.
