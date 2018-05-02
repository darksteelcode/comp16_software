//Nothing to test right now - probably a good thing?
#include std.asm\
#include stdio.c16\
#include stdtime.c16\

put 61234 FX;
call print_unsigned FX;
call time_hang;
