; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 \
; RUN:   -mattr=+v,+experimental-zvmatch -verify-machineinstrs | FileCheck %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 \
; RUN:   -mattr=+v,+experimental-zvmatch -verify-machineinstrs | FileCheck %s

define <vscale x 8 x i1> @vmmatch_vv_u8m1(<vscale x 8 x i8> %query,
                                           <vscale x 8 x i8> %keys,
                                           iXLen %vl) {
; CHECK-LABEL: vmmatch_vv_u8m1:
; CHECK:       vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:  vmmatch.vv v0, v8, v9
; CHECK-NEXT:  ret
  %res = call <vscale x 8 x i1>
      @llvm.riscv.vmmatch.vv.nxv8i8.iXLen(<vscale x 8 x i8> %query,
                                          <vscale x 8 x i8> %keys,
                                          iXLen %vl)
  ret <vscale x 8 x i1> %res
}

define <vscale x 8 x i1> @vmmatch_vx_u8m1(<vscale x 8 x i8> %query,
                                           iXLen %keys, iXLen %vl) {
; CHECK-LABEL: vmmatch_vx_u8m1:
; CHECK:       vsetvli zero, a1, e8, m1, ta, ma
; CHECK-NEXT:  vmmatch.vx v0, v8, a0
; CHECK-NEXT:  ret
  %res = call <vscale x 8 x i1>
      @llvm.riscv.vmmatch.vx.nxv8i8.iXLen(<vscale x 8 x i8> %query,
                                          iXLen %keys, iXLen %vl)
  ret <vscale x 8 x i1> %res
}

define <vscale x 4 x i1> @vmmatch_vv_u16m1_m(
    <vscale x 4 x i1> %mask, <vscale x 4 x i16> %query,
    <vscale x 4 x i16> %keys, iXLen %vl) {
; CHECK-LABEL: vmmatch_vv_u16m1_m:
; CHECK:       vsetvli zero, a0, e16, m1, ta, ma
; CHECK:       vmmatch.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
; CHECK:       ret
  %res = call <vscale x 4 x i1>
      @llvm.riscv.vmmatch.vv.mask.nxv4i16.iXLen(
          <vscale x 4 x i1> poison, <vscale x 4 x i16> %query,
          <vscale x 4 x i16> %keys, <vscale x 4 x i1> %mask, iXLen %vl)
  ret <vscale x 4 x i1> %res
}

define <vscale x 4 x i1> @vmmatch_vx_u16m1_mu(
    <vscale x 4 x i1> %mask, <vscale x 4 x i1> %maskedoff,
    <vscale x 4 x i16> %query, iXLen %keys, iXLen %vl) {
; CHECK-LABEL: vmmatch_vx_u16m1_mu:
; CHECK:       vsetvli zero, a1, e16, m1, ta, mu
; CHECK:       vmmatch.vx {{v[0-9]+}}, {{v[0-9]+}}, a0, v0.t
; CHECK:       ret
  %res = call <vscale x 4 x i1>
      @llvm.riscv.vmmatch.vx.mask.nxv4i16.iXLen(
          <vscale x 4 x i1> %maskedoff, <vscale x 4 x i16> %query,
          iXLen %keys, <vscale x 4 x i1> %mask, iXLen %vl)
  ret <vscale x 4 x i1> %res
}

declare <vscale x 8 x i1>
    @llvm.riscv.vmmatch.vv.nxv8i8.iXLen(<vscale x 8 x i8>,
                                        <vscale x 8 x i8>, iXLen)
declare <vscale x 8 x i1>
    @llvm.riscv.vmmatch.vx.nxv8i8.iXLen(<vscale x 8 x i8>, iXLen, iXLen)
declare <vscale x 4 x i1>
    @llvm.riscv.vmmatch.vv.mask.nxv4i16.iXLen(
        <vscale x 4 x i1>, <vscale x 4 x i16>, <vscale x 4 x i16>,
        <vscale x 4 x i1>, iXLen)
declare <vscale x 4 x i1>
    @llvm.riscv.vmmatch.vx.mask.nxv4i16.iXLen(
        <vscale x 4 x i1>, <vscale x 4 x i16>, iXLen,
        <vscale x 4 x i1>, iXLen)
