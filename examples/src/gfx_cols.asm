#include std.asm\

label print;
mov AX A OP_+;
prb B string;
pra B string;
mov RES MAR;
out AX GFX_TXT_ADDR;
out MDR GFX_TXT_DATA;
mov AX A OP_+;
pra B 1;
prb B 1;
mov RES AX;
mov MDR CND;
prb CR print;
jpc CR print;

pra AX 40;
prb AX 40;
prb CX 219;
pra CX 219;

label start;
out AX GFX_TXT_ADDR;
out CX GFX_TXT_DATA;
mov CX A OP_+;
prb B 0x100;
pra B 0x100;
mov RES CX;

mov AX A OP_+;
prb B 1;
pra B 1;
mov RES AX;
mov RES B OP_>;
prb A 296;
pra A 296;
mov RES CND;
prb CR start;
jpc CR start;

label end;
prb CR end;
jmp CR end;

label string;
#string
Comp16 Text Color Palette - 8 Bit Color\
. 0;
