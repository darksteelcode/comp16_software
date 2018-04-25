#include std.asm\
#include stdutil.asm\
#include stdstruct.asm\

call do_some_recurse 0 1000;
call out_val 0xf0f0;

hang!;

func do_some_recurse $i $limit {
	local $recurse_level;
	put 0 $recurse_level;
	mv $i A OP_+;
	put 1 B;
	mv RES $recurse_level OP_+;
	mv RES B OP_>;
	mv $limit A OP_>;
	if! RES {
		mv CR CR OP_+;
		in A GFX_TXT_ADDR;
		put 1 B;
		out RES GFX_TXT_ADDR;
		put 65 AX;
		out AX GFX_TXT_DATA;
		mov $limit BX OP_>;
		call do_some_recurse $recurse_level BX;
	};
};

func out_val $arg1 {
	local $tmp_str;
	mv $arg1 $tmp_str;
	out $tmp_str 0;
};

