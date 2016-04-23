function [ ] = robot_youbot_fetch( )
global g_VERBOSE;
global g_youbotPos;
global g_youbotEuler;
global g_vrep;
global g_id;
global g_h;

global g_youbot_hokuyo_pts;
global g_youbot_hokuyo_contacts;

%position and orientation
[res, g_youbotPos] = g_vrep.simxGetObjectPosition(g_id, g_h.ref, -1,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

[res, g_youbotEuler] = g_vrep.simxGetObjectOrientation(g_id, g_h.ref, -1,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);

if (g_youbotEuler(3) < 0)
    g_youbotEuler(3) = 2*pi + g_youbotEuler(3);
end

if (g_VERBOSE >= 1)
    fprintf('X: %f \tY: %f \tZ: %f\tTHETA: %f\n', g_youbotPos(1), g_youbotPos(2), g_youbotPos(3), rad2deg(g_youbotEuler(3)));
end

% Read data from the Hokuyo sensor:
[g_youbot_hokuyo_pts, g_youbot_hokuyo_contacts] = youbot_hokuyo(g_vrep, g_h, g_vrep.simx_opmode_buffer);

global g_target;
global g_target_ref;
[res, g_target] = g_vrep.simxGetObjectPosition(g_id, g_target_ref, -1,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);


end
