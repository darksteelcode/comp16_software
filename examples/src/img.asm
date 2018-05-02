#include std.asm\
#include stdio.c16\
#include stdtime.c16\

#ifnotdef !IS_SHELL
label SHELL_RETURN;
\

call print &img1;
call time_delay_ms 1200;
call print &img2;
call time_delay_ms 1200;
call print &img3;
call time_delay_ms 1200;
jump SHELL_RETURN;

label img1;
#include examples/src/img_data1.txt\
label img2;
#include examples/src/img_data2.txt\
label img3;
#include examples/src/img_data3.txt\
