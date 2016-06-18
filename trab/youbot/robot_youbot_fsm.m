function[ ] = robot_youbot_fsm( pFsm )
global g_fsm;
global g_vel;
global g_youbotPos;
global g_youbotEuler;
global g_target_pos;
global g_youbot_armRefPos;
global g_youbot_gripper_tipPos;
global g_youbot_gripper_targetPos;

%persistent (global) variables
global p_targetIndex;
global p_youbot_targetPos;
global p_gripper_path;
global p_gripper_path_index;

gripper_default_error = 0.005;



if nargin == 1
    g_fsm =  pFsm;
end

switch (g_fsm)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'init'
        p_targetIndex = 1;
        g_fsm = 'setTarget';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setTarget'
        canditate1Pos = g_target_pos{p_targetIndex};
        canditate2Pos = g_target_pos{p_targetIndex};
        
        distFromTarget = 0.32;
        canditate1Pos(1) = canditate1Pos(1) + distFromTarget;
        canditate2Pos(1) = canditate2Pos(1) - distFromTarget;
        if (distPoints(canditate1Pos, g_youbotPos) < distPoints(canditate2Pos, g_youbotPos))
            p_youbot_targetPos = canditate1Pos;
            angle = globalAngleBetween2CartesianPointsXY(g_target_pos{p_targetIndex}, p_youbot_targetPos);
            angle = angle + pi/2;
        else
            p_youbot_targetPos = canditate2Pos;
            angle = globalAngleBetween2CartesianPointsXY(g_target_pos{p_targetIndex}, p_youbot_targetPos);
            angle = angle - pi/2;
        end
        
        [~,  g_vel.forwBackVel,  g_vel.leftRightVel] =  moveToPosXY(1, p_youbot_targetPos);
        [~, g_vel.rotVel] = rotateTo(1,angle);
        
        g_fsm = 'goToNearTarget';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'goToNearTarget'
        [finishedRotate, g_vel.rotVel, err] = rotateTo;
        if (err < pi/10)
            [finishedMove,  g_vel.forwBackVel,  g_vel.leftRightVel, ~] = moveToPosXY;
        else
            finishedMove = false;
        end
        
        [p_gripper_path, errorM ]= gripper_pathBuilder('n', g_youbotPos + [0 0 0.32], gripper_default_error);
        [ finishedGripper, p_gripper_path_index, ~ ] = gripper_followPath(true,p_gripper_path, errorM, true);
        
        if (finishedMove && finishedRotate && finishedGripper)
            g_fsm = 'setGripperPathToTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setGripperPathToTarget'
        continuousMotion;
        
        [p_gripper_path, errorM ] = gripper_pathBuilder('n', ...
            g_target_pos{p_targetIndex} + [0 0 0.045], gripper_default_error, ...
            g_target_pos{p_targetIndex}, gripper_default_error ...
            );
        [ ~, p_gripper_path_index, ~ ] = gripper_followPath(true,p_gripper_path, errorM, true);
        
        g_fsm = 'grabTarget';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'grabTarget'
        continuousMotion;
        %gripper_seekTarget(true, p_gripper_path);
        [ finished, ~, ~] = gripper_followPath(true);
        if (finished)
            gripper_open(false);
            nonBlockingDelay(0.5);
            g_fsm = 'prepShoot';
        end
        fprintf('g_youbot_gripper_tipPos:\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbot_gripper_tipPos(1), g_youbot_gripper_tipPos(2), g_youbot_gripper_tipPos(3));
        fprintf('g_youbot_gripper_targetPos:\t\tX: %f \tY: %f \tZ: %f\n', g_youbot_gripper_targetPos(1), g_youbot_gripper_targetPos(2), g_youbot_gripper_targetPos(3));
        fprintf('g_target_pos{p_targetIndex}:\tX: %f \tY: %f \tZ: %f\n',  g_target_pos{p_targetIndex}(1),  g_target_pos{p_targetIndex}(2),  g_target_pos{p_targetIndex}(3));
        fprintf('g_youbotPos:\t\t\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbotPos(1), g_youbotPos(2), g_youbotPos(3));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'prepShoot'
        [finished] = nonBlockingDelay;
        lowerror = 0.05;
        if (finished)
             [p_gripper_path, errorM ] = gripper_pathBuilder('n', ...
                [0 0.4 0.4], lowerror, ...
                [0 0.3 0.01], lowerror, ...
                [0 0.15 0.03], lowerror, ...
                [0 0.5 0.5], lowerror...
                );
            [ ~, p_gripper_path_index, ~ ] = gripper_followPath(false,p_gripper_path, errorM, true);
            g_fsm = 'shoot';
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'shoot'
        [ finished, p_gripper_path_index, error] = gripper_followPath(false);
        if (finished)
            g_fsm = 'nextTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'nextTarget'
        if ( p_targetIndex >= 1)
            %if ( p_targetIndex >= length(g_target_pos))
            g_fsm = 'over';
        else
            p_targetIndex = p_targetIndex + 1;
            g_fsm = 'setTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'over'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'test'
        gripper_open(false);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end




end

