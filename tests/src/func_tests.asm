#include std.asm\
#include stdtime.asm\
#include stdio.hsm\

label PRGM_START;
inf_loop! {
	mv mem_loc MAR;
  	call print_hex MDR;
	call print_char ' ';
  	inc mem_loc;
  	wait! 1;
};
hang!;

label mem_loc;
. 0;

