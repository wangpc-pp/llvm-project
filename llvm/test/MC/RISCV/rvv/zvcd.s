# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-zvcd -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-zvcd -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:     | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zvcd < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zvcd -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zvcd < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zvcd -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# CHECK-ASM-AND-OBJ: vconflictcnt.v v1, v2
# CHECK-ASM: encoding: [0xd7,0x20,0x29,0x52]
# CHECK-ERROR: instruction requires the following: 'Zvcd' (Vector Conflict Detection){{$}}
vconflictcnt.v v1, v2

# CHECK-ASM-AND-OBJ: vconflictcnt.v v1, v2, v0.t
# CHECK-ASM: encoding: [0xd7,0x20,0x29,0x50]
# CHECK-ERROR: instruction requires the following: 'Zvcd' (Vector Conflict Detection){{$}}
vconflictcnt.v v1, v2, v0.t

# CHECK-ASM-AND-OBJ: vconflictlast.m v1, v2
# CHECK-ASM: encoding: [0xd7,0x20,0x22,0x52]
# CHECK-ERROR: instruction requires the following: 'Zvcd' (Vector Conflict Detection){{$}}
vconflictlast.m v1, v2

# CHECK-ASM-AND-OBJ: vconflictlast.m v1, v2, v0.t
# CHECK-ASM: encoding: [0xd7,0x20,0x22,0x50]
# CHECK-ERROR: instruction requires the following: 'Zvcd' (Vector Conflict Detection){{$}}
vconflictlast.m v1, v2, v0.t
