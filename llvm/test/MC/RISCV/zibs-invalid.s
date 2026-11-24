# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-zibs %s 2>&1 | FileCheck %s --check-prefixes=ERR,RV32
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-zibs %s 2>&1 | FileCheck %s --check-prefixes=ERR,RV64

bbclri a0, -1, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbclri a0, 64, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbclri a0, symbol, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbclri a0, 0, -4098
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbclri a0, 0, 4096
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbclri a0, 0, 3
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbclri a0, 1
# ERR: too few operands for instruction
bbclri a0, a1, 4
# ERR: immediate must be an integer
bbseti a0, -1, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbseti a0, 64, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbseti a0, symbol, 4
# RV32: immediate must be an integer in the range [0, 31]
# RV64: immediate must be an integer in the range [0, 63]
bbseti a0, 0, -4098
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbseti a0, 0, 4096
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbseti a0, 0, 3
# ERR: immediate must be a multiple of 2 bytes in the range [-4096, 4094]
bbseti a0, 1
# ERR: too few operands for instruction
bbseti a0, a1, 4
# ERR: immediate must be an integer
