#include std.asm\
#include stdtime.asm\

#macro fill_screen! ANY char
	put 0 AX;
	mv char BX;
	label MACROID0;
		out AX GFX_TXT_ADDR;
		out BX GFX_TXT_DATA;
		inc AX;
		mv AX B OP_>;
		put 1000 A;
		mv RES CND;
		jumpc MACROID0;
\

print! msg;

ps2_clear_keys!;
label key_wait;

in A KEY_IN_WAITING;
mv CR CR OP_NOT;
mov RES CND;
jumpc key_wait;

in A KEY_DATA;
out A KEY_NEXT;
mv CR CR OP_&;
put 0x00ff B;
mv RES A OP_-;
put 13 B;
mv RES CND;
prb CR 0xff00;
jpc CR 0xff00;

put 0x00db FX;
label start;

fill_screen! 0x0020;
wait! 1;
fill_screen! FX;
wait! 1;

mv FX A OP_+;
put 256 B;
mv RES FX;

jump start;

label msg;
#string
Flashing Lights Ahead - Esc to Exit, Enter To countinue
\
