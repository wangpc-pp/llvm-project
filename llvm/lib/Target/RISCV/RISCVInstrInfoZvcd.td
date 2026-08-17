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
// group cannot overlap the source group. Each result element only counts
// matching active lanes in its prefix, so its value depends on the mask but
// not on VL.
let ElementsDependOn = EltDepsMask in
def VCONFLICTCNT_V : VIOTA_MV_VS2<"vconflictcnt.v", 0b010100, 0b10010>;

// vconflictlast.m computes a single-register mask result. Each result bit
// looks at higher-index active lanes up to VL, so its value depends on both
// the mask and VL (the default EltDepsVLMask).
let DestEEW = EEW1 in
def VCONFLICTLAST_M : VMSFS_MV_VS2<"vconflictlast.m", 0b010100, 0b00100>;
} // Predicates = [HasStdExtZvcd], Constraints = "@earlyclobber $vd", ...

//===----------------------------------------------------------------------===//
// Pseudo Instructions for CodeGen
//===----------------------------------------------------------------------===//

// vconflictcnt.v: data-in/data-out, both EEW=SEW and EMUL=LMUL.
multiclass VPseudoVCONFLICTCNT_V {
  defvar constraint = "@earlyclobber $rd";
  foreach m = MxList in {
    defvar mx = m.MX;
    let VLMul = m.value in {
      def "_" # mx : VPseudoUnaryNoMask<m.vrclass, m.vrclass, constraint>,
                     SchedUnary<"WriteVIotaV", "ReadVIotaV", mx,
                                forcePassthruRead=true>;
      def "_" # mx # "_MASK" : VPseudoUnaryMask<m.vrclass, m.vrclass, constraint>,
                               RISCVMaskedPseudo<MaskIdx=2>,
                               SchedUnary<"WriteVIotaV", "ReadVIotaV", mx,
                                          forcePassthruRead=true>;
    }
  }
}

// vconflictlast.m: data-in (EEW=SEW, EMUL=LMUL), mask-out (EEW=1).
multiclass VPseudoVCONFLICTLAST_M {
  defvar constraint = "@earlyclobber $rd";
  foreach m = MxList in {
    defvar mx = m.MX;
    let VLMul = m.value in {
      def "_" # mx : VPseudoUnaryNoMask<VR, m.vrclass, constraint>,
                     SchedUnary<"WriteVMSFSV", "ReadVMSFSV", mx,
                                forcePassthruRead=true>;
      def "_" # mx # "_MASK" : VPseudoUnaryMask<VR, m.vrclass, constraint>,
                               RISCVMaskedPseudo<MaskIdx=2>,
                               SchedUnary<"WriteVMSFSV", "ReadVMSFSV", mx,
                                          forcePassthruRead=true>;
    }
  }
}

let Predicates = [HasStdExtZvcd] in {
defm PseudoVCONFLICTCNT_V  : VPseudoVCONFLICTCNT_V;
defm PseudoVCONFLICTLAST_M : VPseudoVCONFLICTLAST_M;
} // Predicates = [HasStdExtZvcd]
