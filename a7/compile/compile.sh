#!/bin/bash
# Assumes that the following files are present in this directory
# - crt0.s 	: basic runtime to jump to beginning of function
# - riscv32.ld 	: linker script specifying memory

riscv32-unknown-elf-gcc -g -ffreestanding -O0 -Wl,--gc-sections \
    -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld \
    crt0.s  $@ -o out.elf

riscv32-unknown-elf-objdump -d -Mnumeric,no-aliases out.elf | grep "^ " > out.dump
awk '{print $2}' out.dump

