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

wait! 3;
