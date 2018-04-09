/* Standard Input/Output Functions - darksteelcode
 * These are a work in progress, and are NOT FIXED
 */

#include stdlang.asm\
#include stdops.asm\
#include stdports.asm\

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


