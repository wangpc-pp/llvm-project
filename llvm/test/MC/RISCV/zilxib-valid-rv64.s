# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zilxib %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilxib %s \
# RUN:        | llvm-objdump -d --mattr=+zilxib --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilxib %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lwuib a0, (a1), 1
# CHECK-INST: lwuib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0xa0]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: a015f503 <unknown>

ldib a0, (a1), 1
# CHECK-INST: ldib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0xc0]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: c015f503 <unknown>
