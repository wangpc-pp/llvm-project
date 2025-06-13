# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zisx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zisx %s \
# RUN:        | llvm-objdump -d --mattr=+zisx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zisx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sxb a0, (a1), a2
# CHECK-INST: sxb a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x04]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 04a5f623 <unknown>

sxh a0, (a1), a2
# CHECK-INST: sxh a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x44]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 44a5f623 <unknown>

sxw a0, (a1), a2
# CHECK-INST: sxw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x84]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 84a5f623 <unknown>

sxh.s a0, (a1), a2
# CHECK-INST: sxh.s a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x48]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 48a5f623 <unknown>

sxw.s a0, (a1), a2
# CHECK-INST: sxw.s a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x88]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 88a5f623 <unknown>
