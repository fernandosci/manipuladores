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

        p_gripper_path = cell(1,1);
        p_gripper_path{1} = g_youbotPos;
        p_gripper_path{1}(3) =  p_gripper_path{1}(3) + 0.32;
        [ finishedGripper, p_gripper_path_index, ~ ] = gripper_followPath(true,p_gripper_path, true);
        
        if (finishedMove && finishedRotate && finishedGripper)
            g_fsm = 'setGripperPathToTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setGripperPathToTarget'
        continuousMotion;
        
        p_gripper_path = cell(2,1);
        p_gripper_path{1} = (g_target_pos{p_targetIndex});
        p_gripper_path{1}(3) = p_gripper_path{1}(3) + 0.045;
        p_gripper_path{2} = (g_target_pos{p_targetIndex});        
        [ ~, p_gripper_path_index, ~ ] = gripper_followPath(true,p_gripper_path, true);
        
        g_fsm = 'grabTarget';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'grabTarget'
        continuousMotion;
        %gripper_seekTarget(true, p_gripper_path);
        [ finished, index, error ] = gripper_followPath();
        if (finished)
            gripper_open(false);
            nonBlockingDelay(3);
            g_fsm = 'prepShoot';
        end
        fprintf('g_youbot_gripper_tipPos:\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbot_gripper_tipPos(1), g_youbot_gripper_tipPos(2), g_youbot_gripper_tipPos(3));
        fprintf('g_youbot_gripper_targetPos:\t\tX: %f \tY: %f \tZ: %f\n', g_youbot_gripper_targetPos(1), g_youbot_gripper_targetPos(2), g_youbot_gripper_targetPos(3));
        fprintf('g_target_pos{p_targetIndex}:\tX: %f \tY: %f \tZ: %f\n',  g_target_pos{p_targetIndex}(1),  g_target_pos{p_targetIndex}(2),  g_target_pos{p_targetIndex}(3));
        fprintf('g_youbotPos:\t\t\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbotPos(1), g_youbotPos(2), g_youbotPos(3));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'prepShoot'
        continuousMotion;
        [finished] = nonBlockingDelay;
        if (finished)
           
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

