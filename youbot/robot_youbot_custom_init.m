function [ ] = robot_youbot_custom_init( )
global g_vrep;
global g_id;
global g_h;
global g_target;
global g_target_ref;
global g_startingJoints;

disp('initializing objects');disp(' ');

% This will only work in "continuous remote API server service"
% See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
res = g_vrep.simxStartSimulation(g_id, g_vrep.simx_opmode_oneshot_wait);
vrchk(g_vrep, res);

% Retrieve all handles, and stream arm and wheel joints, the robot's pose,
% the Hokuyo, and the arm tip pose.
temporaryH = youbot_init(g_vrep, g_id);
g_h = youbot_hokuyo_init(g_vrep, temporaryH);


[res, g_target_ref] = g_vrep.simxGetObjectHandle(g_id, 'target', g_vrep.simx_opmode_oneshot_wait); vrchk(g_vrep, res);
[res, g_target] = g_vrep.simxGetObjectPosition(g_id, g_target_ref, -1,...
    g_vrep.simx_opmode_streaming);
vrchk(g_vrep, res, true);

disp('...');
pause(.3);

% Set the arm to its starting configuration:
res = g_vrep.simxPauseCommunication(g_id, true); vrchk(g_vrep, res);
for i = 1:5,
    res = g_vrep.simxSetJointTargetPosition(g_id, g_h.armJoints(i),...
        g_startingJoints(i),...
        g_vrep.simx_opmode_oneshot);
    vrchk(g_vrep, res, true);
end
res = g_vrep.simxPauseCommunication(g_id, false); vrchk(g_vrep, res);

robot_youbot_continuosplot_init;


end

