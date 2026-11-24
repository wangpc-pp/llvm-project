# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs -show-encoding %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs -filetype=obj %s | llvm-objdump -d --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s --check-prefix=OBJ
# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-zibs %s 2>&1 | FileCheck %s --check-prefix=ERR

bbclri a0, 32, 4
# ASM: bbclri a0, 32, 4
# ENC: [0x67,0x62,0x05,0x00]
# OBJ: bbclri a0, 32,
# ERR: immediate must be an integer in the range [0, 31]

bbclri a0, 63, 4
# ASM: bbclri a0, 63, 4
# ENC: [0x67,0x62,0xf5,0x01]
# OBJ: bbclri a0, 63,
# ERR: immediate must be an integer in the range [0, 31]

bbseti a0, 32, 4
# ASM: bbseti a0, 32, 4
# ENC: [0x67,0x72,0x05,0x00]
# OBJ: bbseti a0, 32,
# ERR: immediate must be an integer in the range [0, 31]

bbseti a0, 63, 4
# ASM: bbseti a0, 63, 4
# ENC: [0x67,0x72,0xf5,0x01]
# OBJ: bbseti a0, 63,
# ERR: immediate must be an integer in the range [0, 31]
