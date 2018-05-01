#!/bin/bash

DIR=$1
for file in $DIR/src/*.asm
do
name="${file##*/}"
nameNoExten="${name%%.*}"
c16asm -o $DIR/bin/"$nameNoExten".bin $file || exit 1
done
