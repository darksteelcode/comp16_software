//Nothing to test right now - probably a good thing?
#include std.asm\
#include stdio.c16\

for! mem_val 0 200 {
	mv mem_val AX;
	out  AX PRGM_ROM_ADDRS;
	in BX PRGM_ROM_VAL;
	call print_hex BX;
	call print_char ' ';
};

label mem_val;
. 0;

label end;
jump end;
