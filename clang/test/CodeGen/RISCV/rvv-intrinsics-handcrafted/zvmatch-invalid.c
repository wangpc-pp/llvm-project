// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +experimental \
// RUN:   -target-feature +experimental-zvmatch -fsyntax-only -verify %s

#include <riscv_vector.h>

void reject_e32(vuint32m1_t query, vuint32m1_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vv_u32m1_b32'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vv_u32m1_b32(query, keys, vl);
}

void reject_e64(vuint64m1_t query, uintptr_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vx_u64m1_b64'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vx_u64m1_b64(query, keys, vl);
}

void reject_tu(vbool8_t maskedoff, vuint8m1_t query, vuint8m1_t keys,
               size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vv_u8m1_b8_tu'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vv_u8m1_b8_tu(maskedoff, query, keys, vl);
}

void reject_tum(vbool8_t mask, vbool8_t maskedoff, vuint8m1_t query,
                vuint8m1_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vv_u8m1_b8_tum'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vv_u8m1_b8_tum(mask, maskedoff, query, keys, vl);
}

void reject_tumu(vbool8_t mask, vbool8_t maskedoff, vuint8m1_t query,
                 uintptr_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vx_u8m1_b8_tumu'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vx_u8m1_b8_tumu(mask, maskedoff, query, keys, vl);
}
