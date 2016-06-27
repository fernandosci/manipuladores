function [ data ] = gripper_pathBuilder( varargin )

option = varargin{1};

switch (option)
    case 'one'
        data.path = cell(1,1);
        data.path{1} = varargin{2};
        data.error = zeros(1,1);
        data.pathOri = cell(1,1);
    case 'n'
        data.path = cell((nargin - 1)/2,1);
        data.error = zeros((nargin - 1)/2,1);
        data.pathOri = cell((nargin - 1)/2,1);
        for index=1:(nargin - 1)/2
            data.path{index} = varargin{index*2};
            data.error(index) = varargin{index*2+1};
        end
    case 'n_o'
        data.path = cell((nargin - 1)/3,1);
        data.error = zeros((nargin - 1)/3,1);
        data.pathOri = cell((nargin - 1)/3,1);
        for index=1:(nargin - 1)/3
            data.path{index} = varargin{index*3};
            data.error(index) = varargin{index*3+1};
            data.pathOri(index) = varargin{index*3+2};
        end
end

end

