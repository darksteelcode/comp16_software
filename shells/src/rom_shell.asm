#include std.asm\
#include stdio.hsm\
#include stdtime.asm\

label PRGM_START;
//Print boot stuff with slight delays for asthetics
call print &SHELL_boot_symbol;
call print &SHELL_boot_msg;
call SHELL_LOAD_PRGMS;
call print_char '\n';
mv FX SHELL_loaded;
call print_hex SHELL_loaded;
call print &SHELL_prgms_loaded;
//Interpreter loop
label SHELL_LOOP_START;
call print &SHELL_prompt;
call key_input;
mv BP SHELL_cmd;
call SHELL_RUN_CMD SHELL_cmd;
//Run command
mv BP PC;
label SHELL_RETURN;
jump SHELL_LOOP_START;
hang!;

//Pointer to command entered
label SHELL_cmd;
. 0;
//Number of cmds loaded
label SHELL_loaded;
. 0;

//Load SHELL_PRGMS with names and addrs
func SHELL_LOAD_PRGMS {
	//Mem location to look at
	put 0 AX;
	//boolean - if name is being loaded
	put 0 BX;
	//address of begining of program most recently worked on
	put 0 CX;
	//Current addrs in SHELL_PRGMS to write to
	put 0 DX;
	//Curent mem value at AX
	put 0 EX;
	//Curent loc in SHELL_ADDRS
	put 0 FX;
	label SHELL_LOAD_START;

	mv AX MAR;
	mv MDR EX;
	mv EX A OP_-;
	put 0x0fff B;
	//Prgm marker found
	if_not! RES {
		put 1 BX;
		inc AX;
		mv AX CX;
		jump SHELL_LOAD_START;
	};
	mv BX A;
	//Program is being added
	if! A {
		//Write to SHELL_PRGMS
		mv DX A OP_+;
		put SHELL_PRGMS B;
		mv RES MAR;
		mv EX MDR;
		//If EX is 0, end adding name, and add CX into SHELL_ADDRS
		mv EX A;
		if_not! A {
			put 0 BX;
			mv FX A OP_+;
			put SHELL_ADDRS B;
			mv RES MAR;
			mv CX MDR;
			inc FX;
		};
		inc DX;
	};
	inc AX;
	//End if all of memory has been scanned
	mv AX CND;
	jumpc SHELL_LOAD_START;
};

//Attempt to find command addrs from passed pointer - put it in BP if found
func SHELL_RUN_CMD $cmd {
	//Pointer to cmd
	mv $cmd AX;
	//Current location in cmd name
	put 0 BX;
	//Current location in SHELL_PRGMS
	put 0 CX;
	//Current location in SHELL_ADDRS
	put 0 DX;
	//Curent cmd name char
	put 0 EX;
	//Current SHELL_PRGMS char
	put 0 FX;
	label SHELL_RUN_START;
	//If DX is greater or equal to number of loaded programs, print error, and return with pointer to SHELL_LOOP_START
	mv DX A OP_>=;
	mv SHELL_loaded B OP_>=;
	if! RES {
		call print &SHELL_no_such_prgm;
		call print $cmd;
		put SHELL_LOOP_START BP;
		ret 1;
	};
	//Load EX
	mv BX A OP_+;
	mv AX B OP_+;
	mv RES MAR;
	mv MDR EX;

	//Load FX
	mv CX A OP_+;
	put SHELL_PRGMS B;
	mv RES MAR;
	mv MDR FX;

	//If the two chars aren't equal, set BX = 0, inc DX, and set CX to after next null
	mv EX A OP_==;
	mv FX B OP_==;
	if_not! RES {
		put 0 BX;
		inc DX;
		//Put CX to after next null
		label SHELL_CX_NULL;

		mv CX A OP_+;
		put SHELL_PRGMS B;
		mv RES MAR;
		//If null, inc CX and jump to loop start
		if_not! MDR {
			inc CX;
			jump SHELL_RUN_START;
		};
		inc CX;
		jump SHELL_CX_NULL;
	};
	//At this point, the characters are equal
	//If EX (or FX) is null, then the whole string has been matched, and jump to value in SHELL_ADDRS
	if_not! EX {
		mv DX A OP_+;
		put SHELL_ADDRS B;
		mv RES MAR;
		mv MDR BP;
		ret 1;
		//Returned and passed pointer to command
	};

	//For checking next character
	inc BX;
	inc CX;

	jump SHELL_RUN_START;
};

//Prgm name and address array - 256 and 16 words is just to give a decent amount of space
label SHELL_PRGMS;
#repeat 256
. 0;\
label SHELL_ADDRS;
#repeat 16
. 0;\

//Variables

//Strings
#string SHELL_boot_symbol
 ##  ##   ## ##   ##  #  ###
#   #  # #  #  # #  # # #
#   #  # #  #  # #  # # ###
#   #  # #  #  # #  # # #  #
 ##  ##  #  #  # ###  # #  #
                 #    #  ##
                 #
\
#string SHELL_boot_msg
Comp16 ROM Shell - Edward Wawrzynek\
#string SHELL_prompt

$ \
#string SHELL_prgms_loaded
 programs loaded from ROM\
#string SHELL_no_such_prgm
No such loaded prgm: \
//Space for shell programs - just some basic demos

//reset command
. 0x0fff;
#string
reset\
call print_clear;
jump PRGM_START;

//bootloader command
. 0x0fff;
#string
bootloader\
prb CR 0xff00;
jmp CR 0xff00;

//random command - print a random number in hex
. 0x0fff;
#string
random\
//Randomize
mv RANDOM_num A OP_+;
put 0x34af B;
mv RES A OP_^;
put 0xf45a B;
mv RES A OP_*;
put 0x034a B;
mv RES RANDOM_num;
//print
call print_hex RANDOM_num;
//return
jump SHELL_RETURN;
label RANDOM_num;
. 0;

//list command - list availible prgms
. 0x0fff;
#string
list\
put 0 LIST_prgm_name_i;
put 0 LIST_prgm_num;
label LIST_start;
//Return if all have been listed
mv LIST_prgm_num A OP_>=;
mv SHELL_loaded B OP_>=;
mv RES CND;
jumpc SHELL_RETURN;

mv LIST_prgm_name_i A OP_+;
put SHELL_PRGMS B;
call print RES;
call print_char '\n';

inc LIST_prgm_num;

//Set LIST_prgm_name_i to after next null
label LIST_advance;
mv LIST_prgm_name_i A OP_+;
put SHELL_PRGMS B;
mv RES MAR;
if_not! MDR {
	inc LIST_prgm_name_i;
	jump LIST_start;
};
inc LIST_prgm_name_i;
jump LIST_advance;

label LIST_prgm_num;
. 0;
label LIST_prgm_name_i;
. 0;

//clear command
. 0x0fff;
#string
clear\
for! FX 0 40 {
	call print_scroll;
};
jump SHELL_RETURN;

//images demo
. 0x0fff;
#string
images\
#include shells/src/rom_shell_asms/image.asm\

//pong
. 0x0fff;
#string
pong\
#include shells/src/rom_shell_asms/pong.asm\

//color flashing screen
. 0x0fff;
#string
colors\
#include shells/src/rom_shell_asms/flash.asm\

//random text
. 0x0fff;
#string
txt_rand\
#include shells/src/rom_shell_asms/txt_rand.asm\
