/* Basic Test Program - darksteelcode
 * Increment port 0 every 65536 cycles
 */
//Registers - AX is used to store value to increment for delay, CR is used for jumping, port 0 value is gotten using in statment

label wait_loop_start;
mov AX A 0; //0 for addition
prb B 0'h;
pra B 1'l;
mov RES AX;
mov AX CND;
jpc CR wait_loop_start; //Jump if AX has not yet reached 0
in A 0;
out RES 0;
jmp CR wait_loop_start; 
