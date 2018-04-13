#include std.asm\
#include stdutil.asm\

label start;
put 0xffff AX;
out AX 0;
wait! 8;
put 0x0000 AX;
out AX 0;
wait! 8;
jump start;

