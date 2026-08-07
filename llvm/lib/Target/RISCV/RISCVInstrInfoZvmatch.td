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
  def VMMATCH_VV : VALUVV<0b110100, OPIVV, "vmmatch.vv">,
                   SchedBinaryMC<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV">;
  def VMMATCH_VX : VALUVX<0b110100, OPIVX, "vmmatch.vx">,
                   SchedBinaryMC<"WriteVICmpX", "ReadVICmpV", "ReadVICmpX">;
}

//===----------------------------------------------------------------------===//
// Pseudos
//===----------------------------------------------------------------------===//

defvar AllZvmatchVectors =
    !filter(vti, AllIntegerVectors, !le(vti.SEW, 16));

multiclass VPseudoVMMATCH_VV {
  foreach vti = AllZvmatchVectors in {
    let VLMul = vti.LMul.value, SEW = vti.SEW in {
      def "_VV_" # vti.LMul.MX # "_E" # vti.SEW :
        VPseudoBinaryNoMask<VR, vti.RegClass, vti.RegClass,
                            "@earlyclobber $rd",
                            TargetConstraintType = 2>,
        SchedBinary<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV",
                    vti.LMul.MX>;
      def "_VV_" # vti.LMul.MX # "_E" # vti.SEW # "_MASK" :
        VPseudoBinaryMOutMask<
            !if(!ge(vti.LMul.octuple, 16), VRNoV0, VR),
            GetVRegNoV0<vti.RegClass>.R, GetVRegNoV0<vti.RegClass>.R,
            "@earlyclobber $rd", TargetConstraintType = 2>,
        RISCVMaskedPseudo<MaskIdx = 3>,
        SchedBinary<"WriteVICmpV", "ReadVICmpV", "ReadVICmpV",
                    vti.LMul.MX>;
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
  defm PseudoVMMATCH : VPseudoVMMATCH_VV, VPseudoVMMATCH_VX;
}
