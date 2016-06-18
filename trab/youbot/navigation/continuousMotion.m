function [ finishedRotate, finishedMove, errRot, errMove ] = continuousMotion(  )
global g_vel;

[finishedRotate, g_vel.rotVel, errRot] = rotateTo();
[finishedMove ,  g_vel.forwBackVel,  g_vel.leftRightVel, errMove] =  moveToPosXY();

end

