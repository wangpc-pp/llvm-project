# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zibs,+exact-asm -filetype=obj %s | llvm-objdump -dr --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs,+exact-asm -filetype=obj %s | llvm-objdump -dr --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s

bbclri a0, 31, external
# CHECK: bbclri a0, 31,
# CHECK-NEXT: R_RISCV_BRANCH external
bbseti a1, 0, external+2
# CHECK: bbseti a1, 0,
# CHECK-NEXT: R_RISCV_BRANCH external+0x2
