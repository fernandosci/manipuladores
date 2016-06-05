function [ pos ] = distRelativeToGlobalXYZ( dist, angDist, axis )
global g_youbotPos;

if nargin < 3
    axis =  'Z';
end

pos = g_youbotPos;

if (axis == 'X' || axis == 1)
    pos(3) = pos(3) + sin(angDist)*dist;
    pos(2) = pos(2) + cos(angDist)*dist;
elseif (axis == 'Y' || axis == 2)
    pos(1) = pos(1) + sin(angDist)*dist;
    pos(3) = pos(3) + cos(angDist)*dist;
elseif (axis == 'Z' || axis == 3)
    pos(2) = pos(2) + sin(angDist)*dist;
    pos(1) = pos(1) + cos(angDist)*dist;
end
end

