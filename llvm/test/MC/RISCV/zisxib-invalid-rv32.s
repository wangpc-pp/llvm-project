# RUN: not llvm-mc -triple riscv32 -mattr=+zisxib < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
sbib a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
shib a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
swib a0, (a1), 16
