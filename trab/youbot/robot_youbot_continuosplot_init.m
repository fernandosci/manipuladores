function [  ] = robot_youbot_continuosplot_init(  )
global g_PLOTDATA;
global g_plotdata_X;
global g_plotdata_Y;

if (g_PLOTDATA == false)
    return
end

subplot(211)
drawnow;
[g_plotdata_X,g_plotdata_Y] = meshgrid(-5:.25:5,-5.5:.25:2.5);
g_plotdata_X = reshape(g_plotdata_X, 1, []);
g_plotdata_Y = reshape(g_plotdata_Y, 1, []);

end

