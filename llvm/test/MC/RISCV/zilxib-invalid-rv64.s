# RUN: not llvm-mc -triple riscv64 -mattr=+zilxib < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
lwuib a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
ldib a0, (a1), -17
