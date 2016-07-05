function [  ] = userinit(  )
addpath(strcat(pwd,'\trs\matlab'));
addpath(strcat(pwd,'\youbot'),strcat(pwd,'\youbot\utils'),strcat(pwd,'\youbot\gui'),strcat(pwd,'\youbot\navigation'),strcat(pwd,'\youbot\navigation\utils'),strcat(pwd,'\youbot\gripper'));
global g_VERBOSE;
global g_PLOTDATA;

g_VERBOSE = 0;
g_PLOTDATA = false;

kbhit('init');

end

