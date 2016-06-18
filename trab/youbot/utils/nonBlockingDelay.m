function [ finished ] = nonBlockingDelay( seconds )
global g_time_elapsed;
global g_nonBlockingDelay_target;
global g_nonBlockingDelay_count;

if (nargin == 1)
    g_nonBlockingDelay_target = seconds;
    g_nonBlockingDelay_count = 0;
else
    g_nonBlockingDelay_count = g_nonBlockingDelay_count + g_time_elapsed;
end


if (g_nonBlockingDelay_count >= g_nonBlockingDelay_target)
    finished = true;
else
    finished = false;
end
end

