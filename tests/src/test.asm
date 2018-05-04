//Nothing to test right now - probably a good thing?
#include std.asm\
#include stdio.c16\
#include stdtime.c16\

for! FX 0 256 {
	call print_char FX;
};
call time_hang;
