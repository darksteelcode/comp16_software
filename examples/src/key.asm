/* Key Test - darksteelcode
 * Put key presses on the screen - no formating
 */
#include std.asm\

prb BX 0;
pra BX 0;
label start;

in A KEY_IN_WAITING;
mov CR CR OP_NOT;
mov RES CND;
prb CR start;
jpc CR start;

in AX KEY_DATA;
out AX KEY_NEXT;

mov AX A OP_&;
prb B 0b0000000100000000;
pra B 0b0000000100000000;
mov RES CND;
prb CR start;
jpc CR start;
out BX GFX_TXT_ADDR;
mov BX A OP_+;
prb B 1;
pra B 1;
mov RES BX;
out AX 0;
out AX GFX_TXT_DATA;
prb CR start;
jmp CR start;
