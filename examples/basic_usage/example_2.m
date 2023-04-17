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
rf0   = STLObject( state_rf0(1, :), 'InitTrans', rf0_T );

% Create the camera
camera = FollowerCamera( rf0 );

% Create the scenario
scen = VehiCool();

% Add the objects to the scenario
scen.set_track( track );
scen.add_camera( camera );
scen.add_root_object( rf0 );

%% Animate the scenario one step at a time

% Render the scenario
[fig, ax] = scen.render();

% Animate the scenario
for i = 1 : length( time_sim )

    % Update the state of the reference frame
    rf0.set_state( state_rf0(i, :) );

    % Update the scenario
    scen.advance();

    % Draw the scenario
    drawnow limitrate nocallbacks; % this limits the frame rate to 20 fps and
                                   % avoids unwanted interactions with the
                                   % figure

end

%% EoF

% User:
% I see, so VehiCool is actually able to do this. However, I bet it is not
% capable of multi-body modelling, right?
%
% VehiCool developers:
% Wrong! VehiCool is able to model multi-body systems. Just look at the examples
% in the advanced_usage folder.
