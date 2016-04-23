function [  ] = robot_youbot_continuosplot(  )
global g_VERBOSE;
global g_PLOTDATA;
global g_vrep;
global g_h;

global g_plotdata_X;
global g_plotdata_Y;


if (g_PLOTDATA == false)
    return
end
% Read data from the Hokuyo sensor:
[pts, contacts] = youbot_hokuyo(g_vrep, g_h, g_vrep.simx_opmode_buffer);

in = inpolygon(g_plotdata_X, g_plotdata_Y, [g_h.hokuyo1Pos(1) pts(1,:) g_h.hokuyo2Pos(1)],...
    [g_h.hokuyo1Pos(2) pts(2,:) g_h.hokuyo2Pos(2)]);

subplot(211)
plot(g_plotdata_X(in), g_plotdata_Y(in),'.g', pts(1,contacts), pts(2,contacts), '*r',...
    [g_h.hokuyo1Pos(1) pts(1,:) g_h.hokuyo2Pos(1)],...
    [g_h.hokuyo1Pos(2) pts(2,:) g_h.hokuyo2Pos(2)], 'r',...
    0, 0, 'ob',...
    g_h.hokuyo1Pos(1), g_h.hokuyo1Pos(2), 'or',...
    g_h.hokuyo2Pos(1), g_h.hokuyo2Pos(2), 'or');
axis([-5.5 5.5 -5.5 2.5]);
axis equal;
drawnow;

end

