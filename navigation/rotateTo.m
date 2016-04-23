function [ finished, rotVel ] = rotateTo( axis, targetAng )

global g_youbotEuler;
global g_rotateTo_I;
global g_rotateTo_lastError;
global g_rotateTo_targetAng;
global g_rotateTo_isRunning;

maxI = 0.1;
minI = -maxI;
maxOut = 240*pi/180;
minOut = -maxOut;
deltaT = 50e-3;
kp = 1;
ki = 0;
kd = 0;
limitError = 0.01;

if (nargin == 2)
    
    finished = false;
    rotVel = 0;
    
    g_rotateTo_targetAng = sign(targetAng)*wrapTo2Pi(targetAng);
    g_rotateTo_lastError =  g_rotateTo_targetAng - g_youbotEuler;
    disp(targetAng);
    disp(g_rotateTo_targetAng);
    g_rotateTo_I = [0 0 0];
    g_rotateTo_isRunning = true;
elseif (g_rotateTo_isRunning)
    error = g_rotateTo_targetAng - g_youbotEuler;
    
    [ out, g_rotateTo_I(axis), g_rotateTo_lastError(axis) ] = pidYoubot( error(axis), g_rotateTo_lastError(axis), kp, ki, kd, g_rotateTo_I(axis), deltaT, minI, maxI, minOut, maxOut );
    
    
    %fprintf('error: %f \tout: %f \tyoubotEuler: %f\n', error(3),out,g_youbotEuler(axis));
    %globalAngle = angleBetween2CartesianPointsXY(g_youbotPos, g_MoveToPos_targetPos);
    %relativeAngle = angGlobalToRelative([0 0 globalAngle]);
    
    
    
    %outDist = sqrt(out(1)^2 + out(2)^2);
    % outDist = sqrt(out(1)^2 + out(2)^2);
    %negativo -> pra frente (0 graus)
    %forwBackVel = -outDist * cos(relativeAngle(3));
    %positivo -> pra esquerda (90 graus)
    %leftRightVel = outDist * sin(relativeAngle(3));
    
    rotVel = out;
    
    
    if (error(3) > -limitError && error(3) < limitError)
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
