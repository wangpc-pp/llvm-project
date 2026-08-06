; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 \
; RUN:   -mattr=+zve64x,+experimental-zvbext \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 \
; RUN:   -mattr=+zve64x,+experimental-zvbext \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK,RV64

define <vscale x 4 x i32> @vbcompress_vv(<vscale x 4 x i32> %x,
                                         <vscale x 4 x i32> %mask,
                                         iXLen %vl) {
; CHECK-LABEL: vbcompress_vv:
; CHECK:       vbcompress.vv v8, v8, v10
; CHECK-NEXT:  ret
  %res = call <vscale x 4 x i32>
      @llvm.riscv.vbcompress.nxv4i32.nxv4i32(
          <vscale x 4 x i32> poison, <vscale x 4 x i32> %x,
          <vscale x 4 x i32> %mask, iXLen %vl)
  ret <vscale x 4 x i32> %res
}

define <vscale x 4 x i32> @vbcompress_vx(<vscale x 4 x i32> %x,
                                         i32 %mask, iXLen %vl) {
; CHECK-LABEL: vbcompress_vx:
; CHECK:       vbcompress.vx v8, v8, a0
; CHECK-NEXT:  ret
  %res = call <vscale x 4 x i32>
      @llvm.riscv.vbcompress.nxv4i32.i32(
          <vscale x 4 x i32> poison, <vscale x 4 x i32> %x,
          i32 %mask, iXLen %vl)
  ret <vscale x 4 x i32> %res
}

define <vscale x 4 x i32> @vbexpand_mask_vv(
    <vscale x 4 x i32> %passthru, <vscale x 4 x i32> %x,
    <vscale x 4 x i32> %mask, <vscale x 4 x i1> %pred, iXLen %vl) {
; CHECK-LABEL: vbexpand_mask_vv:
; CHECK:       vbexpand.vv v8, v10, v12, v0.t
; CHECK-NEXT:  ret
  %res = call <vscale x 4 x i32>
      @llvm.riscv.vbexpand.mask.nxv4i32.nxv4i32(
          <vscale x 4 x i32> %passthru, <vscale x 4 x i32> %x,
          <vscale x 4 x i32> %mask, <vscale x 4 x i1> %pred,
          iXLen %vl, iXLen 0)
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @vbexpand_vx_i64(
    <vscale x 2 x i64> %x, i64 %mask, iXLen %vl) {
; RV32-LABEL: vbexpand_vx_i64:
; RV32:       vbexpand.vv
; RV64-LABEL: vbexpand_vx_i64:
; RV64:       vbexpand.vx v8, v8, a0
; RV64-NEXT:  ret
  %res = call <vscale x 2 x i64>
      @llvm.riscv.vbexpand.nxv2i64.i64(
          <vscale x 2 x i64> poison, <vscale x 2 x i64> %x,
          i64 %mask, iXLen %vl)
  ret <vscale x 2 x i64> %res
}

declare <vscale x 4 x i32>
    @llvm.riscv.vbcompress.nxv4i32.nxv4i32(
        <vscale x 4 x i32>, <vscale x 4 x i32>,
        <vscale x 4 x i32>, iXLen)
declare <vscale x 4 x i32>
    @llvm.riscv.vbcompress.nxv4i32.i32(
        <vscale x 4 x i32>, <vscale x 4 x i32>, i32, iXLen)
declare <vscale x 4 x i32>
    @llvm.riscv.vbexpand.mask.nxv4i32.nxv4i32(
        <vscale x 4 x i32>, <vscale x 4 x i32>,
        <vscale x 4 x i32>, <vscale x 4 x i1>, iXLen, iXLen)
declare <vscale x 2 x i64>
    @llvm.riscv.vbexpand.nxv2i64.i64(
        <vscale x 2 x i64>, <vscale x 2 x i64>, i64, iXLen)
