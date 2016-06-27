function robot_youbot()
global g_vrep;
global g_id;
global g_h;
global g_timestep;
global g_VERBOSE;
global g_time_elapsed;

userinit;
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

% Make sure we close the connexion whenever the script is interrupted. %must be in main thread
cleanupObj = onCleanup(@() custom_cleanup );

%initialize everything
robot_youbot_constants;
robot_youbot_custom_init;
robot_youbot_fetch;

% Parameters for controlling the youBot's wheels:
global g_vel;
g_vel.forwBackVel = 0;
g_vel.leftRightVel = 0;
g_vel.rotVel = 0;

% Make sure everything is settled before we start
pause(2);
disp('Starting robot');

robot_youbot_fetch;

robot_youbot_fsm('init');
global g_youbot_gripper_tipPos;
while true,
    tic
    if g_vrep.simxGetConnectionId(g_id) == -1,
        error('Lost connection to remote API.');
    end
    robot_youbot_fetch;
    
    robot_youbot_continuosplot;
    
    robot_youbot_fsm;
    
    %joints = deg2rad([0, 75, 131, 102, 0]);
    %gripper_setJoints(joints);
    
    %gripper_joystick;
    %disp(g_youbot_gripper_tipPos);
    
    %     key = kbhit;
    %     if (strcmpi(key,'L'))
    %         gripper_setJoints([-0.000101 1.139116 -0.123400 0.097244 0.000681]);
    %     elseif (strcmpi(key,'P'))
    %         gripper_setJoints([-3.132165 1.309131 0.916073 -0.011899 0.004175]);
    %     end
    
    
    % Update wheel velocities
    if (g_VERBOSE >= 1)
        fprintf('forwBackVel: %f \tleftRightVel: %f \trotVel: %f\n', g_vel.forwBackVel, g_vel.leftRightVel, g_vel.rotVel);
    end
    g_h = youbot_drive(g_vrep, g_h, g_vel.forwBackVel, g_vel.leftRightVel, g_vel.rotVel);
    g_vel.forwBackVel = 0;
    g_vel.leftRightVel = 0;
    g_vel.rotVel = 0;
    % Make sure that we do not go faster that the simulator
    g_time_elapsed = toc;
    timeleft = g_timestep-g_time_elapsed;
    if (timeleft > 0),
        pause(min(timeleft, .01));
    end
end

end % main function


function [] = custom_cleanup()
disp('cleanning up...');
global g_vrep;
global g_id;
kbhit('stop');
cleanup_vrep(g_vrep, g_id)
disp('exitting');
end

