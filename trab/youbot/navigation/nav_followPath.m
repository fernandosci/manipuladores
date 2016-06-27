function [ finished, index, forwBackVel, leftRightVel ] = nav_followPath(  mode, path, start )

global g_nav_followPath_path;
global g_nav_followPath_index;

if (nargin == 3 && start == true)
    g_nav_followPath_path = path;
    g_nav_followPath_index = 1;
elseif (nargin == 2 && length(g_nav_followPath_path) == length(path))
    g_nav_followPath_path = path;
end

pathSize = length(g_nav_followPath_path);

[stepfinish,  forwBackVel,  leftRightVel] =  moveToPosXY(mode, g_nav_followPath_path{g_nav_followPath_index});

if (stepfinish == true && g_nav_followPath_index >= pathSize)
    finished = true;
elseif (g_nav_followPath_index < pathSize)
    g_nav_followPath_index = g_nav_followPath_index + 1;
    finished = false;
else
    finished = false;
end
index = g_nav_followPath_index;

end

