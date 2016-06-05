function [ result ] = angleBetween2CartesianPointsXY( p1, p2 )
result = atan2( p2(2) - p1(2), p2(1) - p1(1));
result = result + pi/2; %conversion to global orientation
end

