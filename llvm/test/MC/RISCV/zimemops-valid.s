# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zimemops -show-encoding %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zimemops -show-encoding %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: not llvm-mc -triple=riscv32 %s 2>&1 | FileCheck %s --check-prefix=ERROR
# RUN: not llvm-mc -triple=riscv64 %s 2>&1 | FileCheck %s --check-prefix=ERROR
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-zimemops -filetype=obj %s | llvm-objdump -d --mattr=+experimental-zimemops - | FileCheck %s --check-prefix=ASM
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zimemops -filetype=obj %s | llvm-objdump -d --mattr=+experimental-zimemops - | FileCheck %s --check-prefix=ASM
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zimemops -filetype=obj %s | llvm-objdump -d --mattr=-experimental-zimemops - | FileCheck %s --check-prefix=UNKNOWN

mcopy (a0), (a1), a2
# ASM: mcopy (a0), (a1), a2
# ENC: encoding: [0x0f,0xb5,0xc5,0x00]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mcopy (ra), (t5), t6
# ASM: mcopy (ra), (t5), t6
# ENC: encoding: [0x8f,0x30,0xff,0x01]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mmove (a0), (a1), a2
# ASM: mmove (a0), (a1), a2
# ENC: encoding: [0x0f,0xb5,0xc5,0x06]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mmove (t6), (ra), sp
# ASM: mmove (t6), (ra), sp
# ENC: encoding: [0x8f,0xbf,0x20,0x06]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mset (a0), a1, a2
# ASM: mset (a0), a1, a2
# ENC: encoding: [0x0f,0xb5,0xc5,0x0c]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mset (ra), zero, t6
# ASM: mset (ra), zero, t6
# ENC: encoding: [0x8f,0x30,0xf0,0x0d]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>

mset (t6), t5, ra
# ASM: mset (t6), t5, ra
# ENC: encoding: [0x8f,0x3f,0x1f,0x0c]
# ERROR: instruction requires the following: 'Zimemops' (Bulk Memory Operations)
# UNKNOWN: <unknown>
