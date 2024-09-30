# Simulators benchmarking

## Prerequisites

Log into docker container:

```sh
docker run -it --mount type=bind,source="$(pwd)",target="$(pwd)" \
    --env "USER_ID=$(id --user)" \
    --env "USER_NAME=$(id --user --name)" \
    --name rv_sim_bench --workdir "$(pwd)" \
    --network=host \
    ghcr.io/riscv-technologies-lab/rv_tools_image:1.0.10
```

If you already did **this** `docker run`, you can just start the container:

```sh
docker start -ia rv_sim_bench
```

## QEMU

```sh
time qemu-riscv64 /opt/coremark/coremark.exe
```

## Spike

```sh
time spike pk /opt/coremark/coremark.exe
```

## GEM5

```sh
time gem5 /opt/gem5/configs/riscv-coremark.py
```

## LicheePi

Copy coremark to the board:

```sh
scp /opt/coremark/coremark.exe "sipeed@${LICHEE_IPV4}:~/"
```

Run the benchmark:

```sh
ssh "sipeed@${LICHEE_IPV4}" "time ~/coremark.exe"
```

Cleanup after yourself:

```sh
ssh "sipeed@${LICHEE_IPV4}" "rm ~/coremark.exe"
```
