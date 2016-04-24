function [  ] = gripper_open( open )
global g_vrep;
global g_id;
global g_youbot_joints_isOpen;

if (g_youbot_joints_isOpen ~= open)
    res = g_vrep.simxSetIntegerSignal(g_id, 'gripper_open', open, g_vrep.simx_opmode_oneshot_wait);
    g_youbot_joints_isOpen = open;
    vrchk(g_vrep, res);
end

end

