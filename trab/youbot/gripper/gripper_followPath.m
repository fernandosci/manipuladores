function [ finished, index, error ] = gripper_followPath( isGlobal, path, start )

global g_gripper_followPath_path;
global g_gripper_followPath_index;

if (nargin == 3 && start == true)
    g_gripper_followPath_path = path;
    g_gripper_followPath_index = 1;
elseif (nargin == 2 && length(g_gripper_followPath_path) == length(path))
    g_gripper_followPath_path = path;
end

pathSize = length(g_gripper_followPath_path);

[ stepfinish, error ] = gripper_seekTarget(isGlobal, g_gripper_followPath_path{g_gripper_followPath_index});

if (stepfinish)
    if (g_gripper_followPath_index >= pathSize)
        finished = true;
    else
        g_gripper_followPath_index = g_gripper_followPath_index + 1;
        finished = false;
    end
else
    finished = false;
    
end
index = g_gripper_followPath_index;


end

