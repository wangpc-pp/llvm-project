# RUN: not llvm-mc -triple=riscv32 --mattr=+zfh,+f,+d,+zflsx %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: not llvm-mc -triple=riscv64 --mattr=+zfh,+f,+d,+zflsx %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

flxh fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxh fa0, (a1), a2, -1

flxh fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxh fa0, (a1), a2, 8

flxw fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxw fa0, (a1), a2, -1

flxw fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxw fa0, (a1), a2, 8

flxd fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxd fa0, (a1), a2, -1

flxd fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: flxd fa0, (a1), a2, 8

fsxh fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxh fa0, (a1), a2, -1

fsxh fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxh fa0, (a1), a2, 8

fsxw fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxw fa0, (a1), a2, -1

fsxw fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxw fa0, (a1), a2, 8

fsxd fa0, (a1), a2, -1
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxd fa0, (a1), a2, -1

fsxd fa0, (a1), a2, 8
# CHECK-ERROR: [[@LINE-1]]:21: error: immediate must be an integer in the range [0, 7]
# CHECK-ERROR-LABEL: fsxd fa0, (a1), a2, 8
