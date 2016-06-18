function [ finished, index, error ] = gripper_followPath( isGlobal, path, errorM, start )

global g_gripper_followPath_path;
global g_gripper_followPath_errorM;
global g_gripper_followPath_index;

if (nargin == 4 && start == true)
    g_gripper_followPath_path = path;
    g_gripper_followPath_errorM = errorM;
    g_gripper_followPath_index = 1;
elseif (nargin == 3 && length(g_gripper_followPath_path) == length(path))
    g_gripper_followPath_path = path;
    g_gripper_followPath_errorM = errorM;
end

pathSize = length(g_gripper_followPath_path);

[ stepfinish, error ] = gripper_seekTarget(isGlobal, g_gripper_followPath_path{g_gripper_followPath_index});

if (error < g_gripper_followPath_errorM(g_gripper_followPath_index)) 
    if (stepfinish == true && g_gripper_followPath_index >= pathSize)
        finished = true;
    elseif (g_gripper_followPath_index < pathSize)
        g_gripper_followPath_index = g_gripper_followPath_index + 1;
        finished = false;
    else
        finished = false;
    end
else
    finished = false;
    
end
index = g_gripper_followPath_index;


end

