/* Standard Input/Output Functions - darksteelcode
 * These are a work in progress, and are NOT FIXED
 */

#include stdlang.asm\

//Define IO Ports

//Graphics Memory Ports
#define GFX_TXT_ADDR 5\
#define GFX_TXT_DATA 6\

//PS2 Keyboard Ports
#define KEY_DATA 7\
#define KEY_NEXT 7\
#define KEY_IN_WAITING 8\

//Serial Ports
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


//Printing macros

// Print string starting at pos_on_screen on screen - AX is char pointer, BX is gfx mem pointer, MACROID0 is print loop, MACROID1 is end
#macro print! MEM string VAL pos_on_screen
	put string AX;
	put pos_on_screen BX;

	label MACROID0;
		mv AX MAR;
		out BX GFX_TXT_ADDR;
		mv MDR A OP_NOT;
		mv RES CND;
		jumpc MACROID1;
		out MDR GFX_TXT_DATA;
		inc AX;
		inc BX;
		jump MACROID0;
	label MACROID1;
\
#macro print! MEM string
	print! string 0;
\

#macro txt_clear_screen!
	put 0 AX;
	put 0 BX;
	label MACROID0;
	out AX GFX_TXT_ADDR;
	out BX GFX_TXT_DATA;
	inc AX;
	mv AX B OP_>;
	put 1000 A;
	mv RES CND;
	jumpc MACROID0;
\

#macro ps2_clear_keys!
	in A KEY_IN_WAITING;
	mv CR CR OP_NOT;
	mv RES CND;
	jumpc MACROID1;

	label MACROID0;
	out A KEY_NEXT;
	in CND KEY_IN_WAITING;
	jumpc MACROID0;

	label MACROID1;
\

#macro ps2_wait_for_key!
	label MACROID0;
	in A KEY_IN_WAITING;
	mv CR CR OP_NOT;
	mv RES CND;
	jumpc MACROID0;
\

#macro serial_wait_for_data!
	label MACROID0;
	in A SERIAL_IN_WAITING;
	mov CR CR OP_NOT;
	mov RES CND;
	jumpc MACROID0;
\

#macro serial_wait_for_we_clear!
	label MACROID0;
	in CND SERIAL_TX_BUSY;
	jumpc MACROID0;
\
