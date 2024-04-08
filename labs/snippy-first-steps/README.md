# Snippy First Steps

**Note**: if you don't have snippy, see [tutorial](../../tutorials/how-to-get-snippy.md).

**Note**: this lab involves snippy 1.0 usage.

## Config

To generate a snippet, you need to create configuration yaml file. It can
contain following parts:

- `sections`
- `histogram`
- `options`
- `access-ranges`
- `burst`
- `branches`
- `call-graph`
- `include`
- `imm-hist`
- `riscv-vector-unit`

`sections` and `histogram` are mandatory.

### Sections

Use `sections` to specify sections that must be generated in output binary.
You always need to specify at least one RX section for code and one RW section
for memory accesses. Example:

```yaml
sections:
  - name:      text
    VMA:       0x210000
    SIZE:      0x100000
    LMA:       0x210000
    ACCESS:    rx
  - name:      data
    VMA:       0x100000
    SIZE:      0x100000
    LMA:       0x100000
    ACCESS:    rw
```


### Histogram

Use `histogram` to specify opcodes distribution. Example:

```yaml
histogram:
  - [ADD, 1.0]
  - [ADDI, 1.0]
  - [LW, 3.0]
  - [SW, 3.0]
  - [BNE, 5.0]
```

It's list of pairs where first element is opcode name and second is relative
probability. You can always see full list of available opcodes for specified
architecture/attributes/cpu with `--list-opcode-names` option.

### Another Mandatory Options

To successfully generate snippet you need always specify two options:

- `--march=riscv64` -- you need to specify this because x86 is default
- `--model-plugin=None` -- snippy tries to find any model and fails

If you don't what to specify them all times you can place them in config. Just
add:

```yaml
options:
  march: riscv64
  model-plugin: None
```

### Seed

Seed allows to make reproducible generations. If seed is not specified snippy
selects random seed, so it worth to always explicity specify seed: just use
`--seed=<num>` option.

## Generating first snippet

Collect all examples into one config:

```yaml
options:
  march: riscv64
  model-plugin: None

sections:
  - name:      text
    VMA:       0x210000
    SIZE:      0x100000
    LMA:       0x210000
    ACCESS:    rx
  - name:      data
    VMA:       0x100000
    SIZE:      0x100000
    LMA:       0x100000
    ACCESS:    rw

histogram:
  - [ADD, 1.0]
  - [ADDI, 1.0]
  - [LW, 3.0]
  - [SW, 3.0]
  - [BNE, 5.0]
```

And now you can generate your first snippet:

```sh
llvm-snippy example.yaml --seed=0
```

Now check that snippet is generated as expected:

```sh
riscv64-unknown-linux-gnu-objdump -S example.yaml.elf > example.dis
```

## Snippet execution

### Snippet wrapper

Since we don't have any model for snippy, the only option is to wrap snippet and
run it on qemu or spike.

To wrap snippet, firstly, create a simple wrapper:

```c
void SnippyFunction();

int main() {
  SnippyFunction();
}
```

And now you can compile it with generated snippet:

```sh
riscv64-unknown-linux-gnu-gcc wrapper.c example.yaml.elf -static
```

And this will fail because of different ABI. Simplest way to fix it is add
`mattr: +d` in `options`.

After regenerating the snippet compilation will succeed:

```sh
llvm-snippy example.yaml --seed=0
riscv64-unknown-linux-gnu-gcc wrapper.c example.yaml.elf -static
```

### Run on qemu

Now try to run it on qemu:

```sh
> qemu-riscv64 a.out
Segmentation fault (core dumped)
```

This segmentation fault is caused by access to restricted memory regions. To fix
this, some improvements are required:

- Fix access addresses
- Add forgotten return
- Fix abi
- Make special build for selected platform

#### Memory accesses

On platform we selected addressspace starts from 0x400000000.

```yaml
sections:
  - name:      data
    VMA:       0x400100000
    SIZE:      0x000100000
    LMA:       0x400100000
    ACCESS:    rw
```

*Question*: why we moved only `data` section?

#### Forgotten return

By default last instruction in generated function is `ebreak`. To make `ret`
last instruction, you need to explicilty specify it: `--last-instr=ret` or
add to config

```yaml
options:
  last-instr: ret
```

#### ABI and calling convention

By default snippy doesn't use any calling conventions. This is problem because
generated snippet can corrupt `sp`, `gp` or `ra`. To fix this you need to pass
`--honor-target-abi` option or add to config

```yaml
options:
  honor-target-abi: on
```

In this case snippy will use stack for saving registers that must be saved on
the callee side. By default snippy will use require a special section called
`stack`. To enforce snippy use caller's stack pass `--external-stack` option
or add to config

```yaml
options:
  external-stack: on
```

#### Special build for a platform

We compile binary for linux and make accesses to unallocated memory. This causes
segmentation fault. We have 2 options: the first is to add allocation to `rw`
section in wrapper and the second is build for baremetal.

To build for baremetal use `build-baremetal.sh`:

```sh
./build-baremetal.sh wrapper.c example.yaml.elf
```
