# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-zimemops %s 2>&1 | FileCheck %s
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-zimemops %s 2>&1 | FileCheck %s

mcopy (zero), (a1), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mcopy (a0), (zero), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mcopy (a0), (a1), zero
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mmove (zero), (a1), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mmove (a0), (zero), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mmove (a0), (a1), zero
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mset (zero), a1, a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mset (a0), a1, zero
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR excluding zero (x0)

mcopy (a0), (a0), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mcopy (a0), (a1), a0
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mcopy (a0), (a1), a1
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mmove (a0), (a0), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mmove (a0), (a1), a0
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mmove (a0), (a1), a1
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mset (a0), a0, a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mset (a0), a1, a0
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mset (a0), a1, a1
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: rd, rs1, and rs2 must be different

mcopy a0, a1, a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: expected '('

mset (a0), (a1), a2
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: register must be a GPR

mcopy (a0), (a1)
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: too few operands for instruction

mmove (a0), (a1)
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: too few operands for instruction

mset (a0), a1
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: too few operands for instruction
