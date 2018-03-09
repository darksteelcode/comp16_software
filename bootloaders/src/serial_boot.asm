/* Serial Bootloader - darksteelcode - This program is close to operations, but slight improvements to the macro engine is needed, and this prgram, as it is, will try to write over itself
 * This program sits at 0xff00, and copies data from the serial port into memory, then jumps to 0x000 when reciving 0xffff (This will be changed to be more unique)
 */
#include std.asm\
//Register Usage - AX - Addr in memory to currently write to, BX - current instr being loaded
label mem_start;
//Program is at end of memory
// (ADD MACRO TO FILL WITH 0's)
label init;
	//Clear Regs
	pra AX 0;
	prb AX 0;
	pra BX 0;
	prb BX 0;

	//Init SP - programs may expect this to be set
	pra SP 0xf000;
	prb SP 0xf000;

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
	out A SERIAL_DATA_OUT;
	//Shidt first byte left 8 bits
	prb B 8;
	pra B 8;
	mov CR CR OP_<<;
	// | next byte into low byte of instr
	mov RES A OP_|;
	in B SERIAL_DATA_IN;
	out CR SERIAL_NEXT;
	out B SERIAL_DATA_OUT;
	mov RES BX;

//Check if BX is 0xffff - if so, jump to 0x0000 (ffff will be changed to be more unique later)
	mov BX A OP_==;
	prb B 0xffff;
	pra B 0xfff;
	mov RES CND;
	prb CR mem_start;
	jpc CR mem_start;

//Put BX into memory, increment AX
	mov AX MAR;
	mov BX MDR;
	mov AX A OP_+;
	pra B 1;
	prb B 1;
	mov RES AX;

prb CR wait_data_loop;
jmp CR wait_data_loop;
