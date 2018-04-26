#include std.asm\
#include stdtime.asm\

label PRGM_START;

put 0xff00 SP;

call do_some_recurse 0 40 1;
//call out_val 0xf0f0;

hang!;

func do_some_recurse $i $limit $start {
	if! $start {
		mv CR CR OP_-;
		in A GFX_TXT_ADDR;
		put 1 B;
		out RES GFX_TXT_ADDR;
	};
	mv CR CR OP_+;
	in A GFX_TXT_ADDR;
	put 1 B;
	out RES GFX_TXT_ADDR;
	put 65 AX;
	out AX GFX_TXT_DATA;

	mv $i A OP_+;
	put 1 B;
	mv RES BX OP_+;
	mv RES B OP_>;
	mv $limit A OP_>;
	if! RES {
		call do_some_recurse BX $limit 0;
	};
	out $limit 0;
};

func out_val $arg1 {
	local $tmp_str;
	mv $arg1 $tmp_str;
	out $tmp_str 0;
};

