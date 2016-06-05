function [  ] = userinit(  )
addpath(strcat(pwd,'\youbot'),strcat(pwd,'\youbot\utils'),strcat(pwd,'\youbot\gui'),strcat(pwd,'\youbot\navigation'),strcat(pwd,'\youbot\navigation\utils'),strcat(pwd,'\youbot\gripper'));
global g_VERBOSE;
global g_PLOTDATA;

g_VERBOSE = 0;
g_PLOTDATA = true;

kbhit('init');

end

