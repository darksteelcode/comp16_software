/* stdtime.asm - Comp16 Standard Time Assembley File
 * Edward Wawrzynek
 * Used prefixes - time_, hang!,  wait! (will change)
 * --------
 * This will be changed soon, but currently has two simple macros
 * TODO: A hardware timer needs to be implemented in comp16
 * 	 These macros need to be moved to functions mostly grounded in real units, and time keeping func's need to be added
 * 	 A few programs will have to be converted to use unit based delays
 * 	 this file will just contain time definitions
 */

#include std.asm\

//Hang the program
#macro hang!
        label MACROID0;
        jump MACROID0;
\

//Wait for a certain number of loops
#macro wait! VAL cycles
	put 0 AX;
        put 0 BX;
        label MACROID0;
                inc AX;
                mv AX CND;
                jumpc MACROID0;
        mv BX B OP_>;
        put cycles A;
        mv RES CND;
        inc BX;
        jumpc MACROID0;
\
