# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+experimental-zvbext %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-INST,CHECK-ENCODING
# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+experimental-zvbext %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-INST,CHECK-ENCODING
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-zvbext %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-zvbext --no-print-imm-hex - \
# RUN:   | FileCheck %s --check-prefix=CHECK-INST

vbcompress.vv v10, v9, v8
# CHECK-INST: vbcompress.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xca]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbcompress.vv v10, v9, v8, v0.t
# CHECK-INST: vbcompress.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xc8]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbcompress.vx v10, v9, a6
# CHECK-INST: vbcompress.vx v10, v9, a6
# CHECK-ENCODING: [0x57,0x45,0x98,0xca]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbcompress.vx v10, v9, a6, v0.t
# CHECK-INST: vbcompress.vx v10, v9, a6, v0.t
# CHECK-ENCODING: [0x57,0x45,0x98,0xc8]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbexpand.vv v10, v9, v8
# CHECK-INST: vbexpand.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xce]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbexpand.vv v10, v9, v8, v0.t
# CHECK-INST: vbexpand.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xcc]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbexpand.vx v10, v9, a6
# CHECK-INST: vbexpand.vx v10, v9, a6
# CHECK-ENCODING: [0x57,0x45,0x98,0xce]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

vbexpand.vx v10, v9, a6, v0.t
# CHECK-INST: vbexpand.vx v10, v9, a6, v0.t
# CHECK-ENCODING: [0x57,0x45,0x98,0xcc]
# CHECK-ERROR: instruction requires the following: 'Zvbext' (Vector Bit Compress and Expand){{$}}

# Same-width source and destination groups may overlap.
vbcompress.vv v8, v8, v8
# CHECK-INST: vbcompress.vv v8, v8, v8
# CHECK-ENCODING: [0x57,0x04,0x84,0xca]

vbexpand.vv v8, v8, v8
# CHECK-INST: vbexpand.vv v8, v8, v8
# CHECK-ENCODING: [0x57,0x04,0x84,0xce]
