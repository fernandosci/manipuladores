function [ finished, index, error ] = gripper_followPath( isGlobal, data, start )

global g_gripper_followPath_path;
global g_gripper_followPath_error;
global g_gripper_followPath_pathOri;
global g_gripper_followPath_index;

if (nargin == 3 && start == true)
    g_gripper_followPath_path = data.path;
    g_gripper_followPath_error = data.error;
    g_gripper_followPath_index = 1;
    g_gripper_followPath_pathOri = data.pathOri;
elseif (nargin == 2 && length(g_gripper_followPath_path) == length(data.path))
    g_gripper_followPath_path = data.path;
    g_gripper_followPath_error = data.error;
    g_gripper_followPath_pathOri = data.pathOri;
end

pathSize = length(g_gripper_followPath_path);

[ stepfinish, error ] = gripper_seekTarget(isGlobal, g_gripper_followPath_path{g_gripper_followPath_index});

if (error < g_gripper_followPath_error(g_gripper_followPath_index)) 
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

