//===-- RISCVInstrInfoZvmedia.td - 'Zvmedia' instructions --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for 'Zvmedia' (RVV extensions
/// for media scenarios like video/audio).
///
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZvmedia] in {
defm VABD_V    : VALU_IV_V_X_I<"vabd", 0b110110>;
defm VABDU_V   : VALU_IV_V_X_I<"vabdu", 0b110111, uimm5>;
defm VABDA_V   : VALU_IV_V_X<"vabda", 0b111000>;
defm VABDAU_V  : VALU_IV_V_X<"vabdau", 0b111001>;

let Constraints = "@earlyclobber $vd" in {
let RVVConstraint = WidenV in {
// Available funct6: 0x11/0x13/0x15/0x16/0x39
defm VWABD_V   : VALU_MV_V_X<"vwabd", 0b010001, "v">;
defm VWABDU_V  : VALU_MV_V_X<"vwabdu", 0b010011, "v">;
defm VWABDA_V  : VALU_MV_V_X<"vwabda", 0b010101, "v">;
defm VWABDAU_V : VALU_MV_V_X<"vwabdau", 0b010110, "v">;
} // RVVConstraint = WidenV
} // Constraints = "@earlyclobber $vd"

// vtrn.vv vd, vs2, vs1
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def VTRN_VV : VALUVVNoVm<0b111010, OPIVV, "vtrn.vv"> {
  let RVVConstraint = RISCVVConstraint<!or(VS2Constraint.Value,
                                           VS1Constraint.Value)>;
  let vm = 1; // Unmasked
}

} // Predicates = [HasStdExtZvmedia]
