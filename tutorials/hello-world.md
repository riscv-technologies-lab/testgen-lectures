# How to run hello world

Minimal example of hello world program for linux:

```asm
# a0-a5 - parameters to linux function services
# a7 - linux function number
#

.global _start      # Provide program starting address to linker

# Setup the parameters to print hello world
# and then call Linux to do it.

_start: addi  a0, x0, 1      # 1 = StdOut
        la    a1, helloworld # load address of helloworld
        addi  a2, x0, 13     # length of our string
        addi  a7, x0, 64     # linux write system call
        ecall                # Call linux to output the string

# Setup the parameters to exit the program
# and then call Linux to do it.

        addi    a0, x0, 0   # Use 0 return code
        addi    a7, x0, 93  # Service command code 93 terminates
        ecall               # Call linux to terminate the program

.data
helloworld:      .ascii "Hello World!\n"
```

To run this on simulator you can use semihosting mechanism.

## What is semihosting

Semihosting is a mechanism that enables code running on a target to communicate
and use the Input/Output facilities on a host computer.

Examples of these facilities include keyboard input, screen output, and disk I/O.
For example, you can use this mechanism to enable functions in the C library,
such as `printf()` and `scanf()`, to use the screen and keyboard of the host
instead of having a screen and keyboard on the target system.

Semihosting can be implemented by special simulation of `ecall` instruction.
Instead of trasfer of control to linux, just call that syscall on host system.

## syscalls in RISC-V

In RISC-V the `ecall` instruction is used to do system call. Calling convention
for syscalls:

- syscall arguments are loaded into a0-a5
- syscall number is loaded into a7

Example of several syscalls numbers:

| Syscall | Number |
| ------- | ------ |
| read    | 63     |
| write   | 64     |
| exit    | 93     |

You can find numbers of other syscalls
[here](https://jborza.com/post/2021-05-11-riscv-linux-syscalls/ "RISC-V linux syscalls").

To implement semihosting through `ecall` simulation just check registers state
and call corresponding syscall from host.
