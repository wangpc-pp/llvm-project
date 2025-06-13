# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zisxia %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zisxia %s \
# RUN:        | llvm-objdump -d --mattr=+zisxia --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zisxia %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sbia a0, (a1), 1
# CHECK-INST: sbia a0, (a1), 1
# CHECK-ENCODING: [0xa3,0xf0,0xa5,0x02]
# CHECK-ERROR: instruction requires the following: 'Zisxia' (Post-Increment Store for Integer){{$}}
# CHECK-UNKNOWN: 02a5f0a3 <unknown>

shia a0, (a1), 1
# CHECK-INST: shia a0, (a1), 1
# CHECK-ENCODING: [0xa3,0xf0,0xa5,0x42]
# CHECK-ERROR: instruction requires the following: 'Zisxia' (Post-Increment Store for Integer){{$}}
# CHECK-UNKNOWN: 42a5f0a3 <unknown>

swia a0, (a1), 1
# CHECK-INST: swia a0, (a1), 1
# CHECK-ENCODING: [0xa3,0xf0,0xa5,0x82]
# CHECK-ERROR: instruction requires the following: 'Zisxia' (Post-Increment Store for Integer){{$}}
# CHECK-UNKNOWN: 82a5f0a3 <unknown>
