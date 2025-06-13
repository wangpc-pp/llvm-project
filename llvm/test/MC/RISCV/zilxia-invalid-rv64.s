# RUN: not llvm-mc -triple riscv64 -mattr=+zilxia < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
lwuia a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
ldia a0, (a1), -17
