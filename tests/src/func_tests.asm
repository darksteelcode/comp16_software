#include std.asm\
#include stdtime.asm\
#include stdio.hsm\

label PRGM_START;
call print_char '\n';
call print_char '>';
call print_char ' ';
call key_input;
mv BP return_val;
call print &str;
call print return_val;

jump PRGM_START;
label return_val;
. 0;
#string str
You entered \
/*
inf_loop! {
	call print_char ' ';
	call print_char ' ';
	mv mem_loc MAR;
  	call print_binary MDR;
  	inc mem_loc;
	call print_char ' ';
	call print_char ' ';
  	wait! 1;
	in A KEY_IN_WAITING;
	if! A {
		call print_clear;
	};
};
hang!;

label mem_loc;
. 0;

#string str
This is some long text that is going way past one screen and is very long
Hey! A newline with ta	bs and more tab 	s
Hello\
 */
