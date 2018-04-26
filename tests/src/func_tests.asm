#include std.asm\
#include stdtime.asm\
#include stdio.hsm\

label PRGM_START;
inf_loop! {
  	call print_char ' ';
	mv mem_loc MAR;
  	call print_hex MDR;

  	inc mem_loc;
  	wait! 1;
};
hang!;

label mem_loc;
. 0;

