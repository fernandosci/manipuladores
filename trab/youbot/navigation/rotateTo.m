function [ finished, rotVel, err ] = rotateTo(mode, targetAng )

global g_youbotEuler;
global g_rotateTo_I;
global g_rotateTo_lastError;
global g_rotateTo_targetAng;
global g_rotateTo_isRunning;
global g_rotateTo_mode;
global g_rotateTo_axis;

maxI = 0.1;
minI = -maxI;
maxOut = 240*pi/180;
minOut = -maxOut;
deltaT = 50e-3;
kp = 1;
ki = 0;
kd = 0;
limitError = 0.01;
axis = 3;

if (nargin == 3)
    
    finished = false;
    rotVel = 0;
    
    g_rotateTo_targetAng = sign(targetAng)*wrapTo2Pi(targetAng);
    g_rotateTo_lastError =  g_rotateTo_targetAng - g_youbotEuler;
    disp(targetAng);
    disp(g_rotateTo_targetAng);
    g_rotateTo_I = [0 0 0];
    g_rotateTo_isRunning = true;
    g_rotateTo_mode = mode;
    g_rotateTo_axis = axis;
elseif (g_rotateTo_isRunning || g_rotateTo_mode == 1)
    error = g_rotateTo_targetAng - g_youbotEuler;
    
    [ out, g_rotateTo_I(g_rotateTo_axis), g_rotateTo_lastError(g_rotateTo_axis) ] = pidYoubot( error(g_rotateTo_axis), g_rotateTo_lastError(g_rotateTo_axis), kp, ki, kd, g_rotateTo_I(g_rotateTo_axis), deltaT, minI, maxI, minOut, maxOut );
    
    
    %fprintf('error: %f \tout: %f \tyoubotEuler: %f\n', error(3),out,g_youbotEuler(axis));
    %globalAngle = globalAngleBetween2CartesianPointsXY(g_youbotPos, g_MoveToPos_targetPos);
    %relativeAngle = angGlobalToRelative([0 0 globalAngle]);
    
    
    
    %outDist = sqrt(out(1)^2 + out(2)^2);
    % outDist = sqrt(out(1)^2 + out(2)^2);
    %negativo -> pra frente (0 graus)
    %forwBackVel = -outDist * cos(relativeAngle(3));
    %positivo -> pra esquerda (90 graus)
    %leftRightVel = outDist * sin(relativeAngle(3));
    
    rotVel = out;
    err = error(g_rotateTo_axis);
    
    if (error(g_rotateTo_axis) > -limitError && error(g_rotateTo_axis) < limitError)
        finished = true;
        rotVel = 0;
        g_rotateTo_isRunning = false;
    else
        finished = false;
    end
else
    finished = true;
    rotVel = 0;
end

end
