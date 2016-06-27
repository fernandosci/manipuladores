function [ ] = robot_youbot_custom_init( )
global g_vrep;
global g_id;
global g_h;

disp('initializing objects');disp(' ');

% This will only work in "continuous remote API server service"
% See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
res = g_vrep.simxStartSimulation(g_id, g_vrep.simx_opmode_oneshot_wait);
vrchk(g_vrep, res);

% Retrieve all handles, and stream arm and wheel joints, the robot's pose,
% the Hokuyo, and the arm tip pose.
temporaryH = youbot_init(g_vrep, g_id);
g_h = youbot_hokuyo_init(g_vrep, temporaryH);

%disable lasers
g_vrep.simxSetIntegerSignal(g_h.id, 'displaylasers', 0, g_vrep.simx_opmode_oneshot);


global g_target_pos;
global g_target_ref;
global g_target_names;
g_target_pos = cell(length(g_target_names),1);
for index = 1:length(g_target_names)
    [res, g_target_ref(index)] = g_vrep.simxGetObjectHandle(g_id, g_target_names{index}, g_vrep.simx_opmode_oneshot_wait);  vrchk(g_vrep, res);
    [res, g_target_pos{index}] = g_vrep.simxGetObjectPosition(g_id, g_target_ref(index), -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);
end

global g_basket_pos;
global g_basket_ref;
[res, g_basket_ref] = g_vrep.simxGetObjectHandle(g_id, 'Basket_ref', g_vrep.simx_opmode_oneshot_wait);  vrchk(g_vrep, res);
[res, g_basket_pos] = g_vrep.simxGetObjectPosition(g_id, g_basket_ref, -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);

res = g_vrep.simxGetObjectVelocity (g_id, g_h.ref, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);

global g_youbot_armRefPos;
global g_youbot_armRefPosOri;
global g_youbot_armRefOri;

[res, g_youbot_armRefPos] = g_vrep.simxGetObjectPosition(g_id, g_h.armRef, -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);
[res, g_youbot_armRefPosOri] = g_vrep.simxGetObjectOrientation(g_id, g_h.armRef, -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);
[res, g_youbot_armRefOri] = g_vrep.simxGetObjectOrientation(g_id, g_h.r22, -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);

% global g_youbot_joints_km_mode;
% global g_youbot_joints_isOpen;
% [res, g_youbot_joints_km_mode] = g_vrep.simxGetIntegerSignal(g_id,'km_mode',g_vrep.simx_opmode_streaming );vrchk(g_vrep, res, true);
% [res, g_youbot_joints_isOpen] = g_vrep.simxGetIntegerSignal(g_id,'gripper_open',g_vrep.simx_opmode_streaming );vrchk(g_vrep, res, true);
global g_youbot_joints_isOpen;
g_youbot_joints_isOpen = -1;
gripper_open(true);

global g_youbot_joints_km_mode;
g_youbot_joints_km_mode = -1;
gripper_setKmMode(0);

global g_startingJoints;
for i = 1:5,
    res = g_vrep.simxSetJointTargetPosition(g_id, g_h.armJoints(i), g_startingJoints(i),...
        g_vrep.simx_opmode_oneshot);
    vrchk(g_vrep, res, true);
end




disp('...');
pause(0.5);

robot_youbot_continuosplot_init;


end

