#include std.asm\
#include stdtime.asm\
#include stdio.hsm\

label PRGM_START;
/*
call print_char 'a';
call print_char 'b';
call print_char '\n';
call print_char 'c';
call print_char '\t';
call print_char 'd';
call print_char '\b';
call print_char 'e';
*/
call print &str;
hang!;

#string str
Hello
	Write\


