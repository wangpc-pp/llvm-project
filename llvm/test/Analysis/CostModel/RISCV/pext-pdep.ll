; RUN: opt -passes="print<cost-model>" -disable-output -mtriple=riscv64 \
; RUN:   -mattr=+zve32x,+experimental-zvbce %s 2>&1 \
; RUN:   | FileCheck %s --check-prefix=ZVBCE
; RUN: opt -passes="print<cost-model>" -disable-output -mtriple=riscv64 \
; RUN:   -mattr=+zve64x,+experimental-zvbce %s 2>&1 \
; RUN:   | FileCheck %s --check-prefix=ZVBCE-ZVE64X

define void @costs() {
; ZVBCE-LABEL: 'costs'
; ZVBCE: Cost Model: Found an estimated cost of 4 for instruction: %pext32 = call <4 x i32> @llvm.pext.v4i32
; ZVBCE: Cost Model: Found an estimated cost of 1 for instruction: %pdep32 = call <vscale x 2 x i32> @llvm.pdep.nxv2i32
; ZVBCE: Cost Model: Invalid cost for instruction: %pext64 = call <vscale x 2 x i64> @llvm.pext.nxv2i64
; ZVBCE-ZVE64X-LABEL: 'costs'
; ZVBCE-ZVE64X: Cost Model: Found an estimated cost of 2 for instruction: %pext32 = call <4 x i32> @llvm.pext.v4i32
; ZVBCE-ZVE64X: Cost Model: Found an estimated cost of 1 for instruction: %pdep32 = call <vscale x 2 x i32> @llvm.pdep.nxv2i32
; ZVBCE-ZVE64X: Cost Model: Found an estimated cost of 2 for instruction: %pext64 = call <vscale x 2 x i64> @llvm.pext.nxv2i64
; ZVBCE-ZVE64X: Cost Model: Found an estimated cost of {{[2-9]|[1-9][0-9]+}} for instruction: %pext1 = call <4 x i1> @llvm.pext.v4i1
  %pext32 = call <4 x i32> @llvm.pext.v4i32(<4 x i32> poison,
                                            <4 x i32> poison)
  %pdep32 = call <vscale x 2 x i32> @llvm.pdep.nxv2i32(
      <vscale x 2 x i32> poison, <vscale x 2 x i32> poison)
  %pext64 = call <vscale x 2 x i64> @llvm.pext.nxv2i64(
      <vscale x 2 x i64> poison, <vscale x 2 x i64> poison)
  %pext1 = call <4 x i1> @llvm.pext.v4i1(<4 x i1> poison,
                                          <4 x i1> poison)
  ret void
}

declare <4 x i32> @llvm.pext.v4i32(<4 x i32>, <4 x i32>)
declare <vscale x 2 x i32> @llvm.pdep.nxv2i32(<vscale x 2 x i32>,
                                               <vscale x 2 x i32>)
declare <vscale x 2 x i64> @llvm.pext.nxv2i64(<vscale x 2 x i64>,
                                               <vscale x 2 x i64>)
declare <4 x i1> @llvm.pext.v4i1(<4 x i1>, <4 x i1>)
