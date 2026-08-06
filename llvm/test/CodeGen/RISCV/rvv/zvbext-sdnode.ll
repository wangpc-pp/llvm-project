; RUN: llc -mtriple=riscv64 -mattr=+zve64x,+experimental-zvbext \
; RUN:   -verify-machineinstrs < %s | FileCheck %s

define <vscale x 4 x i32> @pext_nxv4i32_vv(<vscale x 4 x i32> %x,
                                            <vscale x 4 x i32> %mask) {
; CHECK-LABEL: pext_nxv4i32_vv:
; CHECK:       vbcompress.vv v8, v8, v{{[0-9]+}}
; CHECK-NEXT:  ret
  %res = call <vscale x 4 x i32> @llvm.pext.nxv4i32(
      <vscale x 4 x i32> %x, <vscale x 4 x i32> %mask)
  ret <vscale x 4 x i32> %res
}

define <vscale x 4 x i32> @pext_nxv4i32_vx(<vscale x 4 x i32> %x,
                                            i32 %mask) {
; CHECK-LABEL: pext_nxv4i32_vx:
; CHECK:       vbcompress.vx v8, v8, a0
; CHECK-NEXT:  ret
  %head = insertelement <vscale x 4 x i32> poison, i32 %mask, i64 0
  %splat = shufflevector <vscale x 4 x i32> %head,
                         <vscale x 4 x i32> poison,
                         <vscale x 4 x i32> zeroinitializer
  %res = call <vscale x 4 x i32> @llvm.pext.nxv4i32(
      <vscale x 4 x i32> %x, <vscale x 4 x i32> %splat)
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @pdep_nxv8i16_vv(<vscale x 8 x i16> %x,
                                            <vscale x 8 x i16> %mask) {
; CHECK-LABEL: pdep_nxv8i16_vv:
; CHECK:       vbexpand.vv v8, v8, v{{[0-9]+}}
; CHECK-NEXT:  ret
  %res = call <vscale x 8 x i16> @llvm.pdep.nxv8i16(
      <vscale x 8 x i16> %x, <vscale x 8 x i16> %mask)
  ret <vscale x 8 x i16> %res
}

define <4 x i32> @pdep_v4i32_vv(<4 x i32> %x, <4 x i32> %mask) {
; CHECK-LABEL: pdep_v4i32_vv:
; CHECK:       vbexpand.vv v8, v8, v{{[0-9]+}}
; CHECK-NEXT:  ret
  %res = call <4 x i32> @llvm.pdep.v4i32(<4 x i32> %x, <4 x i32> %mask)
  ret <4 x i32> %res
}

define <vscale x 2 x i64> @pext_nxv2i64_vv(<vscale x 2 x i64> %x,
                                            <vscale x 2 x i64> %mask) {
; CHECK-LABEL: pext_nxv2i64_vv:
; CHECK:       vbcompress.vv v8, v8, v{{[0-9]+}}
; CHECK-NEXT:  ret
  %res = call <vscale x 2 x i64> @llvm.pext.nxv2i64(
      <vscale x 2 x i64> %x, <vscale x 2 x i64> %mask)
  ret <vscale x 2 x i64> %res
}

define <2 x i128> @pext_v2i128(<2 x i128> %x, <2 x i128> %mask) {
; CHECK-LABEL: pext_v2i128:
; CHECK-NOT:   vbcompress
; CHECK:       ret
  %res = call <2 x i128> @llvm.pext.v2i128(<2 x i128> %x,
                                            <2 x i128> %mask)
  ret <2 x i128> %res
}

declare <vscale x 4 x i32> @llvm.pext.nxv4i32(<vscale x 4 x i32>,
                                               <vscale x 4 x i32>)
declare <vscale x 8 x i16> @llvm.pdep.nxv8i16(<vscale x 8 x i16>,
                                               <vscale x 8 x i16>)
declare <4 x i32> @llvm.pdep.v4i32(<4 x i32>, <4 x i32>)
declare <vscale x 2 x i64> @llvm.pext.nxv2i64(<vscale x 2 x i64>,
                                               <vscale x 2 x i64>)
declare <2 x i128> @llvm.pext.v2i128(<2 x i128>, <2 x i128>)
