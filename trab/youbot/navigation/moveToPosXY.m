function [ finished, forwBackVel, leftRightVel, err ] = moveToPosXY(mode, targetPos )

global g_youbotPos;
global g_MoveToPos_I;
global g_MoveToPos_lastError;
global g_MoveToPos_targetPos;
global g_MoveToPos_isRunning;
global g_MoveToPos_mode;

maxI = 0.1;
minI = -maxI;
maxOut = 2;
minOut = -maxOut;
deltaT = 50e-3;
kp = 1.6;
ki = 0;
kd = 0;
limitError = 0.01;

if (nargin == 2)
    
    finished = false;
    forwBackVel = 0;
    leftRightVel = 0;
    
    g_MoveToPos_targetPos = targetPos;
    g_MoveToPos_lastError =  targetPos - g_youbotPos;
    g_MoveToPos_I = [0 0];
    g_MoveToPos_isRunning = true;
    g_MoveToPos_mode = mode;
    err = 0;
elseif (g_MoveToPos_isRunning == true || g_MoveToPos_mode == 1)
    error = g_MoveToPos_targetPos - g_youbotPos;
    out = [0 0];
    for index = 1:2
        [ out(index), g_MoveToPos_I(index), g_MoveToPos_lastError(index) ] = pidYoubot( error(index), g_MoveToPos_lastError(index), kp, ki, kd, g_MoveToPos_I(index), deltaT, minI, maxI, minOut, maxOut );
    end
    
    %fprintf('error1: %f \t error2: %f\t \n', error(1), error(2));
    globalAngle = globalAngleBetween2CartesianPointsXY(g_youbotPos, g_MoveToPos_targetPos);
    relativeAngle = angGlobalToRelative([0 0 globalAngle]);

    outDist = sqrt(out(1)^2 + out(2)^2);
    % outDist = sqrt(out(1)^2 + out(2)^2);
    %negativo -> pra frente (0 graus)
    %forwBackVel = -outDist * cos(relativeAngle(3));
    %positivo -> pra esquerda (90 graus)
    %leftRightVel = outDist * sin(relativeAngle(3));
    
    forwBackVel = -outDist * cos(relativeAngle(3));
    leftRightVel = outDist * sin(relativeAngle(3));
    
    err = outDist;
    if (outDist > -limitError && outDist < limitError)
        finished = true;
        forwBackVel = 0;
        leftRightVel = 0;
        g_MoveToPos_isRunning = false;
    else
        finished = false;
    end
    %fprintf('out1: %f\tout2: %f\t\n',out(1), out(2));
    %fprintf('outDist: %f \tglobalTargetAngle: %f \trelative Angle: %f\n\n', outDist, rad2deg( globalAngle), rad2deg(relativeAngle(3)));
else
    finished = true;
    forwBackVel = 0;
    leftRightVel = 0;
    err = 0;
end
end

