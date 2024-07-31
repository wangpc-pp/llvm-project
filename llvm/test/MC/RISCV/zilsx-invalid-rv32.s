# RUN: not llvm-mc -triple=riscv32 --mattr=+zilsx %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

lxb a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxb a0, (a1), a2, -1

lxb a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxb a0, (a1), a2, 4

lxbu a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxbu a0, (a1), a2, -1

lxbu a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxbu a0, (a1), a2, 4

lxh a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxh a0, (a1), a2, -1

lxh a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxh a0, (a1), a2, 4

lxhu a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxhu a0, (a1), a2, -1

lxhu a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxhu a0, (a1), a2, 4

lxw a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxw a0, (a1), a2, -1

lxw a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxw a0, (a1), a2, 4

sxb a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxb a0, (a1), a2, -1

sxb a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxb a0, (a1), a2, 4

sxh a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxh a0, (a1), a2, -1

sxh a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxh a0, (a1), a2, 4

sxw a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxw a0, (a1), a2, -1

sxw a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxw a0, (a1), a2, 4
