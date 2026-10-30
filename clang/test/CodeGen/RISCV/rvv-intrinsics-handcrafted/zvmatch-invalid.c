// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +experimental \
// RUN:   -target-feature +experimental-zvmatch -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv64 -target-feature +zve32x -target-feature +zvl64b \
// RUN:   -target-feature +experimental -target-feature +experimental-zvmatch \
// RUN:   -DTEST_SMALL_VLEN -fsyntax-only -verify=small-vlen %s

#include <riscv_vector.h>

#ifndef TEST_SMALL_VLEN

void reject_e32(vuint32m1_t query, vuint32m1_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vs_u32m1_b32'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vs_u32m1_b32(query, keys, vl);
}

void reject_e64(vuint64m1_t query, uintptr_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vx_u64m1_b64'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vx_u64m1_b64(query, keys, vl);
}

void reject_tu(vbool8_t maskedoff, vuint8m1_t query, vuint8m1_t keys,
               size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vs_u8m1_b8_tu'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vs_u8m1_b8_tu(maskedoff, query, keys, vl);
}

void reject_tum(vbool8_t mask, vbool8_t maskedoff, vuint8m1_t query,
                vuint8m1_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vs_u8m1_b8_tum'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vs_u8m1_b8_tum(mask, maskedoff, query, keys, vl);
}

void reject_tumu(vbool8_t mask, vbool8_t maskedoff, vuint8m1_t query,
                 uintptr_t keys, size_t vl) {
  // expected-error@+1 {{call to undeclared function '__riscv_vmmatch_vx_u8m1_b8_tumu'; ISO C99 and later do not support implicit function declarations}}
  (void)__riscv_vmmatch_vx_u8m1_b8_tumu(mask, maskedoff, query, keys, vl);
}

#else
// An M1 key value on VLEN=64 cannot supply the required 128 key bits.
void reject_short_keys(vbool8_t mask, vbool8_t maskedoff, vuint8m1_t query,
                        vuint8m1_t keys, size_t vl) {
  // small-vlen-error@+1 {{RISC-V type 'vuint8m1_t' (aka '__rvv_uint8m1_t') requires the 'zvl128b' extension}}
  (void)__riscv_vmmatch_vs_u8m1_b8(query, keys, vl);
  // small-vlen-error@+1 {{RISC-V type 'vuint8m1_t' (aka '__rvv_uint8m1_t') requires the 'zvl128b' extension}}
  (void)__riscv_vmmatch_vs_u8m1_b8_m(mask, query, keys, vl);
  // small-vlen-error@+1 {{RISC-V type 'vuint8m1_t' (aka '__rvv_uint8m1_t') requires the 'zvl128b' extension}}
  (void)__riscv_vmmatch_vs_u8m1_b8_mu(mask, maskedoff, query, keys, vl);
}

void accept_full_keys(vuint8m1_t query, vuint8m2_t keys, uintptr_t packed,
                       size_t vl) {
  (void)__riscv_vmmatch_vs_u8m1_u8m2_b8(query, keys, vl);
  (void)__riscv_vmmatch_vx_u8m1_b8(query, packed, vl);
}
#endif
