call print &img1;
wait! 64;
call print &img2;
wait! 64;
call print &img3;
wait! 64;
jump SHELL_RETURN;

label img1;
#include examples/src/img_data1.txt\
label img2;
#include examples/src/img_data2.txt\
label img3;
#include examples/src/img_data3.txt\
