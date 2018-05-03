#include std.asm\
#include stdio.c16\
#include stdtime.c16\

#ifnotdef !IS_SHELL
label SHELL_RETURN;
\

call key_wait_for_press;
call key_clear;

label CLOCK_start;

call print_clear;
call print &msg;
in AX TIMEIO_S;
call print_unsigned AX;
call print &seconds;
call time_delay_ms 135;

in CND KEY_IN_WAITING;
jumpc SHELL_RETURN;

jump CLOCK_start;

#string msg
Comp16 has been on for: \
#string seconds
 seconds\
