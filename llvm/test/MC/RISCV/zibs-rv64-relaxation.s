# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs -filetype=obj %s | llvm-objdump -dr --mattr=+experimental-zibs --no-print-imm-hex - | FileCheck %s
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-zibs,+zca -filetype=obj %s | llvm-objdump -dr --mattr=+experimental-zibs,+zca --no-print-imm-hex - | FileCheck %s

# CHECK-LABEL: <forward>:
# CHECK-NEXT: bbseti a0, 63, {{.*}} <forward+0x8>
# CHECK-NEXT: j {{.*}} <target>
forward:
  bbclri a0, 63, target
  .space 4096
target:

# CHECK-LABEL: <target>:
# CHECK-NEXT: bbclri a1, 32, {{.*}} <external_target>
# CHECK-NEXT: j {{.*}} <forward>
backward:
  bbseti a1, 32, forward

# CHECK-LABEL: <external_target>:
# CHECK-NEXT: bbclri a2, 63, {{.*}} <external_target+0x8>
# CHECK-NEXT: j {{.*}}
# CHECK-NEXT: R_RISCV_JAL external+0x2
external_target:
  bbseti a2, 63, external+2
