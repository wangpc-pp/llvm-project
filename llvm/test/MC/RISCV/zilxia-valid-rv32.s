# RUN: llvm-mc -triple=riscv32 -show-encoding --mattr=+zilxia %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv32 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilxia %s \
# RUN:        | llvm-objdump -d --mattr=+zilxia --no-print-imm-hex  - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv32 -filetype=obj --mattr=+zilxia %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lbia a0, (a1), 1
# CHECK-INST: lbia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x02]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 0215f503 <unknown>

lbuia a0, (a1), 1
# CHECK-INST: lbuia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x22]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 2215f503 <unknown>

lhia a0, (a1), 1
# CHECK-INST: lhia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x42]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 4215f503 <unknown>

lhuia a0, (a1), 1
# CHECK-INST: lhuia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x62]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 6215f503 <unknown>

lwia a0, (a1), 1
# CHECK-INST: lwia a0, (a1), 1
# CHECK-ENCODING: [0x03,0xf5,0x15,0x82]
# CHECK-ERROR: instruction requires the following: 'Zilxia' (Post-Increment Load for Integer){{$}}
# CHECK-UNKNOWN: 8215f503 <unknown>
