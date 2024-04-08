#!/usr/bin/env bash

set -o errexit

if [ -z "$1" ]; then
  echo "$0: error: wrapper must be provided as the first positional argument"
  exit 1
fi

if [ -z "$2" ]; then
  echo "$0: error: snippet must be provided as the second positional argument"
  exit 1
fi

# Setup GCC and Clang toolchains:
export SC_DT_PATH=/opt/sc-dt

# Setup paths to GCC and Clang toolchains:
export SC_GCC_PATH=${SC_DT_PATH}/riscv-gcc/
export SC_CLANG_PATH=${SC_DT_PATH}/llvm/

# Setup path to qemu
export SC_QEMU_PATH=${SC_DT_PATH}/tools/bin

# Setup paths to bsp and cmake-toolchains
export BSP_PATH=${SC_DT_PATH}/workspace/bsp
export CMAKE_TOOLCHAINS=${SC_DT_PATH}/workspace/cmake-toolchains

# Configure
cmake -S ${BSP_PATH} -B build-clang-scr7 \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAINS}/riscv64-elf-clang.cmake \
    -DPLATFORM=scr7_l3

# Build
cmake --build build-clang-scr7 --target bsp

# Install
cmake --install build-clang-scr7 --prefix bsp-install

# Some magic
echo "\nINCLUDE $(realpath ${2%.elf}.ld)\n" >> bsp-install/platform/common/bsp0.lds

SAMPLE_APPS=${SC_DT_PATH}/workspace/sample_apps
rm -rf sample_apps
cp -r ${SAMPLE_APPS} .
SNIPPY_WRAPPER_DIR=sample_apps/software/snippy_wrapper
rm -rf ${SNIPPY_WRAPPER_DIR}
mkdir ${SNIPPY_WRAPPER_DIR}
cp "$1" ${SNIPPY_WRAPPER_DIR}
cat > ${SNIPPY_WRAPPER_DIR}/CMakeLists.txt <<EOF
project(snippy_wrapper)
add_executable(snippy_wrapper $1)
target_link_libraries(snippy_wrapper $(realpath $2))
EOF
sed -i -e 's/\(\w\)$/\1 snippy_wrapper/' sample_apps/sample_apps.ini

# Configure sample apps
cmake -S sample_apps -B build-wrapper \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAINS}/riscv64-elf-clang.cmake \
    -DPLATFORM=scr7_l3

# Build and run wrapper
cmake --build build-wrapper --target snippy_wrapper
cmake --build build-wrapper --target qemu-snippy_wrapper


