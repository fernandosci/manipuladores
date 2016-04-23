function [ finished, forwBackVel, leftRightVel ] = moveToPosXY( targetPos )

global g_youbotPos;
global g_MoveToPos_I;
global g_MoveToPos_lastError;
global g_MoveToPos_targetPos;
global g_MoveToPos_isRunning;

maxI = 0.1;
minI = -maxI;
maxOut = 240*pi/180;
minOut = -maxOut;
deltaT = 50e-3;
kp = 5;
ki = 0;
kd = 2;
limitError = 0.01;

if (nargin == 1)
    
    finished = false;
    forwBackVel = 0;
    leftRightVel = 0;
    
    g_MoveToPos_targetPos = targetPos;
    g_MoveToPos_lastError =  targetPos - g_youbotPos;
    g_MoveToPos_I = [0 0];
    g_MoveToPos_isRunning = true;
elseif (g_MoveToPos_isRunning)
    error = g_MoveToPos_targetPos - g_youbotPos;
    out = [0 0];
    for index = 1:2
        [ out(index), g_MoveToPos_I(index), g_MoveToPos_lastError(index) ] = pidYoubot( error(index), g_MoveToPos_lastError(index), kp, ki, kd, g_MoveToPos_I(index), deltaT, minI, maxI, minOut, maxOut );
    end
    
    %fprintf('error1: %f \t error2: %f\t \n', error(1), error(2));
    globalAngle = angleBetween2CartesianPointsXY(g_youbotPos, g_MoveToPos_targetPos);
    relativeAngle = angGlobalToRelative([0 0 globalAngle]);
    
    
    
    outDist = sqrt(out(1)^2 + out(2)^2);
    % outDist = sqrt(out(1)^2 + out(2)^2);
    %negativo -> pra frente (0 graus)
    %forwBackVel = -outDist * cos(relativeAngle(3));
    %positivo -> pra esquerda (90 graus)
    %leftRightVel = outDist * sin(relativeAngle(3));
    
    forwBackVel = -outDist * cos(relativeAngle(3));
    leftRightVel = outDist * sin(relativeAngle(3));
    
    
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
end
end

