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

//===----------------------------------------------------------------------===//
// Patterns.
//===----------------------------------------------------------------------===//

// Zvcd only supports SEW=32 and SEW=64.
defvar AllZvcdVectors = [VI32MF2, VI32M1, VI32M2, VI32M4, VI32M8,
                         VI64M1, VI64M2, VI64M4, VI64M8];

// vconflictcnt.v: data-in/data-out, both the same integer vector type.
multiclass VPatUnaryV_V_Zvcd<string intrinsic, string instruction> {
  foreach vti = AllZvcdVectors in {
    let Predicates = !listconcat([HasStdExtZvcd],
                                 GetVTypePredicates<vti>.Predicates) in {
      def : VPatUnaryNoMask<intrinsic, instruction, "V",
                            vti.Vector, vti.Vector, vti.Log2SEW,
                            vti.LMul, vti.RegClass, vti.RegClass>;
      def : VPatUnaryMask<intrinsic, instruction, "V",
                          vti.Vector, vti.Vector, vti.Mask, vti.Log2SEW,
                          vti.LMul, vti.RegClass, vti.RegClass>;
    }
  }
}

// vconflictlast.m: data-in (integer vector), mask-out. The mask destination
// is always tail-agnostic, so the masked pattern hard-codes TA_MU and the
// masked intrinsic takes no policy operand (as with compares / vmsbf).
multiclass VPatUnaryM_V_Zvcd<string intrinsic, string instruction> {
  foreach vti = AllZvcdVectors in {
    let Predicates = !listconcat([HasStdExtZvcd],
                                 GetVTypePredicates<vti>.Predicates) in {
      def : Pat<(vti.Mask (!cast<Intrinsic>(intrinsic)
                          (vti.Mask VR:$passthru),
                          (vti.Vector vti.RegClass:$rs2),
                          VLOpFrag)),
                (!cast<Instruction>(instruction#"_"#vti.LMul.MX)
                          (vti.Mask VR:$passthru),
                          (vti.Vector vti.RegClass:$rs2),
                          GPR:$vl, vti.Log2SEW, TU_MU)>;
      def : Pat<(vti.Mask (!cast<Intrinsic>(intrinsic#"_mask")
                          (vti.Mask VR:$passthru),
                          (vti.Vector vti.RegClass:$rs2),
                          (vti.Mask VMV0:$vm),
                          VLOpFrag)),
                (!cast<Instruction>(instruction#"_"#vti.LMul.MX#"_MASK")
                          (vti.Mask VR:$passthru),
                          (vti.Vector vti.RegClass:$rs2),
                          (vti.Mask VMV0:$vm),
                          GPR:$vl, vti.Log2SEW, TA_MU)>;
    }
  }
}

defm : VPatUnaryV_V_Zvcd<"int_riscv_vconflictcnt", "PseudoVCONFLICTCNT">;
defm : VPatUnaryM_V_Zvcd<"int_riscv_vconflictlast", "PseudoVCONFLICTLAST_M">;
