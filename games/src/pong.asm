/* Pong - Edward Wawrzynek
 * A replication of the classic.
 */

#ifnotdef !IS_SHELL
label SHELL_RETURN;
\

#include std.asm\
#include stdio.c16\
#include stdtime.c16\

#define SPEED_UP_TIME 200\
#define 2SPEED_TIME 420\

//Clear a column - used before padle draw
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

//Draw a padle
#macro draw_padle MEM padel VAL col
	//AX is char to print - colored block
	put 0x7cdb AX;
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
	put 0xe84f AX;
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
	// W and S 87 is w, 83 is s
	mv CR CR OP_-;
	put 119 B;
	jumpc RES MACROID1;

		//If w, do the following
		mv 1 w_pressed;
		mv 0 s_pressed;

	label MACROID1;
	mv CR CR OP_-;
	put 115 B;
	jumpc RES MACROID2;

		//If s, do the following
		mv 1 s_pressed;
		mv 0 w_pressed;
	//343 is w released, 339 is s released
	label MACROID2;
	mv CR CR OP_-;
	put 375 B;
	jumpc RES MACROID3;

		//If w released, do the following
		mv 0 w_pressed;

	label MACROID3;
	mv CR CR OP_-;
	put 371 B;
	jumpc RES MACROID4;

		//If s released, do the following
		mv 0 s_pressed;
	label MACROID4;


	//Up and Down

	// W and S 87 is w, 83 is s
	mv CR CR OP_-;
	put KEY_UP B;
	jumpc RES MACROID5;

		//If w, do the following
		mv 1 up_pressed;
		mv 0 down_pressed;

	label MACROID5;
	mv CR CR OP_-;
	put KEY_DOWN B;
	jumpc RES MACROID6;

		//If s, do the following
		mv 1 down_pressed;
		mv 0 up_pressed;
	//343 is w released, 339 is s released
	label MACROID6;
	mv CR CR OP_-;
	put KEY_UP_RELEASE B;
	jumpc RES MACROID7;

		//If w released, do the following
		mv 0 up_pressed;

	label MACROID7;
	mv CR CR OP_-;
	put KEY_DOWN_RELEASE B;
	jumpc RES MACROID8;

		//If s released, do the following
		mv 0 down_pressed;
	label MACROID8;


	mv CR CR OP_-;
	put 27 B;
	jumpc RES MACROID9;

		jump SHELL_RETURN;

	label MACROID9;
	in CND KEY_IN_WAITING;
	jumpc MACROID0;


	label MACROIDF;
\

#macro move_padle MEM padle MEM up_key MEM down_key
	if! up_key {
		dec padle;
		//Check if paddle crossed limit - if it is greater than 20, then limit was crossed.
		mv padle B OP_>=;
		put 21 A;
		mv RES CND;
		jumpc MACROID0;
		inc padle;
	};
	label MACROID0;
	if! down_key {
		inc padle;
		mv padle B OP_>=;
		put 21 A;
		mv RES CND;
		jumpc MACROID1;
		dec padle;
	};
	label MACROID1;
\

#macro move_ball
	//Put past x
	mv ballX pballX;
	//Add d to x
	mv ballX A OP_+;
	mv dballX B OP_+;
	mv RES ballX;
	//put past y
	mv ballY pballY;
	//Add d to y
	mv ballY A OP_+;
	mv dballY B OP_+;
	mv RES ballY;

	//If ball is going to go off screen by y, negate the y (check if ballY == 0 or is greater or equal to 24)
	mv ballY A OP_-;
	put 1 B;
	mv RES B OP_>;
	put 22 A;
	mv RES CND;
	jumpc MACROID0;

	mv dballY A OP_~;
	mv RES A OP_+;
	put 1 B;
	mv RES dballY;

	label MACROID0;

\

//col_bounce is column to bounce on, NOT column of padle
#macro bounce_ball MEM padle VAL col_bounce
	mv col_bounce A OP_-;
	mv ballX B OP_-;

	if_not! RES {
		mv ballY A OP_>=;
		mv padle B OP_>=;
		mv RES AX OP_>=;
		mv padle B OP_+;
		put 4 A;
		mv RES A OP_>;
		mv ballY B OP_>;
		mv RES A OP_&;
		mv AX B OP_&;

		if! RES {
			mv dballX A OP_~;
			mv RES A OP_+;
			put 1 B;
			mv RES dballX;

		};
	};
\
#macro draw_scores
	put 0 AX;
	out AX GFX_TXT_ADDR;
	mv score1 AX;
	out AX GFX_TXT_DATA;
	put 39 AX;
	out AX GFX_TXT_ADDR;
	mv score2 AX;
	out AX GFX_TXT_DATA;
