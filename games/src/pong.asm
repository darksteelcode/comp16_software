/* Pong - darksteelcode
 * A Work in Progress
 */

#include std.asm\
#include stdutil.asm\

//Clear a column - used before padel draw
#macro clear_column VAL col
	//AX is pos on screen
	put col AX;
	put 0 BX;
	label MACROID0;
		out AX GFX_TXT_ADDR;
		out BX GFX_TXT_DATA;
		inc AX 40;
		mv AX B OP_>;
		put 1000 A;
		mv RES CND;
		jumpc MACROID0;

\

//Draw a padel
#macro draw_padel MEM padel VAL col
	//AX is char to print
	put 219 AX;
	//BX is loc on screen
	put col BX;
	mv padel A OP_*;
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

	inc BX 40;
	out BX GFX_TXT_ADDR;
	out AX GFX_TXT_DATA;
\

//Init
txt_clear_screen!;
inf_loop! {
	//Game Logic
	clear_column 1;
	draw_padel padel1 1;
	clear_column 38;
	draw_padel padel2 38;
	wait! 2;

};

//Memory Locations
label w_pressed;
. 0;
label s_pressed;
. 0;
label padel1;
. 2;
label up_pressed;
. 0;
label down_pressed;
. 0;
label padel2;
. 11;
