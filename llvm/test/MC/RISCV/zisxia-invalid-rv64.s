# RUN: not llvm-mc -triple riscv64 -mattr=+zisxia < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
sdia a0, (a1), -17
