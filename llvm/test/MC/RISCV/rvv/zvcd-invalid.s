# RUN: not llvm-mc -triple=riscv64 --mattr=+experimental-zvcd %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

vconflictcnt.v v2, v2
# CHECK-ERROR: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vconflictcnt.v v2, v2

vconflictcnt.v v0, v2, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vconflictcnt.v v0, v2, v0.t

vconflictlast.m v2, v2
# CHECK-ERROR: the destination vector register group cannot overlap the source vector register group
# CHECK-ERROR-LABEL: vconflictlast.m v2, v2

vconflictlast.m v0, v2, v0.t
# CHECK-ERROR: the destination vector register group cannot overlap the mask register
# CHECK-ERROR-LABEL: vconflictlast.m v0, v2, v0.t
