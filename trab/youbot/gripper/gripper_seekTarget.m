function [ finished, error ] = gripper_seekTarget( isGlobal, targetPos, targetOri  )
global g_vrep;
global g_id;
global g_h;
global g_youbot_armRefPos;
global g_youbot_armRefPosOri;
global g_youbot_gripper_targetPos;
global g_youbot_gripper_targetOri;
global g_youbot_gripper_tipPos;

if (nargin < 2 || nargin > 3)
    fprintf('gripper_setTarget-> invalid number of args\n');
    return
end



km_mode = nargin - 1;
gripper_setKmMode(km_mode);

rotm = eul2r(g_youbot_armRefPosOri);

if (isGlobal)
    g_youbot_gripper_targetPos = (rotm'*(targetPos - g_youbot_armRefPos)')';
end

if (nargin >= 3)
    g_youbot_gripper_targetOri = targetOri;
end


res = g_vrep.simxSetObjectPosition(g_id, g_h.ptarget, g_h.armRef, g_youbot_gripper_targetPos,...
    g_vrep.simx_opmode_oneshot);
vrchk(g_vrep, res, true);

if (nargin >= 3)
    res = g_vrep.simxSetObjectOrientation(g_id, g_h.otarget, g_h.r22, g_youbot_gripper_targetOri,...
        g_vrep.simx_opmode_oneshot);
    vrchk(g_vrep, res, true);
end


error = distVector(g_youbot_gripper_targetPos,g_youbot_gripper_tipPos);

if (error < 0.005)
    finished = true;
else
    finished = false;
end

end

