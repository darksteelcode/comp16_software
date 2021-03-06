/* Serial Bootloader - darksteelcode
 * This program sits at 0xff00, and copies data from the serial port into memory, then jumps to 0x000 when reciving 0x0abc followed by 0x0123 (This will be changed to be more unique)
 */
#include stdlang.asm\
#include stdio.asm\

//label PRGM_START;
//Register Usage - AX - Addr in memory to currently write to, BX - current instr being loaded
label mem_start;
//Program is at 0xff00

#repeat 0xff00
. 0;\
label init;
	//Clear PS2 Keys FIFO
	//If there are no key presses in the buffer, skip this step
	in A KEY_IN_WAITING;
	mov CR CR OP_NOT;
	mov RES CND;
	prb CR key_clear_end;
	jpc CR key_clear_end;

	label key_clear;
	out A KEY_NEXT;
	in CND KEY_IN_WAITING;
	prb CR key_clear;
	jpc CR key_clear;

	label key_clear_end;
	//Clear Regs
	prb AX 0;
	pra AX 0;

	//Init SP - programs may expect this to be set
	pra SP 0xfeff;
	prb SP 0xfeff;

	label clear_screen;
		prb CR ' ';
		pra CR ' ';
		out AX GFX_TXT_ADDR;
		out CR GFX_TXT_DATA;
		mov AX A OP_+;
		prb B 1;
		pra B 1;
		mov RES AX;
		mov AX CND;
		prb CR clear_screen;
		jpc CR clear_screen;
	prb AX 0;
	pra AX 0;
	//Print the bootloader message
	label print_string;
		//Get pointer to current char
		prb B string;
		pra B string;
		mov AX A OP_+;
		mov RES MAR;
		//Print char
		out AX GFX_TXT_ADDR;
		out MDR GFX_TXT_DATA;
		//Increment char num
		prb B 1;
		pra B 1;
		mov AX A OP_+;
		mov RES AX;
		mov MDR CND;
		prb CR print_string;
		jpc CR print_string;

	pra AX 0;
	prb AX 0;

label key_wait;
in A KEY_IN_WAITING;
mov CR CR OP_NOT;
mov RES CND;
prb CR key_wait;
jpc CR key_wait;

in A KEY_DATA;
out A KEY_NEXT;
mov CR CR OP_&;
prb B 0x00ff;
pra B 0x00ff;
mov RES BX;
//Check for Esc
mov BX A OP_==;
prb B 27;
pra B 27;
mov RES CND;
prb CR serial_start;
jpc CR serial_start;
//Check for F1
mov BX A OP_==;
prb B KEY_F1;
pra B KEY_F1;
mov RES CND;
prb CR rom_start;
jpc CR rom_start;

//Wait for valid key
prb CR key_wait;
jmp CR key_wait;

label serial_start;
//Clear esc key
//Wait until there is at least 2 bytes in waiting
label wait_data_loop;
	in B SERIAL_IN_WAITING;
	prb A 0;
	pra A 2;
	//Set mode to >
	mov CR CR OP_>;
	mov RES CND;
	//Jump back to loop if data not in
	prb CR wait_data_loop;
	jpc CR wait_data_loop;

//Load data into BX for writing into memory
	in A SERIAL_DATA_IN;
	out CR SERIAL_NEXT;
	//Wait for Serial Port to be done sending
	label tx_busy_1;
		in CND SERIAL_TX_BUSY;
		prb CR tx_busy_1;
		jpc CR tx_busy_1;
	out A SERIAL_DATA_OUT;
	//Shift first byte left 8 bits
	prb B 8;
	pra B 8;
	mov CR CR OP_<<;
	// | next byte into low byte of instr
	mov RES A OP_|;
	in B SERIAL_DATA_IN;
	out CR SERIAL_NEXT;
	mov RES BX;
	//Wait for Serial Port to be done sending
	label tx_busy_2;
		in CND SERIAL_TX_BUSY;
		prb CR tx_busy_2;
		jpc CR tx_busy_2;
	out B SERIAL_DATA_OUT;

//Check if BX is 0xffff - if so, jump to 0x0000 (ffff will be changed to be more unique later)
	mov BX A OP_==;
	prb B 0xffff;
	pra B 0xffff;
	mov RES CND;
	prb CR prepare_for_jump;
	jpc CR prepare_for_jump;

//Output the word to port 0
	out BX 0;

//Put BX into memory, increment AX
	mov AX MAR;
	mov BX MDR;
	mov AX A OP_+;
	pra B 1;
	prb B 1;
	mov RES AX;

prb CR wait_data_loop;
jmp CR wait_data_loop;

//Try to make machine state the same as if the bootloader had not been run
label prepare_for_jump;

prb AX 0;
pra AX 0;

//Clear port 0
out AX 0;

prb BX 0;
pra BX 0;
prb A 0;
pra A 0;
prb B 0;
pra B 0;
mov CR CR OP_+;
prb MAR 0;
pra MAR 0;

prb CR mem_start;
jmp CR mem_start;

label rom_start;
//Clear regs
prb AX 0;
pra AX 0;
label rom_LOOP;
out AX PRGM_ROM_ADDRS;
mov AX MAR;
in BX PRGM_ROM_VAL;
out AX 0;
mov BX MDR;

mov AX A OP_+;
prb B 1;
pra B 1;
mov RES AX OP_+;

mov AX A OP_+;
//Load until at 0xff00, then stop and jump to loaded program
prb B 0x0100;
pra B 0x0100;
mov RES CND OP_+;
prb CR rom_LOOP;
jpc CR rom_LOOP;

prb CR prepare_for_jump;
jmp CR prepare_for_jump;

label string;
#string
Comp16 Bootloader   Esc-Serial   F1-ROM\
