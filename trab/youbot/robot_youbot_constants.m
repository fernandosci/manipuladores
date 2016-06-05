function [ ] = robot_youbot_constants( )
% Constants:
global g_wheelradius;
global g_timestep;
global g_armJointRanges;
global g_startingJoints;
global g_pickupJoints;
global g_r22tilt;
global g_gripper_max_points;

disp('setting up constants');disp(' ');

g_timestep = .05;
g_wheelradius = 0.0937/2; % This value may be inaccurate. Check before using.

% Min max angles for all joints:
g_armJointRanges = [-2.9496064186096,2.9496064186096;
    -1.5707963705063,1.308996796608;
    -2.2863812446594,2.2863812446594;
    -1.7802357673645,1.7802357673645;
    -1.5707963705063,1.5707963705063 ];
g_startingJoints = [0,30.91*pi/180,52.42*pi/180,72.68*pi/180,0];

% In this demo, we move the arm to a preset pose:
g_pickupJoints = [90*pi/180, 19.6*pi/180, 113*pi/180, -41*pi/180, 0*pi/180];

% Tilt of the Rectangle22 box
g_r22tilt = -44.56/180*pi;

assignin('caller', 'g_wheelradius' ,g_wheelradius );
assignin('caller', 'g_timestep' ,g_timestep );
assignin('caller', 'g_armJointRanges' ,g_armJointRanges );
assignin('caller', 'g_startingJoints' ,g_startingJoints );
assignin('caller', 'g_pickupJoints' ,g_pickupJoints );
assignin('caller', 'g_r22tilt' ,g_r22tilt );

end

