//===-- RISCVInstrInfoZvmatch.td - 'Zvmatch' instructions -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the experimental 'Zvmatch' vector match extension.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvmatch], ElementsDependOn = EltDepsNone,
    DestEEW = EEW1, VMConstraint = false in {
  let VS1VS2Constraint = VS1Constraint in
  def VMMATCH_VS : VALUVV<0b110100, OPIVV, "vmmatch.vs">,
                   SchedBinaryMC<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV">;
  def VMMATCH_VX : VALUVX<0b110100, OPIVX, "vmmatch.vx">,
                   SchedBinaryMC<"WriteVICmpX", "ReadVICmpV", "ReadVICmpX">;
}

//===----------------------------------------------------------------------===//
// Pseudos
//===----------------------------------------------------------------------===//

defvar AllZvmatchVectors =
    !filter(vti, AllIntegerVectors, !le(vti.SEW, 16));

// Key types are independent of the query LMUL. M1 requires VLEN >= 128;
// M2 provides the complete key group on LLVM's minimum VLEN of 64.
multiclass VPseudoVMMATCH_VS {
  foreach vti = AllZvmatchVectors in {
    foreach key = !if(!eq(vti.SEW, 8), [VI8M1, VI8M2], [VI16M1, VI16M2]) in {
      let VLMul = vti.LMul.value, SEW = vti.SEW in {
        def "_VS_" # vti.LMul.MX # "_" # key.LMul.MX # "_E" # vti.SEW :
          VPseudoBinaryNoMask<VR, vti.RegClass, key.RegClass,
                              "@earlyclobber $rd",
                              TargetConstraintType = 2>,
          SchedBinary<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV",
                      vti.LMul.MX>;
        def "_VS_" # vti.LMul.MX # "_" # key.LMul.MX # "_E" # vti.SEW # "_MASK" :
          VPseudoBinaryMOutMask<
              !if(!ge(vti.LMul.octuple, 16), VRNoV0, VR),
              GetVRegNoV0<vti.RegClass>.R, GetVRegNoV0<key.RegClass>.R,
              "@earlyclobber $rd", TargetConstraintType = 2>,
          RISCVMaskedPseudo<MaskIdx = 3>,
          SchedBinary<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV",
                      vti.LMul.MX>;
      }
    }
  }
}

multiclass VPseudoVMMATCH_VX {
  foreach vti = AllZvmatchVectors in {
    let VLMul = vti.LMul.value, SEW = vti.SEW in {
      def "_VX_" # vti.LMul.MX # "_E" # vti.SEW :
        VPseudoBinaryNoMask<VR, vti.RegClass, GPR, "",
                            TargetConstraintType = 2>,
        SchedBinary<"WriteVICmpX", "ReadVICmpV", "ReadVICmpX",
                    vti.LMul.MX>;
      def "_VX_" # vti.LMul.MX # "_E" # vti.SEW # "_MASK" :
        VPseudoBinaryMOutMask<
            !if(!ge(vti.LMul.octuple, 16), VRNoV0, VR),
            GetVRegNoV0<vti.RegClass>.R, GPR, "",
            TargetConstraintType = 2>,
        RISCVMaskedPseudo<MaskIdx = 3>,
        SchedBinary<"WriteVICmpX", "ReadVICmpV", "ReadVICmpX",
                    vti.LMul.MX>;
    }
  }
}

let Predicates = [HasStdExtZvmatch] in {
  defm PseudoVMMATCH : VPseudoVMMATCH_VS, VPseudoVMMATCH_VX;
}

//===----------------------------------------------------------------------===//
// Intrinsic patterns
//===----------------------------------------------------------------------===//

def HasZvmatchKeyM1 : Predicate<"Subtarget->getRealMinVLen() >= 128">;

multiclass VPatVMMATCHVS<VTypeInfo vti> {
  foreach key = !if(!eq(vti.SEW, 8), [VI8M1, VI8M2], [VI16M1, VI16M2]) in {
    let Predicates = !listconcat([HasStdExtZvmatch],
                                 GetVTypePredicates<vti>.Predicates,
                                 !if(!eq(key.LMul.MX, "M1"),
                                     [HasZvmatchKeyM1], [])) in
    defm : VPatBinaryM<"int_riscv_vmmatch_vs",
                       "PseudoVMMATCH_VS_" # vti.LMul.MX # "_" #
                       key.LMul.MX # "_E" # vti.SEW,
                       vti.Mask, vti.Vector, key.Vector, vti.Mask,
                       vti.Log2SEW, VR, vti.RegClass, key.RegClass>;
  }
}

multiclass VPatVMMATCHVX<VTypeInfo vti> {
  let Predicates = !listconcat([HasStdExtZvmatch],
                               GetVTypePredicates<vti>.Predicates) in
  defm : VPatBinaryM<"int_riscv_vmmatch_vx",
                     "PseudoVMMATCH_VX_" # vti.LMul.MX # "_E" # vti.SEW,
                     vti.Mask, vti.Vector, XLenVT, vti.Mask,
                     vti.Log2SEW, VR, vti.RegClass, GPR>;
}

foreach vti = AllZvmatchVectors in {
  defm : VPatVMMATCHVS<vti>;
  defm : VPatVMMATCHVX<vti>;
}
