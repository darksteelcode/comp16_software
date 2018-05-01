.PHONY: all
all: bootloaders examples tests games shells
.PHONY:	games
games:
	./build.sh games
.PHONY: bootloaders
bootloaders:
	./build.sh bootloaders
.PHONY: tests
tests:
	./build.sh tests
.PHONY: examples
examples:
	./build.sh examples
.PHONY: shells
shells:
	./build.sh shells
test_stdlib:
	./build_test_stdlib.sh
install:
	sudo mkdir -p /usr/local/c16_include
	sudo touch /usr/local/c16_include/dummy.txt
	sudo rm /usr/local/c16_include/*
	sudo ln -sf `pwd`/stdlib/src/* /usr/local/c16_include/
clean:
	rm -f */bin/*
