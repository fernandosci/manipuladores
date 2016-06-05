function [  ] = test(  )

kbhit('init');
fprintf(1, 'Five seconds to type something ...');
pause(1);
key = kbhit; fprintf(1, 'Character : %c\n', key);

kbhit('init');
end

