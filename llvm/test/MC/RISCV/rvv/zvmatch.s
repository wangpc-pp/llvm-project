# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+experimental-zvmatch %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-INST,CHECK-ENCODING
# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+experimental-zvmatch %s \
# RUN:   | FileCheck %s --check-prefixes=CHECK-INST,CHECK-ENCODING
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-zvmatch %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-zvmatch --no-print-imm-hex - \
# RUN:   | FileCheck %s --check-prefix=CHECK-INST

vmmatch.vv v10, v9, v8
# CHECK-INST: vmmatch.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xd2]
# CHECK-ERROR: instruction requires the following: 'Zvmatch' (Vector Match Against Key Set){{$}}

vmmatch.vv v10, v9, v8, v0.t
# CHECK-INST: vmmatch.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xd0]
# CHECK-ERROR: instruction requires the following: 'Zvmatch' (Vector Match Against Key Set){{$}}

vmmatch.vx v10, v9, a6
# CHECK-INST: vmmatch.vx v10, v9, a6
# CHECK-ENCODING: [0x57,0x45,0x98,0xd2]
# CHECK-ERROR: instruction requires the following: 'Zvmatch' (Vector Match Against Key Set){{$}}

vmmatch.vx v10, v9, a6, v0.t
# CHECK-INST: vmmatch.vx v10, v9, a6, v0.t
# CHECK-ENCODING: [0x57,0x45,0x98,0xd0]
# CHECK-ERROR: instruction requires the following: 'Zvmatch' (Vector Match Against Key Set){{$}}

# Mask destinations may overlap the query source at its lowest register.
vmmatch.vv v8, v8, v9
# CHECK-INST: vmmatch.vv v8, v8, v9
# CHECK-ENCODING: [0x57,0x84,0x84,0xd2]

vmmatch.vx v8, v8, zero
# CHECK-INST: vmmatch.vx v8, v8, zero
# CHECK-ENCODING: [0x57,0x44,0x80,0xd2]

# The masked form permits vd=v0 when neither source group contains v0.
vmmatch.vv v0, v8, v9, v0.t
# CHECK-INST: vmmatch.vv v0, v8, v9, v0.t
# CHECK-ENCODING: [0x57,0x80,0x84,0xd0]

vmmatch.vx v0, v8, zero, v0.t
# CHECK-INST: vmmatch.vx v0, v8, zero, v0.t
# CHECK-ENCODING: [0x57,0x40,0x80,0xd0]
