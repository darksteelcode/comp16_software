/* Pong - darksteelcode
 * A Work in Progress
 */

#include std.asm\
#include stdutil.asm\

//Draw in second column
#macro draw_padel1
	//AX is char to print
	put 219 AX;
	//BX is loc on screen
	put 1 BX;
	mv padel1 A OP_*;
	put 40 B;
	mv RES A;
	mv BX B OP_+;
	mv RES BX;

	out BX GFX_TXT_ADDR;
	out AX GFX_TXT_DATA;

	inc BX 40;
	out BX GFX_TXT_ADDR;
	out AX GFX_TXT_DATA;

	inc BX 40;
	out BX GFX_TXT_ADDR;
	out AX GFX_TXT_DATA;


\

//Game Logic
draw_padel1;

hang!;

//Memory Locations
label w_pressed;
. 0;
label s_pressed;
. 0;
label padel1;
. 2;
