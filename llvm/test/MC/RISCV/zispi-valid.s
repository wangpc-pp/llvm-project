# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+experimental-zispi %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-ASM,CHECK-RV32
# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+experimental-zispi %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-ASM,CHECK-RV64
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-zispi %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-zispi --no-print-imm-hex - \
# RUN:   | FileCheck %s --check-prefix=CHECK-ASM
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-NO-FEATURE

spi.b a0, (a1)
# CHECK-ASM: spi.b a0, (a1)
# CHECK-RV32: encoding: [0xaf,0x85,0xa5,0xb0]
# CHECK-RV64: encoding: [0xaf,0x85,0xa5,0xb0]
# CHECK-NO-FEATURE: instruction requires the following: 'Zispi' (Unit-Stride Post-Increment Integer Stores)

spi.h a0, (a1)
# CHECK-ASM: spi.h a0, (a1)
# CHECK-RV32: encoding: [0xaf,0x95,0xa5,0xb0]
# CHECK-RV64: encoding: [0xaf,0x95,0xa5,0xb0]
# CHECK-NO-FEATURE: instruction requires the following: 'Zispi' (Unit-Stride Post-Increment Integer Stores)

spi.w a0, (a1)
# CHECK-ASM: spi.w a0, (a1)
# CHECK-RV32: encoding: [0xaf,0xa5,0xa5,0xb0]
# CHECK-RV64: encoding: [0xaf,0xa5,0xa5,0xb0]
# CHECK-NO-FEATURE: instruction requires the following: 'Zispi' (Unit-Stride Post-Increment Integer Stores)
