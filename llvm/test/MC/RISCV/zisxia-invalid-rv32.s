# RUN: not llvm-mc -triple riscv32 -mattr=+zisxia < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
sbia a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
shia a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
swia a0, (a1), 16
