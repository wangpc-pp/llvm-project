# RUN: not llvm-mc -triple riscv64 -mattr=+zisxib < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
sdib a0, (a1), -17
