%%

close all; clear all; clc;

%%

state = zeros(1, 6);
T_rr  = makehgtform( 'translate', [-5,   -3,   0] );
T_rl  = makehgtform( 'translate', [-5,    3,   0] );
T_fr  = makehgtform( 'translate', [ 5.3, -2.8, 0] );
T_fl  = makehgtform( 'translate', [ 5.3,  2.8, 0] );

%%

chassis  = Object3D( state, 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Body.stl' );
wheel_rr = Object3D( state, 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', 'InitTrans', T_rr, 'Parent', chassis );
wheel_rl = Object3D( state, 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', 'InitTrans', T_rl, 'Parent', chassis );
wheel_fr = Object3D( state, 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_R.stl', 'InitTrans', T_fr, 'Parent', chassis );
wheel_fl = Object3D( state, 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition_Wheel_L.stl', 'InitTrans', T_fl, 'Parent', chassis );

%%

T_chassis = makehgtform( 'translate', [2, 2, 0], 'zrotate', pi / 6 );
T_wheels  = makehgtform( 'zrotate', pi / 6, 'xrotate', pi / 6 );

%%

figure();
axis equal;

light( gca, 'Style', 'infinite' );
lighting( gca, 'gouraud' );

chassis.plot( gca );
wheel_rr.plot( gca );
wheel_rl.plot( gca );
wheel_fr.plot( gca );
wheel_fl.plot( gca );

figure();
axis equal;

light( gca, 'Style', 'infinite' );
lighting( gca, 'gouraud' );

chassis.transform( T_chassis );
wheel_fr.transform( T_wheels );
wheel_fl.transform( T_wheels );
wheel_rr.transform( T_wheels );
wheel_rl.transform( T_wheels );

chassis.plot( gca );
wheel_rr.plot( gca );
wheel_rl.plot( gca );
wheel_fr.plot( gca );
wheel_fl.plot( gca );
