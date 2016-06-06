function [ ] = gripper_setTarget( targetPos, targetOri )
global g_vrep;
global g_id;
global g_h;
global g_youbot_gripper_targetPos;
global g_youbot_gripper_targetOri;

if (nargin == 0 || nargin > 2)
    fprintf('gripper_setTarget-> invalid number of args\n');
    return
end

km_mode = nargin;
gripper_setKmMode(km_mode);

g_youbot_gripper_targetPos = targetPos;
if (nargin == 2)
    g_youbot_gripper_targetOri = targetOri;
end

res = g_vrep.simxSetObjectPosition(g_id, g_h.ptarget, g_h.armRef, g_youbot_gripper_targetPos,...
                                      g_vrep.simx_opmode_oneshot);
vrchk(g_vrep, res, true);

end

