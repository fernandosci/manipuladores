function [ ] = gripper_setJoints( joints_target )
global g_vrep;
global g_id;
global g_h;
global g_youbot_joints_target;
global g_youbot_joints_km_mode;

if (g_youbot_joints_km_mode ~= 0)
res =  g_vrep.simxSetIntegerSignal( g_id, 'km_mode', 0,...
    g_vrep.simx_opmode_oneshot_wait);vrchk(g_vrep, res, true);
    g_youbot_joints_km_mode = 0; %just in case
end

g_youbot_joints_target = joints_target;
for i = 1:5,
    res = g_vrep.simxSetJointTargetPosition(g_id, g_h.armJoints(i), g_youbot_joints_target(i),...
        g_vrep.simx_opmode_streaming);
    vrchk(g_vrep, res, true);
end

end

