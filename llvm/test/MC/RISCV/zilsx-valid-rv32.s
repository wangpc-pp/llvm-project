# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zilsx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilsx %s \
# RUN:        | llvm-objdump -d --mattr=+zilsx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilsx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lxb a0, (a1), a2
# CHECK-INST: lxb a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 06c5f503 <unknown>

lxb a0, (a1), a2, 0
# CHECK-INST: lxb a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 06c5f503 <unknown>

lxbu a0, (a1), a2
# CHECK-INST: lxbu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x0e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 0ec5f503 <unknown>

lxbu a0, (a1), a2, 0
# CHECK-INST: lxbu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x0e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 0ec5f503 <unknown>

lxh a0, (a1), a2
# CHECK-INST: lxh a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x16]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 16c5f503 <unknown>

lxh a0, (a1), a2, 0
# CHECK-INST: lxh a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x16]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 16c5f503 <unknown>

lxhu a0, (a1), a2
# CHECK-INST: lxhu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 1ec5f503 <unknown>

lxhu a0, (a1), a2, 0
# CHECK-INST: lxhu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 1ec5f503 <unknown>

lxw a0, (a1), a2
# CHECK-INST: lxw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x26]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 26c5f503 <unknown>

lxw a0, (a1), a2, 0
# CHECK-INST: lxw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x26]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 26c5f503 <unknown>

sxb a0, (a1), a2
# CHECK-INST: sxb a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 06c5f523 <unknown>

sxb a0, (a1), a2, 0
# CHECK-INST: sxb a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 06c5f523 <unknown>

sxh a0, (a1), a2
# CHECK-INST: sxh a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x0e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 0ec5f523 <unknown>

sxh a0, (a1), a2, 0
# CHECK-INST: sxh a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x0e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 0ec5f523 <unknown>

sxw a0, (a1), a2
# CHECK-INST: sxw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x16]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 16c5f523 <unknown>

sxw a0, (a1), a2, 0
# CHECK-INST: sxw a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x16]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 16c5f523 <unknown>
