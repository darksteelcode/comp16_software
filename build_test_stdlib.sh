#!/bin/bash

for file in stdlib/src/*.asm
do
name="${file##*/}"
nameNoExten="${name%%.*}"
c16asm -o /dev/null $file || exit 1
done
