function [ result ] = posXYProj( position, angle )


result(1) = cos(angle) * position(1) + sin(angle) * position(2);
result(2) = cos(angle) * position(2) + sin(angle) * position(1);
result(3) = position(3);


end

