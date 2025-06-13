# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zilx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilx %s \
# RUN:        | llvm-objdump -d --mattr=+zilx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lxb a0, (a1), a2
# CHECK-INST: lxb a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x04]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 04c5f503 <unknown>

lxbu a0, (a1), a2
# CHECK-INST: lxbu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x24]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 24c5f503 <unknown>

lxh a0, (a1), a2
# CHECK-INST: lxh a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x44]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 44c5f503 <unknown>

lxhu a0, (a1), a2
# CHECK-INST: lxhu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x64]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 64c5f503 <unknown>

lxw a0, (a1), a2
# CHECK-INST: lxw a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x84]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 84c5f503 <unknown>

lxh.s a0, (a1), a2
# CHECK-INST: lxh.s a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x48]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 48c5f503 <unknown>

lxhu.s a0, (a1), a2
# CHECK-INST: lxhu.s a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x68]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 68c5f503 <unknown>

lxw.s a0, (a1), a2
# CHECK-INST: lxw.s a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x88]
# CHECK-ERROR: instruction requires the following: 'Zilx' (Index Load for Integer){{$}}
# CHECK-UNKNOWN: 88c5f503 <unknown>
