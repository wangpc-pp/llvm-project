// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv32 -target-feature +v -target-feature +experimental \
// RUN:   -target-feature +experimental-zvmatch -disable-O0-optnone -emit-llvm %s -o - \
// RUN:   | opt -S -passes=mem2reg | FileCheck --check-prefix=RV32 %s
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +experimental \
// RUN:   -target-feature +experimental-zvmatch -disable-O0-optnone -emit-llvm %s -o - \
// RUN:   | opt -S -passes=mem2reg | FileCheck --check-prefix=RV64 %s

#include <riscv_vector.h>

// RV32-LABEL: @test_vmmatch_vv_u8m1_b8(
// RV32: call <vscale x 8 x i1> @llvm.riscv.vmmatch.vv.nxv8i8.i32(
// RV64-LABEL: @test_vmmatch_vv_u8m1_b8(
// RV64: call <vscale x 8 x i1> @llvm.riscv.vmmatch.vv.nxv8i8.i64(
vbool8_t test_vmmatch_vv_u8m1_b8(vuint8m1_t query, vuint8m1_t keys,
                                  size_t vl) {
  return __riscv_vmmatch_vv_u8m1_b8(query, keys, vl);
}

// The packed key set has XLEN width, independent of SEW.
// RV32-LABEL: @test_vmmatch_vx_u8m1_b8(
// RV32-SAME: i32 noundef [[KEYS:%.*]], i32 noundef [[VL:%.*]])
// RV32: call <vscale x 8 x i1> @llvm.riscv.vmmatch.vx.nxv8i8.i32(
// RV32-SAME: <vscale x 8 x i8> {{%.*}}, i32 [[KEYS]], i32 [[VL]])
// RV64-LABEL: @test_vmmatch_vx_u8m1_b8(
// RV64-SAME: i64 noundef [[KEYS:%.*]], i64 noundef [[VL:%.*]])
// RV64: call <vscale x 8 x i1> @llvm.riscv.vmmatch.vx.nxv8i8.i64(
// RV64-SAME: <vscale x 8 x i8> {{%.*}}, i64 [[KEYS]], i64 [[VL]])
vbool8_t test_vmmatch_vx_u8m1_b8(vuint8m1_t query, uintptr_t keys,
                                  size_t vl) {
  return __riscv_vmmatch_vx_u8m1_b8(query, keys, vl);
}

// The _m form is mask-agnostic and therefore uses a poison passthru.
// RV32-LABEL: @test_vmmatch_vv_u16m1_b16_m(
// RV32: call <vscale x 4 x i1> @llvm.riscv.vmmatch.vv.mask.nxv4i16.i32(
// RV32-SAME: <vscale x 4 x i1> poison,
// RV64-LABEL: @test_vmmatch_vv_u16m1_b16_m(
// RV64: call <vscale x 4 x i1> @llvm.riscv.vmmatch.vv.mask.nxv4i16.i64(
// RV64-SAME: <vscale x 4 x i1> poison,
vbool16_t test_vmmatch_vv_u16m1_b16_m(vbool16_t mask,
                                       vuint16m1_t query,
                                       vuint16m1_t keys, size_t vl) {
  return __riscv_vmmatch_vv_u16m1_b16_m(mask, query, keys, vl);
}

// The _mu form preserves inactive mask elements and remains tail-agnostic.
// RV32-LABEL: @test_vmmatch_vx_u16m1_b16_mu(
// RV32: call <vscale x 4 x i1> @llvm.riscv.vmmatch.vx.mask.nxv4i16.i32(
// RV32-NOT: <vscale x 4 x i1> poison,
// RV64-LABEL: @test_vmmatch_vx_u16m1_b16_mu(
// RV64: call <vscale x 4 x i1> @llvm.riscv.vmmatch.vx.mask.nxv4i16.i64(
// RV64-NOT: <vscale x 4 x i1> poison,
vbool16_t test_vmmatch_vx_u16m1_b16_mu(vbool16_t mask,
                                        vbool16_t maskedoff,
                                        vuint16m1_t query,
                                        uintptr_t keys, size_t vl) {
  return __riscv_vmmatch_vx_u16m1_b16_mu(mask, maskedoff, query, keys, vl);
}
