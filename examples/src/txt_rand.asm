/* Random Text Generator - darksteelcode
 * Fill the screen with psuedo-random text
 */
#include std.asm\
#include stdio.c16\

label PRGM_START;

pra AX 0;
prb AX 0;

label loop;
out AX GFX_TXT_ADDR;

mov AX A OP_*;
mov AX B OP_*;
mov RES A OP_^;
prb B 0xf342;
pra B 0xf342;
mov RES A OP_*;
mov AX B OP_*;
out RES GFX_TXT_DATA;

prb B 1;
pra B 1;
mov AX A OP_+;
mov RES AX;
mov RES CND;
prb CR loop;
jpc CR loop;

label end;
prb CR end;
jmp CR end;
