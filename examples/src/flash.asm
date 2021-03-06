#include std.asm\
#include stdio.c16\
#include stdtime.c16\

#macro fill_screen! ANY char
	put 0 AX;
	mv char BX;
	label MACROID0;
		out AX GFX_TXT_ADDR;
		out BX GFX_TXT_DATA;
		inc AX;
		mv AX B OP_>;
		mv FLASH_cov A OP_>;
		mv RES CND;
		jumpc MACROID0;
\
call time_delay_ms 400;
call key_clear;
put 0 FLASH_cov;
put 0x00db FX;
label FLASH_start;

fill_screen! FX;
call time_delay_ms 20;

in CND KEY_IN_WAITING;
jumpc SHELL_RETURN;
for! AX 0 10 {
inc FLASH_cov;
};
mv FLASH_cov A OP_>;
put 1000 B;
if! RES {
	put 1000 FLASH_cov;
};
mv FX A OP_+;
put 256 B;
mv RES FX;

#ifnotdef !IS_SHELL
label SHELL_RETURN;
\

jump FLASH_start;

label FLASH_cov;
. 0;
