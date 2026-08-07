# RUN: not llvm-mc -triple=riscv64 --mattr=+experimental-zvmatch %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR

vmmatch.vv v8, v9, a0
# CHECK-ERROR: invalid operand for instruction
# CHECK-ERROR-LABEL: vmmatch.vv v8, v9, a0

vmmatch.vx v8, v9, v10
# CHECK-ERROR: register must be a GPR
# CHECK-ERROR-LABEL: vmmatch.vx v8, v9, v10

vmmatch.vv v8, v9, v8
# CHECK-ERROR: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vmmatch.vv v8, v9, v8

vmmatch.vv v8, v9, v0, v0.t
# CHECK-ERROR: the source vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vmmatch.vv v8, v9, v0, v0.t

vmmatch.vv v8, v0, v9, v0.t
# CHECK-ERROR: the source vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vmmatch.vv v8, v0, v9, v0.t

vmmatch.vx v8, v0, a0, v0.t
# CHECK-ERROR: the source vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vmmatch.vx v8, v0, a0, v0.t
