#include std.asm\
#include stdtime.c16\

label PRGM_START;

label start;
put 0xffff AX;
out AX 0;
call time_delay_ms 80;
put 0x0000 AX;
out AX 0;
call time_delay_ms 80;
jump start;

