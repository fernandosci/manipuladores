function [ path, error ] = nav_pathBuilder( varargin )

option = varargin{1};

switch (option)
    case 'n'
        path = cell(nargin - 1,1);
        for index=2:nargin
            path{index} = varargin{index};
        end
end

end

