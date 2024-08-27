# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+v --mattr=+zvmedia %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+v --mattr=+zvmedia %s \
# RUN:        | llvm-objdump -d --mattr=+v --mattr=+zvmedia --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+v --mattr=+zvmedia %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vabd.vv v10, v9, v8
# CHECK-INST: vabd.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xda]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: da940557 <unknown>

vabd.vv v10, v9, v8, v0.t
# CHECK-INST: vabd.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xd8]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: d8940557 <unknown>

vabd.vx v10, v9, a0
# CHECK-INST: vabd.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x45,0x95,0xda]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: da954557 <unknown>

vabd.vx v10, v9, a0, v0.t
# CHECK-INST: vabd.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x45,0x95,0xd8]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: d8954557 <unknown>

vabd.vi  v10, v9, 1
# CHECK-INST: vabd.vi  v10, v9, 1
# CHECK-ENCODING: [0x57,0xb5,0x90,0xda]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: da90b557 <unknown>

vabd.vi  v10, v9, 1, v0.t
# CHECK-INST: vabd.vi  v10, v9, 1, v0.t
# CHECK-ENCODING: [0x57,0xb5,0x90,0xd8]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: d890b557 <unknown>

vabdu.vv v10, v9, v8
# CHECK-INST: vabdu.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xde]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: de940557 <unknown>

vabdu.vv v10, v9, v8, v0.t
# CHECK-INST: vabdu.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xdc]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: dc940557 <unknown>

vabdu.vx v10, v9, a0
# CHECK-INST: vabdu.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x45,0x95,0xde]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: de954557 <unknown>

vabdu.vx v10, v9, a0, v0.t
# CHECK-INST: vabdu.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x45,0x95,0xdc]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: dc954557 <unknown>

vabdu.vi  v10, v9, 1
# CHECK-INST: vabdu.vi  v10, v9, 1
# CHECK-ENCODING: [0x57,0xb5,0x90,0xde]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: de90b557 <unknown>

vabdu.vi  v10, v9, 1, v0.t
# CHECK-INST: vabdu.vi  v10, v9, 1, v0.t
# CHECK-ENCODING: [0x57,0xb5,0x90,0xdc]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: dc90b557 <unknown>

vabda.vv v10, v9, v8
# CHECK-INST: vabda.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xe2]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e2940557 <unknown>

vabda.vv v10, v9, v8, v0.t
# CHECK-INST: vabda.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xe0]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e0940557 <unknown>

vabda.vx v10, v9, a0
# CHECK-INST: vabda.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x45,0x95,0xe2]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e2954557 <unknown>

vabda.vx v10, v9, a0, v0.t
# CHECK-INST: vabda.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x45,0x95,0xe0]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e0954557 <unknown>

vabdau.vv v10, v9, v8
# CHECK-INST: vabdau.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xe6]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e6940557 <unknown>

vabdau.vv v10, v9, v8, v0.t
# CHECK-INST: vabdau.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x05,0x94,0xe4]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e4940557 <unknown>

vabdau.vx v10, v9, a0
# CHECK-INST: vabdau.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x45,0x95,0xe6]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e6954557 <unknown>

vabdau.vx v10, v9, a0, v0.t
# CHECK-INST: vabdau.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x45,0x95,0xe4]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: e4954557 <unknown>

vwabd.vv v10, v9, v8
# CHECK-INST: vwabd.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x25,0x94,0x46]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 46942557 <unknown>

vwabd.vv v10, v9, v8, v0.t
# CHECK-INST: vwabd.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x25,0x94,0x44]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 44942557 <unknown>

vwabd.vx v10, v9, a0
# CHECK-INST: vwabd.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x65,0x95,0x46]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 46956557 <unknown>

vwabd.vx v10, v9, a0, v0.t
# CHECK-INST: vwabd.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x65,0x95,0x44]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 44956557 <unknown>

vwabdu.vv v10, v9, v8
# CHECK-INST: vwabdu.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x25,0x94,0x4e]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 4e942557 <unknown>

vwabdu.vv v10, v9, v8, v0.t
# CHECK-INST: vwabdu.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x25,0x94,0x4c]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 4c942557 <unknown>

vwabdu.vx v10, v9, a0
# CHECK-INST: vwabdu.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x65,0x95,0x4e]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 4e956557 <unknown>

vwabdu.vx v10, v9, a0, v0.t
# CHECK-INST: vwabdu.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x65,0x95,0x4c]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 4c956557 <unknown>

vwabda.vv v10, v9, v8
# CHECK-INST: vwabda.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x25,0x94,0x56]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 56942557 <unknown>

vwabda.vv v10, v9, v8, v0.t
# CHECK-INST: vwabda.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x25,0x94,0x54]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 54942557 <unknown>

vwabda.vx v10, v9, a0
# CHECK-INST: vwabda.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x65,0x95,0x56]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 56956557 <unknown>

vwabda.vx v10, v9, a0, v0.t
# CHECK-INST: vwabda.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x65,0x95,0x54]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 54956557 <unknown>

vwabdau.vv v10, v9, v8
# CHECK-INST: vwabdau.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x25,0x94,0x5a]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 5a942557 <unknown>

vwabdau.vv v10, v9, v8, v0.t
# CHECK-INST: vwabdau.vv v10, v9, v8, v0.t
# CHECK-ENCODING: [0x57,0x25,0x94,0x58]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 58942557 <unknown>

vwabdau.vx v10, v9, a0
# CHECK-INST: vwabdau.vx v10, v9, a0
# CHECK-ENCODING: [0x57,0x65,0x95,0x5a]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 5a956557 <unknown>

vwabdau.vx v10, v9, a0, v0.t
# CHECK-INST: vwabdau.vx v10, v9, a0, v0.t
# CHECK-ENCODING: [0x57,0x65,0x95,0x58]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: 58956557 <unknown>

vtrn.vv v10, v9, v8
# CHECK-INST: vtrn.vv v10, v9, v8
# CHECK-ENCODING: [0x57,0x05,0x94,0xea]
# CHECK-ERROR: instruction requires the following: 'Zvmedia' (RVV extensions for media scenarios like video/audio){{$}}
# CHECK-UNKNOWN: ea940557 <unknown>
