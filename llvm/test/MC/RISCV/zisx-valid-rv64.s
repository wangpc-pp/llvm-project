# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zisx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisx %s \
# RUN:        | llvm-objdump -d --mattr=+zisx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zisx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

sxd a0, (a1), a2
# CHECK-INST: sxd a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0xc4]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: c4a5f623 <unknown>

sxb.uw a0, (a1), a2
# CHECK-INST: sxb.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 06a5f623 <unknown>

sxh.uw a0, (a1), a2
# CHECK-INST: sxh.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x46]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 46a5f623 <unknown>

sxw.uw a0, (a1), a2
# CHECK-INST: sxw.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x86]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 86a5f623 <unknown>

sxd.uw a0, (a1), a2
# CHECK-INST: sxd.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0xc6]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: c6a5f623 <unknown>

sxd.s a0, (a1), a2
# CHECK-INST: sxd.s a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0xc8]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: c8a5f623 <unknown>

sxh.s.uw a0, (a1), a2
# CHECK-INST: sxh.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x4a]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 4aa5f623 <unknown>

sxw.s.uw a0, (a1), a2
# CHECK-INST: sxw.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0x8a]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: 8aa5f623 <unknown>

sxd.s.uw a0, (a1), a2
# CHECK-INST: sxd.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf6,0xa5,0xca]
# CHECK-ERROR: instruction requires the following: 'Zisx' (Index Store for Integer){{$}}
# CHECK-UNKNOWN: caa5f623 <unknown>
