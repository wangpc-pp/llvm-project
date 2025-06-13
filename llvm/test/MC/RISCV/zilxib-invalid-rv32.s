# RUN: not llvm-mc -triple riscv32 -mattr=+zilxib < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
lbib a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
lbuib a0, (a1), -17

# CHECK: error: immediate must be an integer in the range [-16, 15]
lhib a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
lhuib a0, (a1), -17

# CHECK: error: immediate must be an integer in the range [-16, 15]
lwib a0, (a1), 16
