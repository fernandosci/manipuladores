function [ posGlobal ] = posRelativeToGlobalXYZ( pos )
global youbotPos;

posGlobal = youbotPos + pos;

end

