/* Serial Bootloader - darksteelcode - This is a work in progress, and uncomplete
 * This program sits at 0xff00, and copies data from the serial port into memory, then jumps to 0x000 when reciving 0xffff (This will be changed to be more unique)
 */

//These are working definitions, and will be moved to a c16-include file sometime soon

//Port that contains recived data
#define SERIAL_DATA_IN 1\
//A write to this port jumps to the next character in the fifo
#define SERIAL_NEXT 1\
//Port contains the number of bytes waiting to be read in the fifo
#define SERIAL_IN_WAITING 2\
//When written to, this port sends the low-byte of the data in it
#define SERIAL_DATA_OUT 3\
//This port contains a bit, that when high, indicates that the uart is still sending data. If low, the uart is not busy, and data can be sent
#define SERIAL_TX_BUSY 4\

//Same, for Operations
#define OP_+ 0\
#define OP_- 1\
#define OP_* 2\
#define OP_~ 3\
#define OP_| 4\
#define OP_& 5\
#define OP_NOT 6\
#define OP_AND 7\
#define OP_>> 8\
#define OP_<< 9\
#define OP_== 10\
#define OP_> 11\
#define OP_>= 12\
#define OP_OR 13\
#define OP_^ 14\


//Start of program
//Register Usage - AX - Addr in memory to currently write to, BX - current instr being loaded

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
