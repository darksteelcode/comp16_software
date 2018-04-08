.PHONY: all
all: bootloaders tests
.PHONY: bootloaders
bootloaders:
	./build bootloaders
.PHONY: tests
tests:
	./build tests
install:
	sudo mkdir -p /usr/c16_include
	sudo ln -sf `pwd`/stdlib/src/* /usr/c16_include/
