function [ ] = robot_youbot_fetch( )
global g_VERBOSE;

global g_vrep;
global g_id;
global g_h;

%gripper
global g_youbot_armRefPos;
global g_youbot_GripperTipPos;
global g_youbot_GripperTipOri;

global g_youbot_joints_position;
global g_youbot_joints_km_mode;
global g_youbot_joints_isOpen;


%infrared sensor
global g_youbot_hokuyo_pts;
global g_youbot_hokuyo_contacts;

%box target
global g_target_pos;
global g_target_ref;
for index = 1:length(g_target_pos)
    [res, g_target_pos{index}] = g_vrep.simxGetObjectPosition(g_id, g_target_ref(index), -1,...
    g_vrep.simx_opmode_buffer);
    vrchk(g_vrep, res, true);
end

% not expected to move...
% global g_basket_pos;
% global g_basket_ref;
% [res, g_basket_pos] = g_vrep.simxGetObjectPosition(g_id, g_basket_ref, -1,...
%     g_vrep.simx_opmode_buffer);
%     vrchk(g_vrep, res, true);

%position and orientation
global g_youbotPos;
global g_youbotEuler;

[res, g_youbotPos] = g_vrep.simxGetObjectPosition(g_id, g_h.ref, -1,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

[res, g_youbotEuler] = g_vrep.simxGetObjectOrientation(g_id, g_h.ref, -1,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

if (g_youbotEuler(3) < 0)
    g_youbotEuler(3) = 2*pi + g_youbotEuler(3);
end

if (g_VERBOSE >= 1)
    fprintf('X: %f \tY: %f \tZ: %f\tTHETA: %f\n', g_youbotPos(1), g_youbotPos(2), g_youbotPos(3), rad2deg(g_youbotEuler(3)));
end


%velocity
global g_youbotVelLin;
global g_youbotVelAng;

[res, g_youbotVelLin, g_youbotVelAng ] = g_vrep.simxGetObjectVelocity (g_id, g_h.ref, g_vrep.simx_opmode_buffer ); vrchk(g_vrep, res, true);

% Read data from the Hokuyo sensor:
[g_youbot_hokuyo_pts, g_youbot_hokuyo_contacts] = youbot_hokuyo(g_vrep, g_h, g_vrep.simx_opmode_buffer);


%read gripper info
[res, g_youbot_GripperTipPos] = g_vrep.simxGetObjectPosition(g_id, g_h.ptip, g_h.armRef,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);
[res, g_youbot_GripperTipOri] = g_vrep.simxGetObjectOrientation(g_id, g_h.otip, g_h.r22,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

[res, g_youbot_armRefPos] = g_vrep.simxGetObjectPosition(g_id, g_h.armRef, -1, g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);
[res, g_youbot_armRefOri] = g_vrep.simxGetObjectOrientation(g_id, g_h.r22, -1, g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

for i = 1:5,
    [res, g_youbot_joints_position(i)] = g_vrep.simxGetJointPosition(g_id, g_h.armJoints(i), g_vrep.simx_opmode_buffer ); vrchk(g_vrep, res, true);
end

[res, g_youbot_joints_km_mode] = g_vrep.simxGetIntegerSignal(g_id,'km_mode',g_vrep.simx_opmode_buffer );vrchk(g_vrep, res, true);
[res, g_youbot_joints_isOpen] = g_vrep.simxGetIntegerSignal(g_id,'gripper_open',g_vrep.simx_opmode_buffer );vrchk(g_vrep, res, true);

end