\
//Check if ball has gone off screen - if so, increment scores, invert dballX, and wait for a bit
#macro update_scores_and_ball
	mv ballX A;
	mv CR CR OP_==;
	put 0 B;
	if! RES {
		inc score2;
	};
	mv RES AX OP_==;
	mv ballX A;
	mv CR CR OP_==;
	put 39 B;
	mv RES BX OP_==;
	if! RES {
		inc score1;
	};
	mv AX B OP_OR;
	mv BX A OP_OR;
	if! RES {
		put 20 ballX;
		put 12 ballY;
		put 19 pballX;
		put 11 pballY;
		put 1 dballY;
		mv dballX A OP_~;
		mv RES A OP_+;
		put 1 B;
		mv RES dballX;
		draw_ball;
		mv 0 time_wo_loss;
		mv 0 time_wo_2speed;
		put 2 ball_time;
		draw_scores;
		call time_delay_ms 800;
	};
\

#macro check_speed
	mv time_wo_loss A OP_>;
	put SPEED_UP_TIME B;
	if! RES {
		put 1 ball_time;
	};
	mv time_wo_2speed A OP_>;
	put 2SPEED_TIME B;
	if! RES {
		put 0 ball_time;
	};
\

#macro check_end MEM score MEM str
	mv score A OP_>;
	put 52 B;
	if! RES {
		put 20 ballX;
		put 12 ballY;
		put 19 pballX;
		put 11 pballY;
		put 1 dballY;
		mv dballX A OP_~;
		mv RES A OP_+;
		put 1 B;
		mv RES dballX;
		draw_ball;
		mv 0 time_wo_loss;
		mv 0 time_wo_2speed;
		put 2 ball_time;
		put 48 score1;
		put 48 score2;
		call print_at &str 371;
		jump start;
	};
\
//Init
init_vars!;
call print_clear;
label start;
call print_at &welcome_str 298;
call print_at &welcome_instr 410;
call print_at &win_instr 573;
call print_at &name 892;
draw_ball;
draw_padle padle1 1;
draw_padle padle2 38;
draw_scores;
call time_delay_ms 600;
call key_clear;
call key_wait_for_press;
call print_clear;
draw_ball;
draw_padle padle1 1;
draw_padle padle2 38;
draw_scores;
call key_clear;
call time_delay_ms 800;
inf_loop! {

	mv key_count B OP_>=;
	put 1 A;
	if_not! RES {
		//Handle Keys
		update_keys;
		move_padle padle1 w_pressed s_pressed;
		move_padle padle2 up_pressed down_pressed;
		put 0 key_count;
	};

	mv move_count B OP_>=;
	mv ball_time A;
	if_not! RES {
		//Move ball
		move_ball;
		bounce_ball padle2 37;
		bounce_ball padle1 2;
		update_scores_and_ball;
		put 0 move_count;
	};

	//Draw
	clear_column 1;
	clear_column 38;
	draw_ball;
	draw_padle padle1 1;
	draw_padle padle2 38;
	draw_scores;
	//Speed up ball if needed
	check_speed;
	check_end score1 win1;
	check_end score2 win2;
	call time_delay_ms 40;

	inc move_count;
	inc key_count;
	inc time_wo_loss;
	inc time_wo_2speed;
};

#macro init_vars!
	put 2 ball_time;
	put 0 move_count;
	put 0 key_count;
	put 0 time_wo_loss;
	put 0 time_wo_2speed;
	put 0 w_pressed;
	put 0 s_pressed;
	put 0 up_pressed;
	put 0 down_pressed;
	put 8 padle1;
	put 8 padle2;
	put 20 ballX;
	put 12 ballY;
	put 19 pballX;
	put 11 pballY;
	put 1 dballX;
	put 1 dballY;
	put 48 score1;
	put 48 score2;
\

label ball_time;
. 2;
label move_count;
. 0;

label key_count;
. 0;

//Memory Locations
label time_wo_loss;
. 0;
label time_wo_2speed;
. 0;
label w_pressed;
. 0;
label s_pressed;
. 0;
label padle1;
. 8;
label up_pressed;
. 0;
label down_pressed;
. 0;
label padle2;
. 8;
label ballX;
. 20;
label ballY;
. 12;
label pballX;
. 19;
label pballY;
. 11;
label dballX;
. 1;
label dballY;
. 1;
//Scores in ASCII - 48 is zero
label score1;
. 48;
label score2;
. 48;

#string welcome_str 0b11011000
Pong\
#string welcome_instr
Press a Key to Begin\
#string win1
Left Player Wins!\
#string win2
Right Player Wins!\
#string win_instr
First to 5 Wins\
#string name
Edward Wawrzynek\
