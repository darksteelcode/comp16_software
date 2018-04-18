.PHONY: all
all: bootloaders examples tests games
.PHONY:	games
games:
	./build games
.PHONY: bootloaders
bootloaders:
	./build bootloaders
.PHONY: tests
tests:
	./build tests
.PHONY: examples
examples:
	./build examples
install:
	sudo mkdir -p /usr/c16_include
	sudo ln -sf `pwd`/stdlib/src/* /usr/c16_include/
clean:
	rm -f */bin/*
