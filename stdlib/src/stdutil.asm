#include stdlang.asm\
#include stdops.asm\

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

#macro clear_keys!
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
