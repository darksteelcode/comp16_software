#include std.asm\
#include stdtime.asm\

label PRGM_START;

label start;
put 0xffff AX;
out AX 0;
wait! 4;
put 0x0000 AX;
out AX 0;
wait! 4;
jump start;

