//===-- RISCVInstrInfoZvbec.td - 'Zvbec' instructions ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the experimental 'Zvbec' (Vector Bit Expansion and
// Compression) extension.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvbec], ElementsDependOn = EltDepsNone in {
  defm VBCOMPRESS_V : VALU_IV_V_X<"vbcompress", 0b110010>;
  defm VBEXPAND_V   : VALU_IV_V_X<"vbexpand", 0b110011>;
} // Predicates = [HasStdExtZvbec], ElementsDependOn = EltDepsNone

//===----------------------------------------------------------------------===//
// Pseudos
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvbec] in {
  defm PseudoVBCOMPRESS : VPseudoVALU_VV_VX;
  defm PseudoVBEXPAND   : VPseudoVALU_VV_VX;
} // Predicates = [HasStdExtZvbec]

//===----------------------------------------------------------------------===//
// CodeGen patterns
//===----------------------------------------------------------------------===//

let HasPassthruOp = true, HasMaskOp = true in {
  def riscv_pext_vl : RVSDNode<"PEXT_VL", SDT_RISCVIntBinOp_VL>;
  def riscv_pdep_vl : RVSDNode<"PDEP_VL", SDT_RISCVIntBinOp_VL>;
} // HasPassthruOp = true, HasMaskOp = true

defvar Zvbec32Vectors =
    !filter(vti, AllIntegerVectors, !le(vti.SEW, 32));
defvar Zvbec64Vectors =
    !filter(vti, AllIntegerVectors, !eq(vti.SEW, 64));

defm : VPatBinarySDNode_VV_VX<pext, "PseudoVBCOMPRESS", Zvbec32Vectors,
                              ExtraPreds = [HasStdExtZvbec]>;
defm : VPatBinarySDNode_VV_VX<pdep, "PseudoVBEXPAND", Zvbec32Vectors,
                              ExtraPreds = [HasStdExtZvbec]>;
defm : VPatBinarySDNode_VV_VX<pext, "PseudoVBCOMPRESS", Zvbec64Vectors,
                              ExtraPreds = [HasStdExtZvbec,
                                            HasVInstructionsI64]>;
defm : VPatBinarySDNode_VV_VX<pdep, "PseudoVBEXPAND", Zvbec64Vectors,
                              ExtraPreds = [HasStdExtZvbec,
                                            HasVInstructionsI64]>;

defm : VPatBinaryVL_VV_VX<riscv_pext_vl, "PseudoVBCOMPRESS",
                          Zvbec32Vectors,
                          ExtraPreds = [HasStdExtZvbec]>;
defm : VPatBinaryVL_VV_VX<riscv_pdep_vl, "PseudoVBEXPAND",
                          Zvbec32Vectors,
                          ExtraPreds = [HasStdExtZvbec]>;
defm : VPatBinaryVL_VV_VX<riscv_pext_vl, "PseudoVBCOMPRESS",
                          Zvbec64Vectors,
                          ExtraPreds = [HasStdExtZvbec,
                                        HasVInstructionsI64]>;
defm : VPatBinaryVL_VV_VX<riscv_pdep_vl, "PseudoVBEXPAND",
                          Zvbec64Vectors,
                          ExtraPreds = [HasStdExtZvbec,
                                        HasVInstructionsI64]>;
