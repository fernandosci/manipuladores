function [ ] = robot_youbot_constants( )
% Constants:
global g_wheelradius;
global g_timestep;
global g_armJointRanges;
global g_startingJoints;
global g_pickupJoints;
global g_r22tilt;

global g_target_names;

disp('setting up constants');disp(' ');

g_timestep = .05;
g_wheelradius = 0.0937/2; % This value may be inaccurate. Check before using.

% Min max angles for all joints:
%  -169.0000  169.0000
%   -90.0000   75.0000
%  -131.0000  131.0000
%  -102.0000  102.0000
%   -90.0000   90.0000
g_armJointRanges = [-2.9496064186096,2.9496064186096;
    -1.5707963705063,1.308996796608;
    -2.2863812446594,2.2863812446594;
    -1.7802357673645,1.7802357673645;
    -1.5707963705063,1.5707963705063 ];
%g_startingJoints = [0,30.91*pi/180,52.42*pi/180,72.68*pi/180,0];
g_startingJoints = deg2rad([0, 30.91, 52.42, 72.68, 0]);

% In this demo, we move the arm to a preset pose:
g_pickupJoints = [90*pi/180, 19.6*pi/180, 113*pi/180, -41*pi/180, 0*pi/180];
global g_gripper_dropPosition;
g_gripper_dropPosition = [0 -0.28 0.22];

% Tilt of the Rectangle22 box
g_r22tilt = -44.56/180*pi;

g_target_names = cell(5,1);

g_target_names{1} = 'redRectangle_ref';
g_target_names{2} = 'blueRectangle_ref';
g_target_names{3} = 'yellowRectangle_ref';
g_target_names{4} = 'orangeRectangle_ref';
g_target_names{5} = 'greenRectangle_ref';


assignin('caller', 'g_wheelradius' ,g_wheelradius );
assignin('caller', 'g_timestep' ,g_timestep );
assignin('caller', 'g_armJointRanges' ,g_armJointRanges );
assignin('caller', 'g_startingJoints' ,g_startingJoints );
assignin('caller', 'g_pickupJoints' ,g_pickupJoints );
assignin('caller', 'g_r22tilt' ,g_r22tilt );
assignin('caller', 'g_target_names' ,g_target_names );
assignin('caller', 'g_gripper_dropPosition' ,g_gripper_dropPosition );

end

