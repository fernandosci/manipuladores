function [euclideanDistance] = distVector(v1 , v2)
V = v1 - v2;
euclideanDistance = sqrt(V * V');
end

