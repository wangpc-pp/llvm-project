# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zisxia %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisxia %s \
# RUN:        | llvm-objdump -d --mattr=+zisxia --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisxia %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sdia a0, (a1), 1
# CHECK-INST: sdia a0, (a1), 1
# CHECK-ENCODING: [0xa3,0xf0,0xa5,0xc2]
# CHECK-ERROR: instruction requires the following: 'Zisxia' (Post-Increment Store for Integer){{$}}
# CHECK-UNKNOWN: c2a5f0a3 <unknown>
