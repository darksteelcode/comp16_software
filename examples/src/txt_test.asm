/* Graphics Text Test - darksteelcode
 * clear screen, print string, blink char
 */
#include std.asm\

prb AX 0;
pra AX 0;
label clear;
out AX GFX_TXT_ADDR;
pra CR 32;
prb CR 32;
out CR GFX_TXT_DATA;
mov AX A OP_+;
pra B 1;
prb B 1;
mov RES AX OP_+;

mov AX A OP_&;
prb B 0b0000001111111111;
pra B 0b0000001111111111;
mov RES CND;

prb CR clear;
jpc CR clear;

prb AX 0;
pra AX 0;
label string_print;
	mov AX A OP_+;
	pra B string;
	prb B string;
	mov RES MAR;
	out AX GFX_TXT_ADDR;
	out MDR GFX_TXT_DATA;
	mov AX A OP_+;
	prb B 1;
	pra B 1;
	mov RES AX;
	mov MDR CND;
	prb CR string_print;
	jpc CR string_print;

label blink;
prb FX 0;
pra FX 0;
prb EX 0;
pra EX 0;
label inner_wait_1;
	prb B 1;
	pra B 1;
	mov FX A OP_+;
	mov RES FX;
	mov FX CND;
	prb CR inner_wait_1;
	jpc CR inner_wait_1;
mov EX A OP_+;
mov RES EX;
mov EX A OP_&;
prb B 0x000f;
pra B 0x000f;
mov RES CND;
prb CR inner_wait_1;
jpc CR inner_wait_1;
pra CR 80;
prb CR 80;
out CR GFX_TXT_ADDR;

pra CR 219;
prb CR 219;
out CR GFX_TXT_DATA;

prb FX 0;
pra FX 0;
prb EX 0;
pra EX 0;
label inner_wait_2;
	prb B 1;
	pra B 1;
	mov FX A OP_+;
	mov RES FX;
	mov FX CND;
	prb CR inner_wait_2;
	jpc CR inner_wait_2;
mov EX A OP_+;
mov RES EX;
mov EX A OP_&;
prb B 0x000f;
pra B 0x000f;
mov RES CND;
prb CR inner_wait_2;
jpc CR inner_wait_2;
pra CR 80;
prb CR 80;
out CR GFX_TXT_ADDR;
pra CR ' ';
prb CR ' ';
out CR GFX_TXT_DATA;
prb CR blink;
jmp CR blink;

label end;
prb CR end;
jmp CR end;

label string;
#string
Hello World!                            Testing!!\
. 0x00;
