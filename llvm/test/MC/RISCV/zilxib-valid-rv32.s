# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zilxib %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilxib %s \
# RUN:        | llvm-objdump -d --mattr=+zilxib --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilxib %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lbib a0, (a1), 1
# CHECK-INST: lbib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x00]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 0015f503 <unknown>

lbuib a0, (a1), 1
# CHECK-INST: lbuib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x20]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 2015f503 <unknown>

lhib a0, (a1), 1
# CHECK-INST: lhib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x40]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 4015f503 <unknown>

lhuib a0, (a1), 1
# CHECK-INST: lhuib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x60
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 6015f503 <unknown>

lwib a0, (a1), 1
# CHECK-INST: lwib a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x80]
# CHECK-ERROR: instruction requires the following: 'Zilxib' (Pre-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 8015f503 <unknown>
