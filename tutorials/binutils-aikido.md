# Binutils Aikido

## Assemble hello world

To assemble hello world just call assembler:

```sh
riscv64-unknown-linux-gnu-as -march=rv32i -mabi=ilp32 -o hello.o hello.S
```

## Link hello world

To link hello world just call linker:

```sh
riscv64-unknown-linux-gnu-ld -march=rv32i -m elf32lriscv_ilp32 -o hello.elf hello.o
```

## Creating memory image

A memory image is simply a copy of the process's virtual memory, saved in a file.
By default compiler produces file in ELF binary format. Such file contains
sections with data (this data can be instructions) and metadata about sections.
To simplify program loading you can confer .elf to .bin format:

```sh
riscv64-unknown-linux-gnu-objcopy -O binary hello.elf hello.bin
```

After that you can check that code in binary file is the same as in elf:

```sh
# Watch elf disassembly
riscv64-unknown-linux-gnu-objdump -D hello.elf
# Watch binary encoding
xxd hello.bin
```
