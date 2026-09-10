# RUN: llvm-mc -triple=riscv64 -filetype=obj %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-zispi - \
# RUN:   | FileCheck %s

# rd differs from rs1.
.4byte 0xb0a5862f
# CHECK: .word 0xb0a5862f

# rs1 and rd are both x0.
.4byte 0xb0a5002f
# CHECK: .word 0xb0a5002f
