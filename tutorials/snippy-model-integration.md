# Snippy Model Integration

Snippy can use external models to collect trace for generated snippet. Model is
a shared library with a special interface. To povide a new model for snippy you
need to perform following steps:

1. [Copy interface headers from snippy repo](#copy-interface-headers-from-snippy-repo)
1. [Create `VTable.cpp` in your project](#create-vtable-cpp-in-your-project)
1. [Implement interface functions in your project](#implement-interface-functions-in-your-project)
1. [Build Model as Shared Library](#build-model-as-shared-library)

## Copy Interface Headers From Snippy Repo

1. Go to [snippy repo](https://github.com/syntacore/snippy).
1. Find interface headers in `snippy/llvm/tools/llvm-snippy/Model/RISCVModel`.
1. Copy `RVM.h` and `VTable.h` headers in your project.

## Create `VTable.cpp` in Your Project

```cpp
#include "SnippyRVdash/VTable.h"

unsigned char RVMAPI_VERSION_SYMBOL = RVMAPI_CURRENT_INTERFACE_VERSION;

extern const rvm::RVM_FunctionPointers RVMAPI_ENTRY_POINT_SYMBOL = {
    .modelCreate = &rvm_modelCreate,
    .modelDestroy = &rvm_modelDestroy,

    .getModelConfig = &rvm_getModelConfig,

    .executeInstr = &rvm_executeInstr,

    .readMem = &rvm_readMem,
    .writeMem = &rvm_writeMem,

    .readPC = &rvm_readPC,
    .setPC = &rvm_setPC,

    .readXReg = &rvm_readXReg,
    .setXReg = &rvm_setXReg,

    .readFReg = &rvm_readFReg,
    .setFReg = &rvm_setFReg,

    .readCSRReg = &rvm_readCSRReg,
    .setCSRReg = &rvm_setCSRReg,

    .readVReg = &rvm_readVReg,
    .setVReg = &rvm_setVReg,

    .logMessage = &rvm_logMessage,
    .queryCallbackSupportPresent = &rvm_queryCallbackSupportPresent,
};
```

## Implement Interface Functions in Your Project

Implement interface function from `RVM.h`:

- `rvm_modelCreate`
- `rvm_modelDestroy`
- `rvm_getModelConfig`
- `rvm_executeInstr`
- `rvm_readMem`
- `rvm_writeMem`
- `rvm_readPC`
- `rvm_setPC`
- `rvm_readXReg`
- `rvm_setXReg`
- `rvm_readFReg`
- `rvm_setFReg`
- `rvm_readCSRReg`
- `rvm_setCSRReg`
- `rvm_readVReg`
- `rvm_setVReg`
- `rvm_logMessage`
- `rvm_queryCallbackSupportPresent`

## Build Model as Shared Library

Build your model with interface for snippy as a shared library. After that you
can run snippy with model: just specify `--model-plugin=libRISCVModel.so` option
where `libRISCVModel.so` is path to your model.
