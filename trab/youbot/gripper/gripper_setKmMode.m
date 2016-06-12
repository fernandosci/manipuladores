function [  ] = gripper_setKmMode( mode )
global g_vrep;
global g_id;
global g_youbot_joints_km_mode;

if (g_youbot_joints_km_mode ~= mode)
    res =  g_vrep.simxSetIntegerSignal( g_id, 'km_mode', mode,...
    g_vrep.simx_opmode_oneshot_wait);vrchk(g_vrep, res, true);
    g_youbot_joints_km_mode = mode; %just in case
end

end

