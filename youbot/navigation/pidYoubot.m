function [ out, I, lastError ] = pidYoubot( error, lastError, kp, ki, kd, I, deltaT, minI, maxI, minOut, maxOut )

P = error * kp;
I = I  + ki * error * deltaT;
D = (kd *(error - lastError))/deltaT;
out = P + I + D;
lastError = error;

if (out > maxOut)
    out = maxOut;
elseif (out < minOut)
    out = minOut;
end

if (I > maxI)
    I = maxI;
elseif (I < minI)
    I = minI;
end

end

