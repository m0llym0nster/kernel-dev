#!/bin/bash
echo "going to work!"
sleep 1
echo "assembling the kernel entry point.. start.asm"
nasm -f elf -o start.o start.asm
sleep 5
echo "if there is c source to compile...compling now"
gcc -m32 -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nosdtinc -fno-builtin -I./include -c -o main.o main.c
echo "compiled main"
sleep 5
gcc -m32 -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nosdtinc -fno-builtin -I./include -c -o scrn.o scrn.c
ehoc "compiled screen.c"
sleep 5
echo "linking compiled and assembled file together in 1 bin"
ld -m elf_i386 -T link.ld -o kernel.bin start.o main.o scrn.o
echo "complete"
