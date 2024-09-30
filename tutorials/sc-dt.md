# Syntacore Development Toolkit

**Syntacore Development Toolkit** is designed to create applications for
Syntacore cores.

It contains the latest releases of pre-built and pre-configured tools optimized
for Syntacore cores. The toolkit include the following basic packages:

- LLVM/clang — supports advanced optimization out of the box, micro-architecture
  aware optimizations, includes RVV autovectorization, CRC recognition and other
  features
- RISCV GCC with Assembler, Linker, Binutils, and Standard C/C++ libraries for
  Linux and bare-metal environments (Newlib and Glibc)
- GNU GDB — supports single and multicore configurations and Python scripts
- QEMU:
   - System level with Syntacore platforms
   - User level for Linux applications

## Recommended workflow

```sh
export IMAGE=ghcr.io/riscv-technologies-lab/rv_tools_image:1.0.10
export CONTAINER=rv_tools_experiments
export WORKDIR=$HOME/wd # or any other you want
mkdir -p ${WORKDIR}
cd ${WORKDIR}
docker run \
    --interactive \
    --tty \
    --detach \
    --env "TERM=xterm-256color" \
    --env "USER_ID=$(id --user)" \
    --env "USER_NAME=$(id --user --name)" \
    --mount type=bind,source="$(pwd)",target="$(pwd)" \
    --network=host \
    --workdir "$WORKDIR" \
    --name ${CONTAINER} \
    ${IMAGE}
docker exec -it ${CONTAINER} bash
```

### Compiler

```sh
riscv64-unknown-elf-gcc hello.c \
    -o hello.x \ # set output file
    -static \ # build statically
    -O2 # enable all safe optimizations
```

### Disassembler

```sh
riscv64-unknown-linux-gnu-objdump -S hello.x
```

### User qemu

```sh
qemu-riscv64 hello.x
```

### GDB (remote-debug)

**note** Before starting remote debugging, please ensure you done all steps from [ssh setup](ssh-setup-wireless.md).

```sh
riscv64-unknown-elf-gcc hello.c \
    -o hello.x \ # set output file
    -static \ # build statically
    -O0 \ # disable optimizations
    -g # build with debug info

scp -p ${LICHEE_SSH_PORT} ${SC_GDB_PATH}/sysroot/usr/bin/riscv64-unknown-linux-gnu-gdbserver sipeed@${LICHEE_IPV4}:~/
scp -p ${LICHEE_SSH_PORT} hello.x sipeed@${LICHEE_IPV4}:~/
ssh -p ${LICHEE_SSH_PORT} sipeed@${LICHEE_IPV4} "~/riscv64-unknown-linux-gnu-gdbserver ${LICHEE_GDBSERVER_PORT} hello.x"
riscv64-unknown-linux-gnu-gdb hello.x
```

In GDB:

```
target extended-remote ${LICHEE_IPV4}:2345
load hello.x
start
```

Now you can try to debug buggy-sort:

```c
#include <stdio.h>

typedef struct {
  char *data;
  int key;
} item;

item array[] = {
    {"Bill", 62}, {"Hill", 60}, {"Barrak", 42}, {"Dicky", 105}, {"W.", 1},
};

/* Simple but buggy bubble sort  *
 * Can you find the bugs?        */
void sort(item *a, int n) {
  int i = 0, j = 0;
  int s = 1;

  for (; i < n && s != 0; i++) {
    s = 0;
    for (j = 0; j < n; j++)
      if (a[j].key > a[j + 1].key) {
        item t = a[j];
        a[j] = a[j + 1];
        a[j + 1] = t;
        s++;
      }
    n--;
  }
}

void print_arr(item *a, int n) {
  int i;

  for (i = 0; i != n; ++i)
    printf("%d: %s\n", a[i].key, a[i].data);
}

int main() {
  print_arr(array, 5);
  sort(array, 5);
  printf("\nAfter sort:\n");
  print_arr(array, 5);
  return 0;
}
```
