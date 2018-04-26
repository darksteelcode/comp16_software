/* Image Test - darksteelcode
 * Dispay an image using block chars
 */
#include std.asm\

label PRGM_START;
prb AX 0;
pra AX 0;
label print1;
prb B img1;
pra B img1;
mov AX A OP_+;
mov RES MAR OP_+;
out AX GFX_TXT_ADDR;
out MDR GFX_TXT_DATA;
mov AX A OP_+;
prb B 1;
pra B 1;
mov RES AX;
mov MDR CND;
prb CR print1;
jpc CR print1;

prb FX 0;
pra FX 0;
prb EX 0;
pra EX 0;
label wait1;
mov FX A OP_+;
prb B 1;
pra B 1;
mov RES FX;
mov RES CND;
prb CR wait1;
jpc CR wait1;
mov EX A OP_+;
mov RES EX;
mov RES A OP_&;
prb B 0x007f;
pra B 0x007f;
mov RES CND;
prb CR wait1;
jpc CR wait1;

prb AX 0;
pra AX 0;
label print2;
prb B img2;
pra B img2;
mov AX A OP_+;
mov RES MAR OP_+;
out AX GFX_TXT_ADDR;
out MDR GFX_TXT_DATA;
mov AX A OP_+;
prb B 1;
pra B 1;
mov RES AX;
mov MDR CND;
prb CR print2;
jpc CR print2;

prb FX 0;
pra FX 0;
prb EX 0;
pra EX 0;
label wait2;
mov FX A OP_+;
prb B 1;
pra B 1;
mov RES FX;
mov RES CND;
prb CR wait2;
jpc CR wait2;
mov EX A OP_+;
mov RES EX;
mov RES A OP_&;
prb B 0x007f;
pra B 0x007f;
mov RES CND;
prb CR wait2;
jpc CR wait2;

prb AX 0;
pra AX 0;
label print3;
prb B img3;
pra B img3;
mov AX A OP_+;
mov RES MAR OP_+;
out AX GFX_TXT_ADDR;
out MDR GFX_TXT_DATA;
mov AX A OP_+;
prb B 1;
pra B 1;
mov RES AX;
mov MDR CND;
prb CR print3;
jpc CR print3;

prb FX 0;
pra FX 0;
prb EX 0;
pra EX 0;
label wait3;
mov FX A OP_+;
prb B 1;
pra B 1;
mov RES FX;
mov RES CND;
prb CR wait3;
jpc CR wait3;
mov EX A OP_+;
mov RES EX;
mov RES A OP_&;
prb B 0x007f;
pra B 0x007f;
mov RES CND;
prb CR wait3;
jpc CR wait3;

prb CR 0xff00;
jmp CR 0xff00;

label img1;
#include examples/src/img_data1.txt\
label img2;
#include examples/src/img_data2.txt\
label img3;
#include examples/src/img_data3.txt\
