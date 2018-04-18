/* Pong - darksteelcode
 * A Work in Progress
 */

#include std.asm\
#include stdutil.asm\
#include stdstruct.asm\

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

	for! CX 0 4 {
		out BX GFX_TXT_ADDR;
		out AX GFX_TXT_DATA;

		inc BX 40;
	};

\
//Clear pball location, and draw ball
#macro draw_ball
	mv pballY A OP_*;
	put 40 B;
	mv RES A OP_+;
	mv pballX B;
	out RES GFX_TXT_ADDR;
	//Blank
	put 0 AX;
	out AX GFX_TXT_DATA;

	mv ballY A OP_*;
	put 40 B;
	mv RES A OP_+;
	mv ballX B;
	out RES GFX_TXT_ADDR;
	//Orange O
	put 0xf04f AX;
	out AX GFX_TXT_DATA;
\

#macro update_keys
	//If no keys have been pressed, jump to the end
	in A KEY_IN_WAITING;
	mv CR CR OP_NOT;
	mv RES CND;
	jumpc MACROIDF;

	//For each key, read, and check if it is a w, s, up, or down
	label MACROID0;
	//Read
	in A KEY_DATA;
	out A KEY_NEXT;

	//Minus is equivelent to !=
	// W and S
	mv CR CR OP_-;
	put 'w' B;
	jumpc RES MACROID1;

		//If w, do the following
		mv 1 w_pressed;
		mv 0 s_pressed;

	label MACROID1;
	mv CR CR OP_-;
	put 's' B;
	jumpc RES MACROID2;

		//If s, do the following
		mv 1 s_pressed;
		mv 0 w_pressed;
	//343 is w released, 339 is s released
	label MACROID2;
	mv CR CR OP_-;
	put 343 B;
	jumpc RES MACROID3;

		//If w released, do the following
		mv 0 w_pressed;

	label MACROID3;
	mv CR CR OP_-;
	put 339 B;
	jumpc RES MACROID4;

		//If s released, do the following
		mv 0 s_pressed;
	label MACROID4;


	//Up and Down
	in CND KEY_IN_WAITING;
	jumpc MACROID0;


	label MACROIDF;


//Init
txt_clear_screen!;
inf_loop! {
	//Game Logic
	clear_column 1;
	draw_padel padel1 1;
	clear_column 38;
	draw_padel padel2 38;
	draw_ball;
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
label ballX;
. 20;
label ballY;
. 12;
label pballX;
. 19;
label pballY;
. 11;
