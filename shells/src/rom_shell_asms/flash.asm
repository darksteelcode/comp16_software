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
wait! 20;
ps2_clear_keys!;
put 0 FLASH_cov;
put 0x00db FX;
label FLASH_start;

fill_screen! FX;
wait! 1;

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

jump FLASH_start;

label FLASH_cov;
. 0;
