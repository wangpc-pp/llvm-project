# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zfh,+f,+d,+zflsx %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zfh,+f,+d,+zflsx %s \
# RUN:        | llvm-objdump -d --mattr=+zfh,+f,+d,+zflsx --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zfh,+f,+d,+zflsx %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

flxh fa0, (a1), a2
# CHECK-INST: flxh fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x10]
# CHECK-ERROR: instruction requires the following: 'Zfh' (Half-Precision Floating-Point) or 'Zfhmin' (Half-Precision Floating-Point Minimal), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 10c5e507 <unknown>

flxh fa0, (a1), a2, 0
# CHECK-INST: flxh fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x10]
# CHECK-ERROR: instruction requires the following: 'Zfh' (Half-Precision Floating-Point) or 'Zfhmin' (Half-Precision Floating-Point Minimal), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 10c5e507 <unknown>

flxw fa0, (a1), a2
# CHECK-INST: flxw fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x14]
# CHECK-ERROR: instruction requires the following: 'F' (Single-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 14c5e507 <unknown>

flxw fa0, (a1), a2, 0
# CHECK-INST: flxw fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x14]
# CHECK-ERROR: instruction requires the following: 'F' (Single-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 14c5e507 <unknown>

flxd fa0, (a1), a2
# CHECK-INST: flxd fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x18]
# CHECK-ERROR: instruction requires the following: 'D' (Double-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 18c5e507 <unknown>

flxd fa0, (a1), a2, 0
# CHECK-INST: flxd fa0, (a1), a2
# CHECK-ENCODING: [0x07,0xe5,0xc5,0x18]
# CHECK-ERROR: instruction requires the following: 'D' (Double-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 18c5e507 <unknown>

fsxh fa0, (a1), a2
# CHECK-INST: fsxh fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x10]
# CHECK-ERROR: instruction requires the following: 'Zfh' (Half-Precision Floating-Point) or 'Zfhmin' (Half-Precision Floating-Point Minimal), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 10c5e527 <unknown>

fsxh fa0, (a1), a2, 0
# CHECK-INST: fsxh fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x10]
# CHECK-ERROR: instruction requires the following: 'Zfh' (Half-Precision Floating-Point) or 'Zfhmin' (Half-Precision Floating-Point Minimal), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 10c5e527 <unknown>

fsxw fa0, (a1), a2
# CHECK-INST: fsxw fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x14]
# CHECK-ERROR: instruction requires the following: 'F' (Single-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 14c5e527 <unknown>

fsxw fa0, (a1), a2, 0
# CHECK-INST: fsxw fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x14]
# CHECK-ERROR: instruction requires the following: 'F' (Single-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 14c5e527 <unknown>

fsxd fa0, (a1), a2
# CHECK-INST: fsxd fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x18]
# CHECK-ERROR: instruction requires the following: 'D' (Double-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 18c5e527 <unknown>

fsxd fa0, (a1), a2, 0
# CHECK-INST: fsxd fa0, (a1), a2
# CHECK-ENCODING: [0x27,0xe5,0xc5,0x18]
# CHECK-ERROR: instruction requires the following: 'D' (Double-Precision Floating-Point), 'Zflsx' (Index Load/Store for Floating-Point){{$}}
# CHECK-UNKNOWN: 18c5e527 <unknown>
