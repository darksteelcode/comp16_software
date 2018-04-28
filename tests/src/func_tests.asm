#include std.asm\
#include stdtime.asm\
#include stdio.hsm\

label PRGM_START;
call print &str;
hang!;
inf_loop! {
	call print_char ' ';
	call print_char ' ';
	mv mem_loc MAR;
  	call print_binary MDR;
  	inc mem_loc;
	call print_char ' ';
	call print_char ' ';
  	wait! 1;
};
hang!;

label mem_loc;
. 0;

#string str
This is some long text that is going way past one screen and is very long
Hey! A newline with ta	bs and more tab 	s
Hello\
