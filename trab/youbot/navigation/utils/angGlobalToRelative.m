function [ angRel ] = angGlobalToRelative( eulerAngs )
global g_youbotEuler;
angRel = eulerAngs - g_youbotEuler;
end

