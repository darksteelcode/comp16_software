all: bootloader test
bootloader:
	./build bootloaders
test:
	./build tests
install:
	sudo ln -sf /home/edward/comp16_software/libraries/src/stdops.asm /usr/c16-include/stdops.asm
	sudo ln -sf /home/edward/comp16_software/libraries/src/stdports.asm /usr/c16-include/stdports.asm
	sudo ln -sf /home/edward/comp16_software/libraries/src/std.asm /usr/c16-include/std.asm
