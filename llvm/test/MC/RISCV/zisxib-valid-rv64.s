# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zisxib %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisxib %s \
# RUN:        | llvm-objdump -d --mattr=+zisxib --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisxib %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sdib a0, (a1), 1
# CHECK-INST: sdib a0, (a1), 1
# CHECK-ENCODING: [0xa3,0xf0,0xa5,0xc0]
# CHECK-ERROR: instruction requires the following: 'Zisxib' (Pre-Increment Store for Integer){{$}}
# CHECK-UNKNOWN: c0a5f0a3 <unknown>
