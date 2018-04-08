/* Standard Language Macros - darksteelcode
 * macros mv and put to abstract away weirdnesses with isa, and make writing macros for ANY types easier
 */

/* mv instruction (mv ANY src ANY dst [VAL op])
 * This macro moves one value of any type into the other value of any type, and specifies an optional alu op argument
 * For memory, it moves the values in memory, not the memory addresses - put does that
 */
//reg -> reg
#macro mv REG src REG dst
	mov src dst;
\
#macro mv REG src REG dst VAL op
	mov src dst op;
\
//mem -> reg
#macro mv MEM src REG dst
	prb MAR src;
	lod dst src;
\
#macro mv MEM src REG dst VAL op
	prb MAR src;
	pra MAR src;
	mov MDR dst op;
\
//val -> reg
#macro mv VAL src REG dst
	prb dst src;
	pra dst src;
\
#macro mv VAL src REG dst VAL op
	prb dst src;
	pra dst src;
	mov dst dst op;
\
//reg -> mem
#macro mv REG src MEM dst
	prb MAR dst;
	str src dst;
\
#macro mv REG src MEM dst VAL op
	prb MAR dst;
	pra MAR dst;
	mov src MDR op;
\
//mem -> mem
#macro mv MEM src MEM dst
	prb MAR src;
	lod CR src;
	prb MAR dst;
	str CR dst;
\
#macro mv MEM src MEM dst VAL op
	prb MAR src;
	lod CR src;
	prb MAR dst;
	pra MAR dst;
	mov CR MDR op;
\
//val -> mem
#macro mv VAL src MEM dst
	prb CR src;
	pra CR src;
	prb MAR dst;
	str CR dst;
\
#macro mv VAL src MEM dst VAL op
	prb CR src;
	pra CR src;
	prb MAR dst;
	pra MAR dst;
	mov CR MDR op;
\
//for completness, anything -> val (you can't store something in a value
#macro mv ANY src VAL dst
\
#macro mv ANY src VAL dst VAL op
mov CR CR op;
\

/* put instruction (put ANY src ANY dst [VAL op])
 * This macro puts any type's literal value into any type
 * For regs, this is the same as mv, for memory-it puts the addrs of the memory in dst, not the value, for vals, the same as mv
 */
//reg -> reg
#macro put REG src REG dst
	mv src dst;
\
#macro put REG src REG dst VAL op
	mv src dst op;
\
//mem -> reg
#macro put MEM src REG dst
	prb dst src;
	pra dst src;
\
#macro put MEM src REG dst VAL op
	prb dst src;
	pra dst src;
	mov CR CR op;
\
//val -> reg
#macro put VAL src REG dst
	mv src dst;
\
#macro put VAL src REG dst VAL op
	mv src dst op;
\
//reg -> mem
#macro put REG src MEM dst
	mv src dst;
\
#macro put REG src MEM dst VAL op
	mv src dst op;
\
//mem -> mem
#macro put MEM src MEM dst
	prb CR src;
	pra CR src;
	prb MAR dst;
	str CR dst;
\
#macro put MEM src MEM dst VAL op
	prb CR src;
	pra CR src;
	prb MAR dst;
	pra MAR dst;
	mov CR MDR op;
\
//val -> mem
#macro put VAL src MEM dst
	mv src dst;
\
#macro put VAL src MEM dst VAL op
	mv src dst op;
\
//any -> val for completness
#macro put ANY src VAL dst
\
#macro put ANY src VAL dst VAL op
	mov CR CR op;
\
