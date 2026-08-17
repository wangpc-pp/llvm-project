//===---- RISCVInstrInfoZvcd.td - 'Zvcd' instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the RISC-V instructions from the 'Zvcd' extension for
// vector conflict detection.
// This version is still experimental as the 'Zvcd' extension hasn't been
// ratified yet.
//
// Both instructions share the OP-V/OPMVV VMUNARY0 group (funct6=010100,
// funct3=010) and select their sub-operation via vs1:
//   vconflictcnt.v  - vs1=10010, data result (each active lane's 1-based rank
//                     in its equal-value active prefix).
//   vconflictlast.m - vs1=00100, mask result (marks the highest-index lane in
//                     every equal-value active group).
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvcd], Constraints = "@earlyclobber $vd",
    VS1VS2Constraint = Iota in {
// vconflictcnt.v computes an SEW-bit data vector, so the destination register
// group cannot overlap the source group.
def VCONFLICTCNT_V : VIOTA_MV_VS2<"vconflictcnt.v", 0b010100, 0b10010>;

// vconflictlast.m computes a single-register mask result.
let DestEEW = EEW1 in
def VCONFLICTLAST_M : VMSFS_MV_VS2<"vconflictlast.m", 0b010100, 0b00100>;
} // Predicates = [HasStdExtZvcd], Constraints = "@earlyclobber $vd", ...
