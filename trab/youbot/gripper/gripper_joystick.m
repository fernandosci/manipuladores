function [  ] = gripper_joystick(  )
global g_vrep;
global g_id;
global g_h;

global g_youbot_gripper_tipPos;
global g_youbot_gripper_tipOri;
global g_youbot_joints_position;

tpos = g_youbot_gripper_tipPos;

gripper_setKmMode(1);

key = kbhit;
inc = 0.05;

if (strcmpi(key, 'a')),
    tpos(1) = tpos(1) + inc;
elseif (strcmpi(key, 'd')),
    tpos(1) = tpos(1) - inc;
elseif (strcmpi(key, 's')),
    tpos(2) = tpos(2) + inc;
elseif (strcmpi(key, 'w')),
    tpos(2) = tpos(2) - inc;
elseif (strcmpi(key, 'z')),
    tpos(3) = tpos(3) + inc;
elseif (strcmpi(key, 'x')),
    tpos(3) = tpos(3) - inc;
elseif (strcmpi(key, 'p')),
    tpos =  [-0.001114 	 0.344160 	 0.029762];
elseif (strcmpi(key, 'l')),
    tpos =  [-0.000272 	 0.403887 	 0.099154];
end



res = g_vrep.simxSetObjectPosition(g_id, g_h.ptarget, g_h.armRef, tpos,...
    g_vrep.simx_opmode_oneshot);

fprintf('g_youbotGripperTipPos:      [%f %f %f]\n',g_youbot_gripper_tipPos(1),g_youbot_gripper_tipPos(2),g_youbot_gripper_tipPos(3));
fprintf('g_youbot_joints_position:   [%f %f %f %f %f]\n',g_youbot_joints_position(1),g_youbot_joints_position(2),g_youbot_joints_position(3),g_youbot_joints_position(4),g_youbot_joints_position(5));

end

