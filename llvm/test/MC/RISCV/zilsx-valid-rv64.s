# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+zilsx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilsx %s \
# RUN:        | llvm-objdump -d --mattr=+zilsx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+zilsx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lxwu a0, (a1), a2
# CHECK-INST: lxwu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x2e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 2ec5f503 <unknown>

lxwu a0, (a1), a2, 0
# CHECK-INST: lxwu a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x2e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 2ec5f503 <unknown>

lxd a0, (a1), a2
# CHECK-INST: lxd a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x36]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 36c5f503 <unknown>

lxd a0, (a1), a2, 0
# CHECK-INST: lxd a0, (a1), a2
# CHECK-ENCODING: [0x03,0xf5,0xc5,0x36]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 36c5f503 <unknown>

sxd a0, (a1), a2
# CHECK-INST: sxd a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 1ec5f523 <unknown>

sxd a0, (a1), a2, 0
# CHECK-INST: sxd a0, (a1), a2
# CHECK-ENCODING: [0x23,0xf5,0xc5,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zilsx' (Index Load/Store for Integer){{$}}
# CHECK-UNKNOWN: 1ec5f523 <unknown>
