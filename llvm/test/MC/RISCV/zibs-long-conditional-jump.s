# RUN: llvm-mc -filetype=obj --mattr=+experimental-zibs -triple=riscv32 %s \
# RUN:     | llvm-objdump --mattr=+experimental-zibs -d -M no-aliases - \
# RUN:     | FileCheck --check-prefix=CHECK-INST %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+relax,+experimental-zibs %s \
# RUN:     | llvm-objdump --mattr=+experimental-zibs -dr -M no-aliases - \
# RUN:     | FileCheck --check-prefix=CHECK-INST-RELAX %s

# RUN: llvm-mc -filetype=obj --mattr=+experimental-zibs -triple=riscv64 %s | llvm-objdump --mattr=+experimental-zibs -d -M no-aliases - | FileCheck --check-prefix=CHECK-INST %s

# Tests that are forward in range.

# CHECK-INST-LABEL: bbclri_in_range_forward
# CHECK-INST:       bbclri a0, 0xa, {{.*}}

# CHECK-INST-RELAX-LABEL: bbclri_in_range_forward
# CHECK-INST-RELAX:       bbclri a0, 0xa, {{.*}}
bbclri_in_range_forward:
   bbclri a0, 10, .L1
   .fill 1000, 4, 0
.L1:
   ret

# CHECK-INST-LABEL: bbseti_in_range_forward
# CHECK-INST:       bbseti a0, 0xa, {{.*}}

# CHECK-INST-RELAX-LABEL: bbseti_in_range_forward
# CHECK-INST-RELAX:       bbseti a0, 0xa, {{.*}}
bbseti_in_range_forward:
   bbseti a0, 10, .L2
   .fill 1000, 4, 0
.L2:
   ret

# Tests that are backward in range.

# CHECK-INST-LABEL: bbclri_in_range_backward
# CHECK-INST:       bbclri a0, 0xa, {{.*}}

# CHECK-INST-RELAX-LABEL: bbclri_in_range_backward
# CHECK-INST-RELAX:       bbclri a0, 0xa, {{.*}}
bbclri_in_range_backward:
.L3:
   .fill 1000, 4, 0
   bbclri a0, 10, .L3
   ret

# CHECK-INST-LABEL: bbseti_in_range_backward
# CHECK-INST:       bbseti a0, 0xa, {{.*}}

# CHECK-INST-RELAX-LABEL: bbseti_in_range_backward
# CHECK-INST-RELAX:       bbseti a0, 0xa, {{.*}}
bbseti_in_range_backward:
.L4:
   .fill 1000, 4, 0
   bbseti a0, 10, .L4
   ret

# Tests that are forward out of range.

# CHECK-INST-LABEL: bbclri_out_of_range_forward
# CHECK-INST:       bbseti a0, 0xa, {{.*}}+0x8
# CHECK-INST-NEXT:  jal zero, {{.*}}

# CHECK-INST-RELAX-LABEL: bbclri_out_of_range_forward
# CHECK-INST-RELAX:       bbseti a0, 0xa, {{.*}}+0x8
# CHECK-INST-RELAX-NEXT:  jal zero, {{.*}}
bbclri_out_of_range_forward:
   bbclri a0, 10, .L5
   .fill 1300, 4, 0
.L5:
   ret

# CHECK-INST-LABEL: bbseti_out_of_range_forward
# CHECK-INST:       bbclri a0, 0xa, {{.*}}+0x8
# CHECK-INST-NEXT:  jal zero, {{.*}}

# CHECK-INST-RELAX-LABEL: bbseti_out_of_range_forward
# CHECK-INST-RELAX:       bbclri a0, 0xa, {{.*}}+0x8
# CHECK-INST-RELAX-NEXT:  jal zero, {{.*}}
bbseti_out_of_range_forward:
   bbseti a0, 10, .L6
   .fill 1300, 4, 0
.L6:
   ret

# Tests that are backward out of range.

# CHECK-INST-LABEL: bbclri_out_of_range_backward
# CHECK-INST:       bbseti a0, 0xa, {{.*}}+0x1458
# CHECK-INST-NEXT:  jal zero, {{.*}}

# CHECK-INST-RELAX-LABEL: bbclri_out_of_range_backward
# CHECK-INST-RELAX:       bbseti a0, 0xa, {{.*}}+0x1458
# CHECK-INST-RELAX-NEXT:  jal zero, {{.*}}
bbclri_out_of_range_backward:
.L7:
   .fill 1300, 4, 0
   bbclri a0, 10, .L7
   ret

# CHECK-INST-LABEL: bbseti_out_of_range_backward
# CHECK-INST:       bbclri a0, 0xa, {{.*}}+0x1458
# CHECK-INST-NEXT:  jal zero, {{.*}}

# CHECK-INST-RELAX-LABEL: bbseti_out_of_range_backward
# CHECK-INST-RELAX:       bbclri a0, 0xa, {{.*}}+0x1458
# CHECK-INST-RELAX-NEXT:  jal zero, {{.*}}
bbseti_out_of_range_backward:
.L8:
   .fill 1300, 4, 0
   bbseti a0, 10, .L8
   ret

# CHECK-INST-LABEL: unresolved
# CHECK-INST: bbseti a0, 0x1f, {{.*}}+0x8
# CHECK-INST-NEXT: jal zero, {{.*}}
# CHECK-INST-RELAX-LABEL: unresolved
# CHECK-INST-RELAX: bbseti a0, 0x1f, {{.*}}+0x8
# CHECK-INST-RELAX-NEXT: jal zero, {{.*}}
# CHECK-INST-RELAX-NEXT: R_RISCV_JAL external+0x2
unresolved:
  bbclri a0, 31, external+2
