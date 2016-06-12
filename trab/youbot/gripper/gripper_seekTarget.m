function [ finished, error ] = gripper_seekTarget( isGlobal, targetPos, targetOri  )
global g_vrep;
global g_id;
global g_h;
global g_youbot_armRefPos;
global g_youbot_gripper_targetPos;
global g_youbot_gripper_targetOri;

if (nargin < 2 || nargin > 3)
    fprintf('gripper_setTarget-> invalid number of args\n');
    return
end



km_mode = nargin - 1;
gripper_setKmMode(km_mode);

if (isGlobal)
    targetPos = targetPos - g_youbot_armRefPos;
end

g_youbot_gripper_targetPos = targetPos;
if (nargin == 3)
    g_youbot_gripper_targetOri = targetOri;
end


res = g_vrep.simxSetObjectPosition(g_id, g_h.ptarget, g_h.armRef, g_youbot_gripper_targetPos,...
                                      g_vrep.simx_opmode_oneshot);
vrchk(g_vrep, res, true);

res = g_vrep.simxSetObjectOrientation(g_id, g_h.otarget, g_h.r22, g_youbot_gripper_targetOri,...
                                      g_vrep.simx_opmode_oneshot);
vrchk(g_vrep, res, true);

end

