# Cross Toolchain Setup

This laboratory exercise introduces the fundamental concept of cross-development
by guiding you through the hands-on configuration of a vendor-supplied RISC-V
toolchain. Unlike native compilation, where code is built and run on the same
system, cross-development is essential whenever the target platform differs from
the host machine—whether that target is a resource-constrained embedded device or
a pre-silicon simulation environment awaiting hardware availability. This
practical session will familiarize you with the specific tools, paths, and
compiler flags necessary to target a particular RISC-V core. Mastering this setup
process is a key skill for both embedded and hardware-software co-design
contexts, and ensures you have a reliable, consistent build environment for all
future coursework.

## Prerequisites

To eliminate the complexity and variability of manual toolchain installation
across different host systems, this lab provides the complete RISC-V development
environment within a pre-configured Docker container. Containerization ensures
that every student works with an identical, reproducible toolchain regardless of
their underlying operating system, sidestepping common issues such as path
mismatches, dependency conflicts, or version inconsistencies. By simply pulling
and running the provided Docker image, you will instantly have access to the
vendor-specific compiler, assembler, and linker—all neatly isolated from your
host environment.

If you are new to Docker or need a refresher on the basic commands for docker
setup and/or managing containers, please consult the following resources before
proceeding:

1. [Docker setup](../../tutorials/docker-setup.md)
1. [Docker howto](../../tutorials/docker.md)

If you principially don't want to install docker, you can install SC-DT toolchain
manyally on you machine using Installation Guide from the official
[website](https://syntacore.com/tools/development-tools).

## Download and run docker image

1. Download docker image with all tools

        docker image pull ghcr.io/riscv-technologies-lab/rv_tools_image:1.0.10

   **important:** note that this image is quite heavy: about 10 Gb. This
   image contains all software required for our course, that's why it is so
   huge.
1. `cd` to your working directory. This directory will be mounted in docker
contaier.
1. Run dowloaded docker image

        docker run \
          --interactive \
          --tty \
          --detach \
          --env "TERM=xterm-256color" \
          --env "KEEP_SUDO=" \
          --env "USER_ID=1000" \
          --env "USER_NAME=$USER" \
          --mount type=bind,source="$(pwd)",target="$(pwd)" \
          --ulimit nofile=1024:1024 \
          --workdir "$HOME" \
          --name rv_tools_image_cont_example \
          riscv-technologies-lab/rv_tools_image:1.0.10

   **note:** please pay attention to `mount`, `workdir` and `name` options:
   if you want you can vary mount points, entry workdir in the container and
   it's name.

## Toolchain supply

In our classes we use Syntacore Development Toolkit (SC-DT). The toolkit is
a convenient development environment based on GCC and clang/LLVM toolchains. The
GCC toolchain includes a pre-built compiler, OpenOCD, GDB and gdbserver with
python scripts as well as an assembler, linker, binutils, and standard C and C++
libraries for Linux and bare-metal targets, including Newlib, newlib_nano, and
glibc. The clang/LLVM-based toolchain provides advanced microarchitecture-aware
optimizations out-of-the-box. SC-DT also includes FreeRTOS, Zephyr, and Linux
operating systems, bootloaders, a QEMU simulation environment fully compatible
with FPGA SDKs, a BSP package with single and multicore support and a set of
applications examples and benchmarks.

SC-DT is already installed in downloaded docker container at `/opt/sc-dt/`. Now
to can compile `Hello, world!` program for RISC-V you need:

1. Dump program sample

        echo -e '#include <stdio.h> \n\nint main() { \n\tprintf("Hello, RISC-V!\\n"); \n}' > hello.c

1. Compile

        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2

   **note:** you shall do static build to avoid dynamic libraries search.
1. Check assembly with a riscv objdump

        riscv64-unknown-linux-gnu-objdump -S hello.x

1. Run on qemu simulator

        qemu-riscv64 hello.x

1. You can try to build a program with different extensions using `march` option:

        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2 -march=rv64id
        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2 -march=rv64imd
        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2 -march=rv64imad
        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2 -march=rv64imadc

   **note:** you need to specify `lp64` ABI to copile without D support

        riscv64-unknown-linux-gnu-gcc hello.c -o hello.x -static -O2 -march=rv64imc -mabi=lp64

