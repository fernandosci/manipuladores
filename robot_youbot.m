function youbot()
addpath(strcat(pwd,'\navigation'),strcat(pwd,'\youbot'));
global g_vrep;
global g_id;
global g_h;
global g_target;

disp('initializing vrep setup');
g_vrep=remApi('remoteApi');
g_vrep.simxFinish(-1);
g_id = g_vrep.simxStart('127.0.0.1', 19997, true, true, 2000, 5);

if g_id < 0,
    disp('Failed connecting to remote API server. Exiting.');
    g_vrep.delete();
    return;
end
fprintf('Connection %d to remote API server open.\n', g_id);

% Make sure we close the connexion whenever the script is interrupted.
cleanupObj = onCleanup(@() cleanup_vrep(g_vrep, g_id));

% This will only work in "continuous remote API server service"
% See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
res = g_vrep.simxStartSimulation(g_id, g_vrep.simx_opmode_oneshot_wait);
vrchk(g_vrep, res);

% Retrieve all handles, and stream arm and wheel joints, the robot's pose,
% the Hokuyo, and the arm tip pose.
temporaryH = youbot_init(g_vrep, g_id);
g_h = youbot_hokuyo_init(g_vrep, temporaryH);

global g_target_ref;
[res, g_target_ref] = g_vrep.simxGetObjectHandle(g_id, 'target', g_vrep.simx_opmode_oneshot_wait); vrchk(g_vrep, res);
[res, g_target] = g_vrep.simxGetObjectPosition(g_id, g_target_ref, -1,...
    g_vrep.simx_opmode_streaming);
vrchk(g_vrep, res, true);

disp('...');
pause(.3);

disp('setting up constants');disp(' ');
setupConstants;


% Parameters for controlling the youBot's wheels:
forwBackVel = 0;
leftRightVel = 0;
rotVel = 0;
prevOri = 0; prevLoc = 0;

disp('Starting robot');

% Set the arm to its starting configuration:
res = g_vrep.simxPauseCommunication(g_id, true); vrchk(g_vrep, res);
for i = 1:5,
    res = g_vrep.simxSetJointTargetPosition(g_id, g_h.armJoints(i),...
        g_startingJoints(i),...
        g_vrep.simx_opmode_oneshot);
    vrchk(g_vrep, res, true);
end
res = g_vrep.simxPauseCommunication(g_id, false); vrchk(g_vrep, res);

plotData = true;
if plotData,
    subplot(211)
    drawnow;
    [X,Y] = meshgrid(-5:.25:5,-5.5:.25:2.5);
    X = reshape(X, 1, []);
    Y = reshape(Y, 1, []);
end

% Make sure everything is settled before we start
pause(2);



[res homeGripperPosition] = ...
    g_vrep.simxGetObjectPosition(g_id, g_h.ptip,...
    g_h.armRef,...
    g_vrep.simx_opmode_buffer);
vrchk(g_vrep, res, true);
fsm = 'rotate';
angl = -pi/2;

fetchYouBotStatus;


moveToPosXY(g_target);
valueToGo = 3*pi/2;
rotateTo(3,valueToGo);
            
while true,
    tic
    if g_vrep.simxGetConnectionId(g_id) == -1,
        error('Lost connection to remote API.');
    end
    
    fetchYouBotStatus;
    
    
    
   [finished, forwBackVel, leftRightVel] = moveToPosXY;
   [finished, rotVel] = rotateTo(3);
    
  
    
    % Update wheel velocities
    fprintf('forwBackVel: %f \tleftRightVel: %f \trotVel: %f\n', forwBackVel, leftRightVel,rotVel);
    g_h = youbot_drive(g_vrep, g_h, forwBackVel, leftRightVel, rotVel);
    
    % Make sure that we do not go faster that the simulator
    elapsed = toc;
    timeleft = g_timestep-elapsed;
    if (timeleft > 0),
        pause(min(timeleft, .01));
    end
end

end % main function

