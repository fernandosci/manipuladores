function[ ] = robot_youbot_fsm( pFsm )
global g_fsm;
global g_vel;

global g_youbotPos;
global g_gripper_dropPosition;

global g_target_pos;

global g_youbot_gripper_tipPos;
global g_youbot_gripper_targetPos;
global g_youbot_joints_position;

global g_basket_pos;

%persistent (global) variables
global p_targetIndex;
global p_youbot_targetPos;
global p_gripper_data;
global p_gripper_path_index;
global p_fsm_localFlags;

gripper_default_error = 0.005;



if nargin == 1
    nextFsm(pFsm);
end

switch (g_fsm)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'init'
        p_targetIndex = 1;
        nextFsm('setTarget');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setTarget'
        canditate1Pos = g_target_pos{p_targetIndex};
        canditate2Pos = g_target_pos{p_targetIndex};
        
        distFromTarget = 0.31;
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
        
        nextFsm('goToNearTarget');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'goToNearTarget'
        [finishedRotate, g_vel.rotVel, err] = rotateTo;
        if (err < pi/10)
            [finishedMove,  g_vel.forwBackVel,  g_vel.leftRightVel, ~] = moveToPosXY;
        else
            finishedMove = false;
        end
        
        [p_gripper_data] = gripper_pathBuilder('n', g_gripper_dropPosition, gripper_default_error);
        [ finishedGripper, p_gripper_path_index, ~ ] = gripper_followPath(false, p_gripper_data, true);
        if (finishedMove && finishedRotate && finishedGripper)
            nextFsm('setGripperPathToTarget');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setGripperPathToTarget'
        continuousMotion;
        
        [p_gripper_data] = gripper_pathBuilder('n', ...
            g_target_pos{p_targetIndex} + [0 0 0.045], gripper_default_error, ...
            g_target_pos{p_targetIndex}, gripper_default_error ...
            );
        [ ~, p_gripper_path_index, ~ ] = gripper_followPath(true, p_gripper_data, true);
        
        nextFsm('grabTarget');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'grabTarget'
        continuousMotion;
        if (p_fsm_localFlags(1) == 0)
            [ finished, ~, ~] = gripper_followPath(true);
            if (finished == true && p_fsm_localFlags(1) == 0)
                gripper_open(false);
                nonBlockingDelay(0.5);
                p_fsm_localFlags(1) = 1;
            end
        end
        if (p_fsm_localFlags(1) == 1)
            [finished] = nonBlockingDelay;
            if (finished)
                nextFsm('retrieveObject');
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'retrieveObject'
        continuousMotion;
        [ p_gripper_data ] = gripper_pathBuilder('n', g_gripper_dropPosition, gripper_default_error);
        [ finishedGripper, p_gripper_path_index, ~ ] = gripper_followPath(false, p_gripper_data, true);
        
        if (finishedGripper == true && p_fsm_localFlags(1) == 0)
            gripper_open(true);
            nonBlockingDelay(0.5);
            p_fsm_localFlags(1) = 1;
        end
        
        if (p_fsm_localFlags(1) == 1)
            [finished] = nonBlockingDelay;
            if (finished)
                g_gripper_dropPosition(3) = g_gripper_dropPosition(3) + 0.06;
                nextFsm('nextTarget');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'setObjective'
        position = g_basket_pos - [0 0.4 0];
        
        [~,  g_vel.forwBackVel,  g_vel.leftRightVel] = moveToPosXY(1, position);
        [~, g_vel.rotVel] = rotateTo(1,pi/2);
        nextFsm('goToNearObjective');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'goToNearObjective'
        [finishedRotate, g_vel.rotVel, err] = rotateTo;
        if (err < pi/10)
            [finishedMove,  g_vel.forwBackVel,  g_vel.leftRightVel, ~] = moveToPosXY;
        else
            finishedMove = false;
        end
        
        [p_gripper_data] = gripper_pathBuilder('n', g_gripper_dropPosition, gripper_default_error);
        [ finishedGripper, p_gripper_path_index, ~ ] = gripper_followPath(false, p_gripper_data, true);
        
        if (finishedMove && finishedRotate && finishedGripper)
            nextFsm('over');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'prepShoot'
        [finished] = nonBlockingDelay;
        if (finished)
            prepJoints = deg2rad([0, -75, -40, -90, 90]);
            gripper_setJoints(prepJoints);
            nonBlockingDelay(3);
            nextFsm('shoot1');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'shoot1'
        [finished] = nonBlockingDelay;
        if (finished)
            fireJoints = deg2rad([0, 75, 131, 102, 90]);
            gripper_setJoints(fireJoints);
            nextFsm('shoot2');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'shoot2'
        if (g_youbot_joints_position(2) > deg2rad(-50))
            gripper_open(true);
            fprintf('OPEN!');
            %nextFsm('setTarget');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'nextTarget'
        %if ( p_targetIndex >= 1)
        if ( p_targetIndex >= length(g_target_pos))
            nextFsm('over');
        else
            p_targetIndex = p_targetIndex + 1;
            nextFsm('setTarget');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'over'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'test'
        gripper_open(false);
        fprintf('g_youbot_gripper_tipPos:\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbot_gripper_tipPos(1), g_youbot_gripper_tipPos(2), g_youbot_gripper_tipPos(3));
        fprintf('g_youbot_gripper_targetPos:\t\tX: %f \tY: %f \tZ: %f\n', g_youbot_gripper_targetPos(1), g_youbot_gripper_targetPos(2), g_youbot_gripper_targetPos(3));
        fprintf('g_target_pos{p_targetIndex}:\tX: %f \tY: %f \tZ: %f\n',  g_target_pos{p_targetIndex}(1),  g_target_pos{p_targetIndex}(2),  g_target_pos{p_targetIndex}(3));
        fprintf('g_youbotPos:\t\t\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbotPos(1), g_youbotPos(2), g_youbotPos(3));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end




end

function nextFsm(nextfsm)
global g_fsm;
global p_fsm_localFlags;
g_fsm = nextfsm;
p_fsm_localFlags = zeros(5,1);
end

