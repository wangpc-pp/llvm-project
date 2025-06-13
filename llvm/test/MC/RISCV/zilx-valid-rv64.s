# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zilx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilx %s \
# RUN:        | llvm-objdump -d --mattr=+zilx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lxwu a0, (a1), a2
# CHECK-INST: lxwu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xa4]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: a4c5f503 <unknown>

lxd a0, (a1), a2
# CHECK-INST: lxd a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xc4]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: c4c5f503 <unknown>

lxb.uw a0, (a1), a2
# CHECK-INST: lxb.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 06c5f503 <unknown>

lxbu.uw a0, (a1), a2
# CHECK-INST: lxbu.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x26]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 26c5f503 <unknown>

lxh.uw a0, (a1), a2
# CHECK-INST: lxh.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x46]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 46c5f503 <unknown>

lxhu.uw a0, (a1), a2
# CHECK-INST: lxhu.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x66] 
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 66c5f503 <unknown>

lxw.uw a0, (a1), a2
# CHECK-INST: lxw.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x86]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 86c5f503 <unknown>

lxwu.uw a0, (a1), a2
# CHECK-INST: lxwu.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xa6]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: a6c5f503 <unknown>

lxd.uw a0, (a1), a2
# CHECK-INST: lxd.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xc6]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: c6c5f503 <unknown>

lxwu.s a0, (a1), a2
# CHECK-INST: lxwu.s a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xa8]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: a8c5f503 <unknown>

lxd.s a0, (a1), a2
# CHECK-INST: lxd.s a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xc8]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: c8c5f503 <unknown>

lxh.s.uw a0, (a1), a2
# CHECK-INST: lxh.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x4a]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 4ac5f503 <unknown>

lxhu.s.uw a0, (a1), a2
# CHECK-INST: lxhu.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x6a]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 6ac5f503 <unknown>

lxw.s.uw a0, (a1), a2
# CHECK-INST: lxw.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x8a]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 8ac5f503 <unknown>

lxwu.s.uw a0, (a1), a2
# CHECK-INST: lxwu.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xaa]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: aac5f503 <unknown>

lxd.s.uw a0, (a1), a2
# CHECK-INST: lxd.s.uw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0xca]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: cac5f503 <unknown>
