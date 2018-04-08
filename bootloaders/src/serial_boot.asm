/* Serial Bootloader - darksteelcode - This program is close to operations, but slight improvements to the macro engine is needed, and this prgram, as it is, will try to write over itself
 * This program sits at 0xff00, and copies data from the serial port into memory, then jumps to 0x000 when reciving 0x0abc followed by 0x0123 (This will be changed to be more unique)
 */
#include std.asm\
//Register Usage - AX - Addr in memory to currently write to, BX - current instr being loaded
label mem_start;
//Program is at 0xff00

//JUST FOR NOW, PLACE AT DIFFERENT SPOT
#repeat 0x00f0
. 0;\
label init;
	//Clear Regs
	pra BX 0;
	prb BX 0;
	prb AX 0;
	pra AX 0;

	//Init SP - programs may expect this to be set
	pra SP 0xf000;
	prb SP 0xf000;

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

label string;
#string
Comp16 Bootloader\
. 0;
