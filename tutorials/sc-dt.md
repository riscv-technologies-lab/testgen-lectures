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

On host:

```sh
export IMAGE=ghcr.io/riscv-technologies-lab/rv_tools_image:1.0.1
export CONTAINER=rv_tools_experiments
export WORKDIR=$HOME/wd # or any other you want
mkdir -p ${WORKDIR}
cd ${WORKDIR}
docker run \
    --interactive \ # keep STDIN open even if not attached
    --tty \ # allocate a pseudo-TTY
    --detach \ # run command in the background
    --env "TERM=xterm-256color" \ # enable colors
    --mount type=bind,source="$(pwd)",target="$(pwd)" \ # mount source dir to target dir
    --name ${CONTAINER} \ # set container name
    --ulimit nofile=1024:1024 \ # workaround for valgring
    --user "$(id -u ${USER}):$(id -g ${USER})" \ # preserve user accesses and ownership
    --network=host \ # use the same network as host, generally bad practice
    --workdir "$WORKDIR" \ # working directory inside the container
    ${IMAGE} # image name for this container
# Setup ownership inside container
docker exec --user root $(CONTAINER_NAME) \
    bash -c "chown $$(id -u):$$(id -g) $$HOME"
# Create group associated with your user
docker exec --user root ${CONTAINER} \
    bash -c "groupadd ${USER} -g $(id -g ${USER})"
# Create user with same uid and gid as host user
docker exec --user root ${CONTAINER} \
    bash -c "useradd ${USER} -u $(id -u ${USER}) -g $(id -g ${USER})"
docker exec -it ${CONTAINER} bash
```

Inside container

```sh
source /opt/sc-dt/env.sh
env # check that environment updated
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

### GDB

```sh
riscv64-unknown-elf-gcc hello.c \
    -o hello.x \ # set output file
    -static \ # build statically
    -O0 \ # disable optimizations
    -g # build with debug info

scp ${SC_GDB_PATH}/sysroot/usr/bin/riscv64-unknown-linux-gnu-gdbserver sipeed@${LICHEE_IPV4}:~/
scp hello.x sipeed@${LICHEE_IPV4}:~/
ssh sipeed@${LICHEE_IPV4} "~/riscv64-unknown-linux-gnu-gdbserver :2345 hello.x"
riscv64-unknown-linux-gnu-gdb hello.x
```

In GDB:

```
target extended-remote ${LICHEE_IPV4}:2345
load hello.x
start
```
