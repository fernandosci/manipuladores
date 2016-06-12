function [ ori ] = oriFromVector( vector )
ori(1) = atan2(vector(3),vector(2));
ori(2) = atan2(vector(1),vector(3));
ori(3) = atan2(vector(2),vector(1));
end

