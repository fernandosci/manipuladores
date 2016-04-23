function robot_youbot()
addpath(strcat(pwd,'\navigation'),strcat(pwd,'\youbot'));
global g_vrep;
global g_id;
global g_h;
global g_target;
global g_VERBOSE;

settings;
disp('initializing vrep thread');
g_vrep=remApi('remoteApi');
g_vrep.simxFinish(-1);
%should be in main thread
g_id = g_vrep.simxStart('127.0.0.1', 19997, true, true, 2000, 5);

if g_id < 0,
    disp('Failed connecting to remote API server. Exiting.');
    g_vrep.delete();
    return;
end
fprintf('Connection %d to remote API server open.\n', g_id);

% Make sure we close the connexion whenever the script is interrupted. %should be in main thread
cleanupObj = onCleanup(@() cleanup_vrep(g_vrep, g_id));
robot_youbot_constants;
robot_youbot_custom_init;
robot_youbot_fetch;

% Parameters for controlling the youBot's wheels:
forwBackVel = 0;
leftRightVel = 0;
rotVel = 0;

% Make sure everything is settled before we start
pause(2);
disp('Starting robot');


[res homeGripperPosition] = ...
    g_vrep.simxGetObjectPosition(g_id, g_h.ptip,...
    g_h.armRef,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);
fsm = 'rotate';
angl = -pi/2;

robot_youbot_fetch;


moveToPosXY(g_target);
valueToGo = 3*pi/2;
rotateTo(3,valueToGo);

while true,
    tic
    if g_vrep.simxGetConnectionId(g_id) == -1,
        error('Lost connection to remote API.');
    end
    robot_youbot_fetch;
    
    robot_youbot_continuosplot;
    
    robot_youbot_fsm;
    
    
    
    [finished, forwBackVel, leftRightVel] = moveToPosXY;
    [finished, rotVel] = rotateTo(3);
    
    
    
    % Update wheel velocities
    if (g_VERBOSE >= 1)
        fprintf('forwBackVel: %f \tleftRightVel: %f \trotVel: %f\n', forwBackVel, leftRightVel,rotVel);
    end
    g_h = youbot_drive(g_vrep, g_h, forwBackVel, leftRightVel, rotVel);
    
    % Make sure that we do not go faster that the simulator
    elapsed = toc;
    timeleft = g_timestep-elapsed;
    if (timeleft > 0),
        pause(min(timeleft, .01));
    end
end

end % main function

