function [ path, error ] = gripper_pathBuilder( varargin )

option = varargin{1};

switch (option)
    case 'one'
        path = cell(1,1);
        path{1} = varargin{2};
    case 'n'
        path = cell((nargin - 1)/2,1);
        error = zeros((nargin - 1)/2,1);
        for index=1:(nargin - 1)/2
            path{index} = varargin{index*2};
            error(index) = varargin{index*2+1};
        end
end

end

