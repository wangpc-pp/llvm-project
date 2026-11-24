# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zibs -disassemble < %s 2>&1 | FileCheck %s

0x67 0x62 0x05 0x00
# CHECK: warning: invalid instruction encoding
0x67 0x62 0xf5 0x01
# CHECK: warning: invalid instruction encoding
0x67 0x72 0x05 0x00
# CHECK: warning: invalid instruction encoding
0x67 0x72 0xf5 0x01
# CHECK: warning: invalid instruction encoding
