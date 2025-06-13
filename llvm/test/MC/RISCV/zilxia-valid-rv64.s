# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zilxia %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilxia %s \
# RUN:        | llvm-objdump -d --mattr=+zilxia --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilxia %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lwuia a0, (a1), 1
# CHECK-INST: lwuia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0xa2]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: a215f503 <unknown>

ldia a0, (a1), 1
# CHECK-INST: ldia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0xc2]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: c215f503 <unknown>
