//===-- RISCVInstrInfoZvabd.td - 'Zvabd' instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for 'Zvabd' (Vector Absolute
/// Difference).
///
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction Definitions
//===----------------------------------------------------------------------===//
let Predicates = [HasStdExtZvabd] in {
  defm VABD_V : VAALU_MV_V_X<"vabd", 0b010001>;
  defm VABDU_V : VAALU_MV_V_X<"vabdu", 0b010011>;

  let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV in {
    defm VWABDACC_V : VALU_MV_V_X<"vwabdacc", 0b010101, "v">;
    defm VWABDACCU_V : VALU_MV_V_X<"vwabdaccu", 0b010110, "v">;
  } // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV
} // Predicates = [HasStdExtZvabd]
