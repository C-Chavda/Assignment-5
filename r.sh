#!/bin/bash
# MIT License
# Author: Chandresh Chavda
# File: r.sh
# Description: Script to assemble and link all modules for the Electricity project

# Clean
rm -f *.o electricity

# Compile with debug
echo "Compiling..."
nasm -f elf64 -F dwarf -g -o edison.o edison.asm || { echo "Failed to compile edison.asm"; exit 1; }
nasm -f elf64 -F dwarf -g -o tesla.o tesla.asm || { echo "Failed to compile tesla.asm"; exit 1; }
nasm -f elf64 -F dwarf -g -o faraday.o faraday.asm || { echo "Failed to compile faraday.asm"; exit 1; }

# Link
echo "Linking..."
ld -o electricity faraday.o edison.o tesla.o || { echo "Linking failed"; exit 1; }

# Run
chmod +x electricity
./electricity