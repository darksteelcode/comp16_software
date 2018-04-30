.PHONY: all
all: bootloaders examples tests games shells
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
.PHONY: shells
shells:
	./build shells
install:
	sudo mkdir -p /usr/local/c16_include
	sudo touch /usr/local/c16_include/dummy.txt
	sudo rm /usr/local/c16_include/*
	sudo ln -sf `pwd`/stdlib/src/* /usr/local/c16_include/
clean:
	rm -f */bin/*
