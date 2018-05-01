/* stdstruct.asm - Comp16 Standard Structure Programming Assembly File
 * Edward Wawrzynek
 * Used prefixes - inf_loop!, for!, if!, if_not!, if_else!, if_not_else!
 * --------
 * This file contains some structured programming macros
 * TODO: Better looping macros - whiles, dynamic for's, etc
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
	mv var B OP_>;
	put end A;
	mv RES CND;
	jumpc MACROID0;
\

//Run code if condition is true
#macro if! ANY cond CODE code
	mv cond A OP_NOT;
	mv RES CND;
	jumpc MACROID0;
	code
	label MACROID0;
\
//Run code if condition is not true
#macro if_not! ANY cond CODE code
	mv cond CND;
	jumpc MACROID0;
	code
	label MACROID0;
\
//Run first code if condition is true, otherwise run second
#macro if_else! ANY cond CODE if_true CODE if_false
	mv cond CND;
	jumpc MACROID0;
	if_false
	jump MACROID1;
	label MACROID0;
	if_true
	label MACROID1;
\

#macro if_not_else! ANY cond CODE if_false CODE if_true
	mv cond CND;
	jumpc MACROID0;
	if_false
	jump MACROID1;
	label MACROID0;
	if_true
	label MACROID1;
\	
