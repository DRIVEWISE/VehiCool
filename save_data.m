%% Prepare workspace

clear all; close all; clc;

%% Load the data

circuit = 'Adria';

setup.vehicle = 'VW_Golf_EV_with_maps_fast';

% Load the results
logs    = load(strcat('./logs/picci/savedData_',circuit,'_',setup.vehicle)).log_data;
MPC_res = load(strcat('./logs/picci/MPC_res_',circuit,'_',setup.vehicle)).MPC_res;
MLT_res = load(strcat('./logs/picci/MLT_res_',circuit,'_',setup.vehicle)).MLT_res;

% End of first lap indices
fin_idx_1lap = logs.fin_idx_1lap;

% Simultion times
time_sim    = logs.time_sim(1:fin_idx_1lap);
Ts          = time_sim(2) - time_sim(1);
lap_time_VD = logs.time_sim(fin_idx_1lap);

% Chassis velocity and acceleration
vx_MPC         = MPC_res.vx_MPC;
Omega_MPC      = MPC_res.Omega_MPC;
ay_ss_MPC      = Omega_MPC.*vx_MPC;
ax_MPC         = MPC_res.ax_MPC;
vx_MPC_intp    = interp1( MPC_res.time_MPC, vx_MPC, time_sim );
ay_ss_MPC_intp = interp1(MPC_res.time_MPC,ay_ss_MPC,time_sim);
ax_MPC_intp    = interp1(MPC_res.time_MPC,ax_MPC,time_sim);

% Executed rf0 path
x_rf0     = logs.x_veh(1:fin_idx_1lap);
y_rf0     = logs.y_veh(1:fin_idx_1lap);
z_rf0     = 0 * x_rf0;
roll_rf0  = 0 * x_rf0;
pitch_rf0 = 0 * x_rf0;
yaw_rf0   = logs.psi_veh(1:fin_idx_1lap);

% Executed chassis path
x_chassis     = 0 * x_rf0;
y_chassis     = 0 * x_rf0;
z_chassis     = 0 * x_chassis;
roll_chassis  = (pi / 36) * (ay_ss_MPC_intp / max( ay_ss_MPC_intp ));
pitch_chassis = -(pi / 36) * (ax_MPC_intp / max( ax_MPC_intp ));
yaw_chassis   = 0 * x_rf0;

% Executed wheel paths
x_wheels     = 0 * x_chassis;
y_wheels     = 0 * x_chassis;
z_wheels     = 0 * x_chassis;
roll_wheels  = 0 * x_chassis;
pitch_wheels = vx_MPC_intp / 0.3;
yaw_wheels_r = 0 * x_chassis;
yaw_wheels_f = logs.delta_avg(1:fin_idx_1lap);

% Track margins
idxs         = 520:3236;
left_margin  = [MLT_res.xLeftMargin(idxs), MLT_res.yLeftMargin(idxs)];
right_margin = [MLT_res.xRightMargin(idxs), MLT_res.yRightMargin(idxs)];

%% Pack data

adria.left_margin  = left_margin;
adria.right_margin = right_margin;

state_rf0     = [x_rf0, y_rf0, z_rf0, yaw_rf0, pitch_rf0, roll_rf0];
state_chassis = [x_chassis, y_chassis, z_chassis, yaw_chassis, roll_chassis, pitch_chassis];
state_wheel_r = [x_wheels, y_wheels, z_wheels, yaw_wheels_r, roll_wheels, pitch_wheels];
state_wheel_f = [x_wheels, y_wheels, z_wheels, 2 * yaw_wheels_f, roll_wheels, pitch_wheels];

%% Save data

save('examples/data/adria.mat', 'adria');

save('examples/data/state_rf0.mat', 'state_rf0');
save('examples/data/state_chassis.mat', 'state_chassis');
save('examples/data/state_wheel_r.mat', 'state_wheel_r');
save('examples/data/state_wheel_f.mat', 'state_wheel_f');

save('examples/data/time_sim.mat', 'time_sim');
