/* Random Text Generator - darksteelcode
 * Fill the screen with psuedo-random text
 */

for! FX 0 1000 {
mov FX A OP_*;
mov FX B OP_*;
mov RES A OP_^;
put B 0xf342;
mov RES A OP_*;
mov FX B OP_*;
call print_char RES;

};
wait! 10;
jump SHELL_RETURN;
