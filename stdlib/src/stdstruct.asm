/* Standard Structure Programming Macros - darksteelcode
 * standard structure programming tools - work in progress
 */

#include stdlang.asm\

#macro inf_loop! CODE code
	label MACROID0;
	code
	jump MACROID0;
\


//Runs code for var in start to end, end not being included
#macro for! ANY var VAL start VAL end CODE code
	put start var;
	label MACROID0;
	code
	inc var;
	mv VAR B OP_>;
	put end A;
	mv RES CND;
	jumpc MACROID0;
\
	
