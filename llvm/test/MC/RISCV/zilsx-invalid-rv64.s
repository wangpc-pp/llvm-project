# RUN: not llvm-mc -triple=riscv64 --mattr=+zilsx %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

lxwu a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxwu a0, (a1), a2, -1

lxwu a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxwu a0, (a1), a2, 4

lxd a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxd a0, (a1), a2, -1

lxd a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: lxd a0, (a1), a2, 4

sxd a0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxd a0, (a1), a2, -1

sxd a0, (a1), a2, 4
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [0, 3]
# CHECK-ERROR-LABEL: sxd a0, (a1), a2, 4
