function [ angGlobal ] = angRelativeToGlobal( eulerAngs )
global g_youbotEuler;
angGlobal = g_youbotEuler + eulerAngs;
end

