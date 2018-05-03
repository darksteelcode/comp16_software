//Nothing to test right now - probably a good thing?
#include std.asm\
#include stdio.c16\
#include stdtime.c16\

call print_unsigned 20341;
call print_char '\n';
call print_hex 0xdead;
call print_hex 0xbeef;
call print_char '\n';
call print_binary 0b101011111;
call time_hang;
