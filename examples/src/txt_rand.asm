/* Random Text Generator - darksteelcode
 * Fill the screen with psuedo-random text
 */

#include std.asm\
#include stdio.c16\
#include stdtime.asm\

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

#ifnotdef !IS_SHELL
label SHELL_RETURN;
\

jump SHELL_RETURN;

