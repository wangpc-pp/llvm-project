# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zibs -show-encoding %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs -show-encoding %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: not llvm-mc -triple=riscv32 %s 2>&1 | FileCheck %s --check-prefix=ERR
# RUN: not llvm-mc -triple=riscv64 %s 2>&1 | FileCheck %s --check-prefix=ERR
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zibs -filetype=obj %s | llvm-objdump -d --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s --check-prefix=OBJ
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs -filetype=obj %s | llvm-objdump -d --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s --check-prefix=OBJ
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zibs -filetype=obj %s | llvm-objdump -d --mattr=-experimental-zibs - | FileCheck %s --check-prefix=UNKNOWN

bbclri zero, 0, 0
# ASM: bbclri zero, 0, 0
# ENC: [0x67,0x40,0x00,0x00]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbclri zero, 0,
# UNKNOWN: <unknown>

bbclri a0, 1, 1024
# ASM: bbclri a0, 1, 1024
# ENC: [0x67,0x40,0x15,0x40]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbclri a0, 1,
# UNKNOWN: <unknown>

bbclri s1, 31, -4096
# ASM: bbclri s1, 31, -4096
# ENC: [0x67,0xc0,0xf4,0x81]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbclri s1, 31,
# UNKNOWN: <unknown>

bbclri t6, 22, 4094
# ASM: bbclri t6, 22, 4094
# ENC: [0xe7,0xcf,0x6f,0x7f]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbclri t6, 22,
# UNKNOWN: <unknown>

bbclri a0, 11, -2
# ASM: bbclri a0, 11, -2
# ENC: [0xe7,0x4f,0xb5,0xfe]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbclri a0, 11,
# UNKNOWN: <unknown>

bbseti zero, 0, 0
# ASM: bbseti zero, 0, 0
# ENC: [0x67,0x50,0x00,0x00]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbseti zero, 0,
# UNKNOWN: <unknown>

bbseti a0, 1, 1024
# ASM: bbseti a0, 1, 1024
# ENC: [0x67,0x50,0x15,0x40]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbseti a0, 1,
# UNKNOWN: <unknown>

bbseti s1, 31, -4096
# ASM: bbseti s1, 31, -4096
# ENC: [0x67,0xd0,0xf4,0x81]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbseti s1, 31,
# UNKNOWN: <unknown>

bbseti t6, 22, 4094
# ASM: bbseti t6, 22, 4094
# ENC: [0xe7,0xdf,0x6f,0x7f]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbseti t6, 22,
# UNKNOWN: <unknown>

bbseti a0, 11, -2
# ASM: bbseti a0, 11, -2
# ENC: [0xe7,0x5f,0xb5,0xfe]
# ERR: instruction requires the following: 'Zibs' (Single-Bit Conditional Branches)
# OBJ: bbseti a0, 11,
# UNKNOWN: <unknown>
