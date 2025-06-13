# RUN: not llvm-mc -triple riscv32 -mattr=+zilxia < %s 2>&1 | FileCheck %s

# CHECK: error: immediate must be an integer in the range [-16, 15]
lbia a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
lbuia a0, (a1), -17

# CHECK: error: immediate must be an integer in the range [-16, 15]
lhia a0, (a1), 16

# CHECK: error: immediate must be an integer in the range [-16, 15]
lhuia a0, (a1), -17

# CHECK: error: immediate must be an integer in the range [-16, 15]
lwia a0, (a1), 16
