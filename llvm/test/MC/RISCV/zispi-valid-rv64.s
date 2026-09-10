# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+experimental-zispi %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-ASM,CHECK-ENCODING
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-zispi %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-zispi --no-print-imm-hex - \
# RUN:   | FileCheck %s --check-prefix=CHECK-ASM

spi.d a0, (a1)
# CHECK-ASM: spi.d a0, (a1)
# CHECK-ENCODING: encoding: [0xaf,0xb5,0xa5,0xb0]
