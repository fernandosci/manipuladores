function [ ] = robot_youbot_custom_init( )
global g_vrep;
global g_id;
global g_h;

disp('initializing objects');disp(' ');

% This will only work in "continuous remote API server service"
% See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
res = g_vrep.simxStartSimulation(g_id, g_vrep.simx_opmode_oneshot_wait);
vrchk(g_vrep, res);

% Retrieve all handles, and stream arm and wheel joints, the robot's pose,
% the Hokuyo, and the arm tip pose.
temporaryH = youbot_init(g_vrep, g_id);
g_h = youbot_hokuyo_init(g_vrep, temporaryH);


global g_target_pos;
global g_target_ref;
global g_target_names;
g_target_pos = cell(length(g_target_names),1);
for index = 1:length(g_target_names)
    [res, g_target_ref(index)] = g_vrep.simxGetObjectHandle(g_id, g_target_names{index}, g_vrep.simx_opmode_oneshot_wait);
    vrchk(g_vrep, res);
    [res, g_target_pos{index}] = g_vrep.simxGetObjectPosition(g_id, g_target_ref(index), -1, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);
end

res = g_vrep.simxGetObjectVelocity (g_id, g_h.ref, g_vrep.simx_opmode_streaming); vrchk(g_vrep, res, true);

disp('...');
pause(0.5);

robot_youbot_continuosplot_init;


end

