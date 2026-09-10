# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-zispi %s 2>&1 \
# RUN:   | FileCheck %s --check-prefixes=CHECK,CHECK-RV32
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-zispi %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK

# CHECK: :[[@LINE+1]]:11: error: expected '('
spi.b a0, a1

# CHECK: :[[@LINE+1]]:12: error: register must be a GPR excluding zero (x0)
spi.w a0, (zero)

# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
spi.d a0, (a1)
