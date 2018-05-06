/* Minesweeper - Edward Wawrzynek
 * An 8x8 minesweeper for comp16.
 */

#include std.asm\
#include stdio.c16\
#include stdtime.c16\
#include rand.sasm\

#ifnotdef !SHELL_RETURN
label SHELL_RETURN;
\

//Reset
call minesweeper_reset;
//Start timer, clear screen, clear keys, seed random
call print_clear;
call key_clear;
call minesweeper_init;
in AX TIMEIO_MS;
call rand_seed AX;
//Generate Board
call minesweeper_gen_mines;
call minesweeper_gen_adjacent;
//Main program loop
inf_loop! {
	call minesweeper_text;
	call minesweeper_draw;
	call minesweeper_handle_keys;
	call minesweeper_draw_cursor;
	call minesweeper_check_win;
	call minesweeper_reveal_zeros;
	call time_delay_ms 20;
};

#macro minesweeper_reset_CLEAR MEM board
mv AX A OP_+;
put board B;
mv RES MAR;
put 0 MDR;
\

func minesweeper_reset {
	for! AX 0 64 {
		mv AX A OP_+;
		minesweeper_reset_CLEAR minesweeper_ADJACENT;
		minesweeper_reset_CLEAR minesweeper_MINES;
		minesweeper_reset_CLEAR minesweeper_FLAGS;
		minesweeper_reset_CLEAR minesweeper_REVEALED;
	};
	put 0 minesweeper_CURX;
	put 0 minesweeper_CURY;
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
//Revealed array - if true, square has been revealed
label minesweeper_REVEALED;
#repeat 64
. 0;\

//variables
label minesweeper_CURX;
. 0;
label minesweeper_CURY;
. 0;

func minesweeper_init {
	in AX TIMEIO_S;
	mv AX minesweeper_time_start;
};

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
//Calculate values for adjacent array - find number of mines in adjacent squares
func minesweeper_gen_adjacent {
	//For each square, check
	for! FX 0 64 {
	//Number of adjacent mines
	put 0 EX;
	//If not on first line (FX > 7), check spot above
	mv FX A OP_>;
	put 7 B;
	if! RES {
		mv FX A OP_-;
		put 8 B;
		mv RES A OP_+;
		put minesweeper_MINES B;
		mv RES MAR;
		mv EX A OP_+;
		mv MDR B OP_+;
		mv RES EX;
		//Check above left, if appropriate
		mv FX A OP_&;
		put 0b000111 B;
		if! RES {
			mv FX A OP_-;
			put 9 B;
			mv RES A OP_+;
			put minesweeper_MINES B;
			mv RES MAR;
			mv EX A OP_+;
			mv MDR B OP_+;
			mv RES EX;
		};
		//Check above right, if appropriate
		mv FX A OP_&;
		put 0b000111 B;
		mv RES A OP_-;
		put 0b111 B;
		if! RES {
			mv FX A OP_-;
			put 7 B;
			mv RES A OP_+;
			put minesweeper_MINES B;
			mv RES MAR;
			mv EX A OP_+;
			mv MDR B OP_+;
			mv RES EX;
		};
	};
	//If FX%8 != 0, check spot to the left
	mv FX A OP_&;
	put 0b000111 B;
	if! RES {
		mv FX A OP_-;
		put 1 B;
		mv RES A OP_+;
		put minesweeper_MINES B;
		mv RES MAR;
		mv EX A OP_+;
		mv MDR B OP_+;
		mv RES EX;
	};
	//If 56>FX, check spot down
	mv FX B OP_>;
	put 56 A;
	if! RES {
		mv FX A OP_+;
		put 8 B;
		mv RES A OP_+;
		put minesweeper_MINES B;
		mv RES MAR;
		mv EX A OP_+;
		mv MDR B OP_+;
		mv RES EX;
		//Check below left, if appropriate
		mv FX A OP_&;
		put 0b000111 B;
		if! RES {
			mv FX A OP_+;
			put 7 B;
			mv RES A OP_+;
			put minesweeper_MINES B;
			mv RES MAR;
			mv EX A OP_+;
			mv MDR B OP_+;
			mv RES EX;
		};
		//Check below right, if appropriate
		mv FX A OP_&;
		put 0b000111 B;
		mv RES A OP_-;
		put 0b111 B;
		if! RES {
			mv FX A OP_+;
			put 9 B;
			mv RES A OP_+;
			put minesweeper_MINES B;
			mv RES MAR;
			mv EX A OP_+;
			mv MDR B OP_+;
			mv RES EX;
		};
	};
	//If FX%8 != 111, check spot to right
	mv FX A OP_&;
	put 0b000111 B;
	mv RES A OP_-;
	put 0b111 B;
	if! RES {
		mv FX A OP_+;
		put 1 B;
		mv RES A OP_+;
		put minesweeper_MINES B;
		mv RES MAR;
		mv EX A OP_+;
		mv MDR B OP_+;
		mv RES EX;
	};
	//Store EX in appropriate location in array
	mv FX A OP_+;
	put minesweeper_ADJACENT B;
	mv RES MAR;
	mv EX MDR;

	};
};

//Draw the board
func minesweeper_draw {
	put 4 FX;
	//Set cursor
	call print_set_cursor 0 2;
	for! EX 0 64 {
			mv EX A OP_+;
			put minesweeper_FLAGS B;
			mv RES MAR;
			if! MDR {
				call print_char 0xf021;
				jump minesweeper_draw_END;
			};

			mv EX A OP_+;
			put minesweeper_REVEALED B;
			mv RES MAR;
			if_not_else! MDR {
				call print_char 219;
			} {
				mv EX A OP_+;
				put minesweeper_MINES B;
				mv RES MAR;
				if_else! MDR {
					call print_char 0xe058;
				} {
					mv EX A OP_+;
					put minesweeper_ADJACENT B;
					mv RES MAR;
					mv MDR A OP_+;
					put 48 B;
					call print_char RES;
				};
			};
		label minesweeper_draw_END;
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

//Darw the cursor on the board
func minesweeper_draw_cursor {
	//Only draw if ms& 0b100000000==0
	mv CR CR OP_&;
	in A TIMEIO_MS;
	put 0x80 B;
	if_not! RES {
		mv minesweeper_CURY A OP_*;
		put 2 B;
		mv RES A OP_+;
		put 2 B;
		mv RES AX;
		mv minesweeper_CURX A OP_*;
		put 2 B;
		mv RES BX;
		call print_set_cursor BX AX;
		call print_char 0x1fdb;
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
	//Print number of flagged squares + "/10"
	call print_set_cursor 17 0;
	put 0 AX;
	//Sum minesweeper_FLAGS
	for! BX 0 64 {
		mv BX A OP_+;
		put minesweeper_FLAGS B;
		mv RES MAR;
		mv MDR A OP_+;
		mv AX B OP_+;
		mv RES AX;
	};
	call print_unsigned AX;
	call print &minesweeper_num_flagged_msg;
};

//Handle key presses
func minesweeper_handle_keys {
	in A KEY_IN_WAITING;
	if! A {
		//Put key in
		in AX KEY_DATA;
		out CR KEY_NEXT;
		//Don't use releases
		mv AX A OP_&;
		put 0xff00 B;
		mv RES CND;
		jumpc minesweeper_handle_keys_END;
		//Handle up key
		mv AX A OP_-;
		put KEY_UP B;
		if_not! RES {
			call minesweeper_move_cursor 0 -1;
		};
		//Handle key down
		mv AX A OP_-;
		put KEY_DOWN B;
		if_not! RES {
			call minesweeper_move_cursor 0 1;
		};
		//Handle left key
		mv AX A OP_-;
		put KEY_LEFT B;
		if_not! RES {
			call minesweeper_move_cursor -1 0;
		};
		//Handle right down
		mv AX A OP_-;
		put KEY_RIGHT B;
		if_not! RES {
			call minesweeper_move_cursor 1 0;
		};
		//Handle enter
		mv AX A OP_-;
		put 10 B;
		if_not! RES {
			call minesweeper_reveal minesweeper_CURX minesweeper_CURY;
		};
		//Handle space
		mv AX A OP_-;
		put 32 B;
		if_not! RES {
			call minesweeper_flag minesweeper_CURX minesweeper_CURY;
		};

	};
	label minesweeper_handle_keys_END;
};

//Flag a square
func minesweeper_flag $x $y {
	mv $y A OP_*;
	put 8 B;
	mv RES A OP_+;
	mv $x B OP_+;
	mv RES AX;
	//You can't flag a revealed square
	mv AX A OP_+;
	put minesweeper_REVEALED B;
	mv RES MAR;
	mv MDR CND;
	jumpc minesweeper_flag_END;

	mv AX A OP_+;
	put minesweeper_FLAGS B;
	mv RES MAR;
	mv MDR A OP_NOT;
	mv RES MDR;
	label minesweeper_flag_END;
};

//Reveal a square
func minesweeper_reveal $x $y {
	mv $y A OP_*;
	put 8 B;
	mv RES A OP_+;
	mv $x B OP_+;
	mv RES AX;
	//You can't reveal a flaged square-unflag it first
	mv AX A OP_+;
	put minesweeper_FLAGS B;
	mv RES MAR;
	mv MDR CND;
	jumpc minesweeper_reveal_END;
	mv AX A OP_+;
	put minesweeper_REVEALED B;
	mv RES MAR;
	put 1 MDR;
	//check for death
	mv AX A OP_+;
	put minesweeper_MINES B;
	mv RES MAR;
	//A mine was revealed
	if! MDR {
		call minesweeper_die;
	};

	label minesweeper_reveal_END;
};

//go through minesweeper_REVEALED, and if a zero is found, reveal all the squares around it
func minesweeper_reveal_zeros {
	//X loop
	for! EX 0 8 {
		//Y loop
		for! FX 0 8 {
			mv FX A OP_*;
			put 8 B;
			mv RES A OP_+;
			mv EX B OP_+;
			mv RES DX;
			//CHeck if revealed
			mv DX A OP_+;
			put minesweeper_REVEALED B;
			mv RES MAR;
			if! MDR {
				//Check if zero in minesweeper_ADJACENT
				mv DX A OP_+;
				put minesweeper_ADJACENT B;
				mv RES MAR;
				if_not! MDR {
					call minesweeper_reveal_check_adj_up EX FX;
					call minesweeper_reveal_check_adj_down EX FX;
					call minesweeper_reveal_check_adj_left EX FX;
					call minesweeper_reveal_check_adj_right EX FX;
					//Handle new zeros in the next frame
					//jump minesweeper_reveal_zeros_END;
				};
			};
		};
	};
	label minesweeper_reveal_zeros_END;
};

#macro minesweeper_FORCE_REV REG X REG Y
	mv Y A OP_*;
	put 8 B;
	mv RES A OP_+;
	mv X B OP_+;
	mv RES A OP_+;
	put minesweeper_REVEALED B;
	mv RES MAR;
	put 1 MDR;
\

func minesweeper_reveal_check_adj_left $x $y {
	//If $x > 0, reveal left
	mv $x A OP_>;
	put 0 B;
	if! RES {
		mv $x A OP_-;
		put 1 B;
		mv RES BX;
		mv $y CX;
		minesweeper_FORCE_REV BX CX;
	};
};

func minesweeper_reveal_check_adj_up $x $y {
	//If $y > 0, reveal up
	mv $y A OP_>;
	put 0 B;
	if! RES {
		mv $x BX;
		mv $y A OP_-;
		put 1 B;
		mv RES CX;
		minesweeper_FORCE_REV BX CX;
		//If $x > 0, reveal up-left
		mv $x A OP_>;
		put 0 B;
		if! RES {
			mv $x A OP_-;
			put 1 B;
			mv RES BX;
			mv $y A OP_-;
			put 1 B;
			mv RES CX;
			minesweeper_FORCE_REV BX CX;
		};
		//If $x != 7, reveal up-right
		mv $x A OP_-;
		put 7 B;
		if! RES {
			mv $x A OP_+;
			put 1 B;
			mv RES BX;
			mv $y A OP_-;
			put 1 B;
			mv RES CX;
			minesweeper_FORCE_REV BX CX;
		};
	};
};

func minesweeper_reveal_check_adj_right $x $y {
	//If $x != 7, reveal right
	mv $x A OP_-;
	put 7 B;
	if! RES {
		mv $x A OP_+;
		put 1 B;
		mv RES BX;
		mv $y CX;
		minesweeper_FORCE_REV BX CX;
	};
};

func minesweeper_reveal_check_adj_down $x $y {
	//If $y != 7, reveal down
	mv $y A OP_-;
	put 7 B;
	if! RES {
		mv $y A OP_+;
		put 1 B;
		mv RES CX;
		mv $x BX;
		minesweeper_FORCE_REV BX CX;
		//If $x > 0, reveal down-left
		mv $x A OP_>;
		put 0 B;
		if! RES {
			mv $x A OP_-;
			put 1 B;
			mv RES BX;
			mv $y A OP_+;
			put 1 B;
			mv RES CX;
			minesweeper_FORCE_REV BX CX;
		};
		//If $x != 7, reveal down-right
		mv $x A OP_-;
		put 7 B;
		if! RES {
			mv $x A OP_+;
			put 1 B;
			mv RES BX;
			mv $y A OP_+;
			put 1 B;
			mv RES CX;
			minesweeper_FORCE_REV BX CX;
		};
	};

};

//Move the cursor by x and y
func minesweeper_move_cursor $x $y {
	mv minesweeper_CURX A OP_+;
	mv $x B OP_+;
	//Limit to 0-7
	mv RES A OP_&;
	put 0b111 B;
	mv RES minesweeper_CURX;

	mv minesweeper_CURY A OP_+;
	mv $y B OP_+;
	//Limit to 0-7
	mv RES A OP_&;
	put 0b111 B;
	mv RES minesweeper_CURY;
};

//The player died
func minesweeper_die {
	//Reveal the full board, and draw
	for! FX 0 64 {
		mv FX A OP_+;
		put minesweeper_REVEALED B;
		mv RES MAR;
		put 1 MDR;
		mv FX A OP_+;
		put minesweeper_FLAGS B;
		mv RES MAR;
		put 0 MDR;
	};
	call minesweeper_draw;
	call print_set_cursor 0 39;
	call print &minesweeper_death_msg;
	jump SHELL_RETURN;
};

//Check if the player has won - if all squares have been revealed or flaged, and exactly 10 squares are flagged, the game has been won
func minesweeper_check_win {
	//Number of flagged squares
	put 0 AX;
	//true if a bad square has been found
	put 0 CX;
	for! FX 0 64 {
		put 0 BX;
		mv FX A OP_+;
		put minesweeper_REVEALED B;
		mv RES MAR;
		if! MDR {
			put 1 BX;
		};
		mv FX A OP_+;
		put minesweeper_FLAGS B;
		mv RES MAR;
		if! MDR {
			put 1 BX;
			inc AX;
		};
		mv BX A OP_NOT;
		mv RES A OP_|;
		mv CX B;
		mv RES CX;

	};
	mv AX A OP_-;
	put 10 B;
	mv RES A OP_|;
	mv CX B OP_|;
	if_not! RES {
		call minesweeper_draw;
		call print_set_cursor 0 39;
		call print &minesweeper_win_msg;
		jump SHELL_RETURN;
	};

	label minesweeper_check_win_END;
};


label minesweeper_time_start;
. 0;

#string minesweeper_time_msg
Time: \

#string minesweeper_name
Minesweeper\

#string minesweeper_death_msg
YOU DIED\

#string minesweeper_win_msg
YOU WON\

#string minesweeper_num_flagged_msg
/10\
