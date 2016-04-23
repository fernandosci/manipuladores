function [  ] = robot_youbot_continuosplot(  )
global g_VERBOSE;
global g_PLOTDATA;
global g_vrep;
global g_h;

global g_plotdata_X;
global g_plotdata_Y;

global g_youbot_hokuyo_pts;
global g_youbot_hokuyo_contacts;


if (g_PLOTDATA == false)
    return
end


in = inpolygon(g_plotdata_X, g_plotdata_Y, [g_h.hokuyo1Pos(1) g_youbot_hokuyo_pts(1,:) g_h.hokuyo2Pos(1)],...
    [g_h.hokuyo1Pos(2) g_youbot_hokuyo_pts(2,:) g_h.hokuyo2Pos(2)]);

subplot(211)
plot(g_plotdata_X(in), g_plotdata_Y(in),'.g', g_youbot_hokuyo_pts(1,g_youbot_hokuyo_contacts), g_youbot_hokuyo_pts(2,g_youbot_hokuyo_contacts), '*r',...
    [g_h.hokuyo1Pos(1) g_youbot_hokuyo_pts(1,:) g_h.hokuyo2Pos(1)],...
    [g_h.hokuyo1Pos(2) g_youbot_hokuyo_pts(2,:) g_h.hokuyo2Pos(2)], 'r',...
    0, 0, 'ob',...
    g_h.hokuyo1Pos(1), g_h.hokuyo1Pos(2), 'or',...
    g_h.hokuyo2Pos(1), g_h.hokuyo2Pos(2), 'or');
axis([-5.5 5.5 -5.5 2.5]);
axis equal;
drawnow;

end

