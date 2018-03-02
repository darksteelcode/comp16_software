/* Serial Test Program - darksteelcode
 * Flood the serial port with all the ascii and extended ascii chars
 */
//Register - AX is current char, BX is increment to use to wait some time to send next char.

//Loop to add a slight delay between characters
label wait_loop_start;
mov AX A 0;
prb B 0;
pra B 1;
mov RES AX;
mov AX CND;
jpc CR wait_loop_start;

//Check to make sure serial port is clear - if port 4 is 1, tx is still sending
label tx_busy_loop;
in CND 4;
jpc CR tx_busy_loop;

//Output AX to serial port - port 3 is to send data
out AX 3;

//Increment AX
mov AX A 0;
prb B 0;
pra B 1;
mov RES AX;
jmp CR wait_loop_start; 
