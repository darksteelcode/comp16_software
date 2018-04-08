//Macro Testing - doesn't do anything interesting

#include std.asm\

#macro port_out VAL port VAL val_to_write
	put CR val_to_write;
	out CR port;
\

port_out 0 0x1234;
