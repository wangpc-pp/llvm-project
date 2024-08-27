# RUN: not llvm-mc -triple=riscv64 --mattr=+zve64x --mattr=+zvmedia %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

vabd.vi  v10, v9, 16
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [-16, 15]
# CHECK-ERROR-LABEL: vabd.vi  v10, v9, 16

vabd.vi  v10, v9, -17
# CHECK-ERROR: [[@LINE-1]]:19: error: immediate must be an integer in the range [-16, 15]
# CHECK-ERROR-LABEL: vabd.vi  v10, v9, -17

vabdu.vi  v10, v9, -1
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 31]
# CHECK-ERROR-LABEL: vabdu.vi  v10, v9, -1

vabdu.vi  v10, v9, 32
# CHECK-ERROR: [[@LINE-1]]:20: error: immediate must be an integer in the range [0, 31]
# CHECK-ERROR-LABEL: vabdu.vi  v10, v9, 32

vwabd.vv v9, v9, v8
# CHECK-ERROR: [[@LINE-1]]:10: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabd.vv v9, v9, v8

vwabd.vx v9, v9, a0
# CHECK-ERROR: [[@LINE-1]]:10: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabd.vx v9, v9, a0

vwabdu.vv v9, v9, v8
# CHECK-ERROR: [[@LINE-1]]:11: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabdu.vv v9, v9, v8

vwabdu.vx v9, v9, a0
# CHECK-ERROR: [[@LINE-1]]:11: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabdu.vx v9, v9, a0

vwabda.vv v9, v9, v8
# CHECK-ERROR: [[@LINE-1]]:11: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabda.vv v9, v9, v8

vwabda.vx v9, v9, a0
# CHECK-ERROR: [[@LINE-1]]:11: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabda.vx v9, v9, a0

vwabdau.vv v9, v9, v8
# CHECK-ERROR: [[@LINE-1]]:12: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabdau.vv v9, v9, v8

vwabdau.vx v9, v9, a0
# CHECK-ERROR: [[@LINE-1]]:12: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vwabdau.vx v9, v9, a0

vtrn.vv v8, v9, v8
# CHECK-ERROR: [[@LINE-1]]:9: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vtrn.vv v8, v9, v8

vtrn.vv v9, v9, v8
# CHECK-ERROR: [[@LINE-1]]:9: error: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vtrn.vv v9, v9, v8
