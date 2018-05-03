/* Minesweeper - Edward Wawrzynek
 * An 8x8 minesweeper for comp16.
 */

#include std.asm\
#include stdio.c16\
#include stdtime.c16\
#include rand.sasm\

//Start timer, clear screen, clear keys, seed random
call print_clear;
call key_wait_for_press;
call key_clear;
call minesweeper_init;
in AX TIMEIO_MS;
call rand_seed AX;
//Generate Board
call minesweeper_gen_mines;
//Main program loop
inf_loop! {
	call minesweeper_text;
	call minesweeper_draw;
	call time_delay_ms 200;
};

//Board Arrays
//Mines array - a true value indicates a mine, a false an empty square
label minesweeper_MINES;
#repeat 64
. 0;\
//Adjacent array - number of mines in adjacent squares
label minesweeper_ADJACENT;
#repeat 64
. 0;\
//Flagged array - if true, square has been flagged
label minesweeper_FLAGS;
#repeat 64
. 0;\

//Board generation funcs
//Generate mines - add 10 mines
func minesweeper_gen_mines {
	for! CX 0 10 {
		label minesweeper_gen_mines_LOOP;
		call rand_gen;
		mv BP A OP_>>;
		put 10 B;
		mv RES A OP_+;
		put minesweeper_MINES B;
		mv RES MAR;
		//If there is already a mine in the position, gen another mien
		mv MDR CND;
		jumpc minesweeper_gen_mines_LOOP;
		put 1 MDR;
	};
};

//Draw the board
func minesweeper_draw {
	put 4 FX;
	//Set cursor
	call print_set_cursor 0 2;
	for! EX 0 64 {
			mv EX A OP_+;
			put minesweeper_MINES B;
			mv RES MAR;
			if_not_else! MDR {
				call print_char '_';
			} {
				call print_char 'X';
			};
			call print_char ' ';
			mv EX A OP_&;
			put 0x0007 B;
			mv RES A OP_-;
			put 0x0007 B;
			if_not! RES {
				call print_set_cursor 0 FX;
				mv FX A OP_+;
				put 2 B;
				mv RES FX;
			};
	};
};

//Draw the current time in the top right, and minesweeper in top left
func minesweeper_text {
	call print_set_cursor 0 0;
	call print &minesweeper_name;
	call print_set_cursor 30 0;
	call print &minesweeper_time_msg;
	in A TIMEIO_S;
	mv minesweeper_time_start B OP_-;
	call print_unsigned RES;
};

label minesweeper_time_start;
. 0;

#string minesweeper_time_msg
Time: \

#string minesweeper_name
Minesweeper\

func minesweeper_init {
	in AX TIMEIO_S;
	mv AX minesweeper_time_start;
};

func minesweeper_gen_board {

};
