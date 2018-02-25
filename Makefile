all: bootloader test
bootloader:
	./build bootloaders
test:
	./build tests
