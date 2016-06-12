function[ ] = robot_youbot_fsm( pFsm )
global g_fsm;
global g_vel;
global g_youbotPos;
global g_youbotEuler;
global g_target_pos;
global g_youbot_GripperTipPos;

%persistent (global) variables
global p_targetIndex;
global p_targetPos;

global g_youbot_gripper_targetPos;

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
        
        canditate1Pos(1) = canditate1Pos(1) + 0.3;
        canditate2Pos(1) = canditate2Pos(1) - 0.3;
        if (distPoints(canditate1Pos, g_youbotPos) < distPoints(canditate2Pos, g_youbotPos))
            p_targetPos = canditate1Pos;
        else
            p_targetPos = canditate2Pos;
        end
        
        angle = globalAngleBetween2CartesianPointsXY(g_target_pos{p_targetIndex}, p_targetPos);
        angle = angle + pi/2;
        
        [~,  g_vel.forwBackVel,  g_vel.leftRightVel] =  moveToPosXY(1, p_targetPos);
        [~, g_vel.rotVel] = rotateTo(1,angle);
        g_fsm = 'goToNearTarget';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'goToNearTarget'
        [finishedRotate, g_vel.rotVel] = rotateTo();
        [finishedMove ,  g_vel.forwBackVel,  g_vel.leftRightVel] =  moveToPosXY();
      
        
        
        if (finishedMove && finishedRotate)
            gripper_setTarget(true, g_target_pos{p_targetIndex},g_target_pos{p_targetIndex} -  g_youbot_GripperTipPos);
             fprintf('g_youbot_GripperTipPos:\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbot_GripperTipPos(1), g_youbot_GripperTipPos(2), g_youbot_GripperTipPos(3));
         fprintf('g_youbot_gripper_targetPos:\t\tX: %f \tY: %f \tZ: %f\n', g_youbot_gripper_targetPos(1), g_youbot_gripper_targetPos(2), g_youbot_gripper_targetPos(3));
         fprintf('g_target_pos{p_targetIndex}:\tX: %f \tY: %f \tZ: %f\n',  g_target_pos{p_targetIndex}(1),  g_target_pos{p_targetIndex}(2),  g_target_pos{p_targetIndex}(3));
         fprintf('g_youbotPos:\t\t\t\t\tX: %f \tY: %f \tZ: %f\n',  g_youbotPos(1), g_youbotPos(2), g_youbotPos(3));

            %g_fsm = 'grabTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'grabTarget'
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'nextTarget'
        if ( p_targetIndex >= length(g_target_pos))
            g_fsm = 'over';
        else
            p_targetIndex = p_targetIndex + 1;
            g_fsm = 'setTarget';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'over'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'test'
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end




end

