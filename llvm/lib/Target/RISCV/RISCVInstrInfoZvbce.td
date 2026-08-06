//===-- RISCVInstrInfoZvbce.td - 'Zvbce' instructions ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the experimental 'Zvbce' vector bit compress and
// expand extension.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvbce], ElementsDependOn = EltDepsNone in {
  defm VBCOMPRESS_V : VALU_IV_V_X<"vbcompress", 0b110010>;
  defm VBEXPAND_V   : VALU_IV_V_X<"vbexpand", 0b110011>;
} // Predicates = [HasStdExtZvbce], ElementsDependOn = EltDepsNone

//===----------------------------------------------------------------------===//
// Pseudos
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvbce] in {
  defm PseudoVBCOMPRESS : VPseudoVALU_VV_VX;
  defm PseudoVBEXPAND   : VPseudoVALU_VV_VX;
} // Predicates = [HasStdExtZvbce]

//===----------------------------------------------------------------------===//
// CodeGen patterns
//===----------------------------------------------------------------------===//

let HasPassthruOp = true, HasMaskOp = true in {
  def riscv_pext_vl : RVSDNode<"PEXT_VL", SDT_RISCVIntBinOp_VL>;
  def riscv_pdep_vl : RVSDNode<"PDEP_VL", SDT_RISCVIntBinOp_VL>;
} // HasPassthruOp = true, HasMaskOp = true

defvar Zvbce32Vectors =
    !filter(vti, AllIntegerVectors, !le(vti.SEW, 32));
defvar Zvbce64Vectors =
    !filter(vti, AllIntegerVectors, !eq(vti.SEW, 64));

defm : VPatBinarySDNode_VV_VX<pext, "PseudoVBCOMPRESS", Zvbce32Vectors,
                              ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinarySDNode_VV_VX<pdep, "PseudoVBEXPAND", Zvbce32Vectors,
                              ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinarySDNode_VV_VX<pext, "PseudoVBCOMPRESS", Zvbce64Vectors,
                              ExtraPreds = [HasStdExtZvbce,
                                            HasVInstructionsI64]>;
defm : VPatBinarySDNode_VV_VX<pdep, "PseudoVBEXPAND", Zvbce64Vectors,
                              ExtraPreds = [HasStdExtZvbce,
                                            HasVInstructionsI64]>;

defm : VPatBinaryVL_VV_VX<riscv_pext_vl, "PseudoVBCOMPRESS",
                          Zvbce32Vectors,
                          ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinaryVL_VV_VX<riscv_pdep_vl, "PseudoVBEXPAND",
                          Zvbce32Vectors,
                          ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinaryVL_VV_VX<riscv_pext_vl, "PseudoVBCOMPRESS",
                          Zvbce64Vectors,
                          ExtraPreds = [HasStdExtZvbce,
                                        HasVInstructionsI64]>;
defm : VPatBinaryVL_VV_VX<riscv_pdep_vl, "PseudoVBEXPAND",
                          Zvbce64Vectors,
                          ExtraPreds = [HasStdExtZvbce,
                                        HasVInstructionsI64]>;

defm : VPatBinaryV_VV_VX<"int_riscv_vbcompress", "PseudoVBCOMPRESS",
                         Zvbce32Vectors, ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinaryV_VV_VX<"int_riscv_vbexpand", "PseudoVBEXPAND",
                         Zvbce32Vectors, ExtraPreds = [HasStdExtZvbce]>;
defm : VPatBinaryV_VV_VX<"int_riscv_vbcompress", "PseudoVBCOMPRESS",
                         Zvbce64Vectors,
                         ExtraPreds = [HasStdExtZvbce,
                                       HasVInstructionsI64]>;
defm : VPatBinaryV_VV_VX<"int_riscv_vbexpand", "PseudoVBEXPAND",
                         Zvbce64Vectors,
                         ExtraPreds = [HasStdExtZvbce,
                                       HasVInstructionsI64]>;
