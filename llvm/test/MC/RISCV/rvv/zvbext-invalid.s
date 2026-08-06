# RUN: not llvm-mc -triple=riscv64 --mattr=+experimental-zvbext %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

vbcompress.vv v0, v2, v4, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vbcompress.vv v0, v2, v4, v0.t

vbcompress.vx v0, v2, a0, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vbcompress.vx v0, v2, a0, v0.t

vbexpand.vv v0, v2, v4, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vbexpand.vv v0, v2, v4, v0.t

vbexpand.vx v0, v2, a0, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vbexpand.vx v0, v2, a0, v0.t

vbcompress.vv v10, v9, a0
# CHECK-ERROR: invalid operand for instruction
# CHECK-ERROR-LABEL: vbcompress.vv v10, v9, a0

vbcompress.vx v10, v9, v8
# CHECK-ERROR: register must be a GPR
# CHECK-ERROR-LABEL: vbcompress.vx v10, v9, v8

vbexpand.vv v10, v9, a0
# CHECK-ERROR: invalid operand for instruction
# CHECK-ERROR-LABEL: vbexpand.vv v10, v9, a0

vbexpand.vx v10, v9, v8
# CHECK-ERROR: register must be a GPR
# CHECK-ERROR-LABEL: vbexpand.vx v10, v9, v8
