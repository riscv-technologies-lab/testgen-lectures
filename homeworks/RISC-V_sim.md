# RISC-V sim

## First level

Implement rv32i model without `ecall`, `ebreak` and `fence.i` instructions.

**Expected artifact**: library that implements functionality of rv32i functional
simulator that works as interpretator.

**Acceptance criteria**: all instructions from RISC-V specification (except
specified) are implemented. There are tests for correct evaluation for those
instructions (at least one test for a one instruction).

**Expected input**: initial model state.

**Expected output**: final model state.

### Pay attention

Model state includes

- State of all registers (`x0`-`x31`, `pc`)
- State of memory

Model shall implement interface that allows to

- Set up initial state of the model
- Execute one instruction
- Get current state of the model

### FAQ

1. **Where do I recieve an executable for simulation?** At this level executable should be placed in the memory and before start of simulation pc shall be set to the first instruction of this executable. It's responsibility of library user to prepare binary and correcly initialize model with it.
1. **What is the format of instructions in memory?** Instructions are placed in memory in encoded state. You can see encodings of all instructions in RISC-V specification for unprivileged part of ISA.
