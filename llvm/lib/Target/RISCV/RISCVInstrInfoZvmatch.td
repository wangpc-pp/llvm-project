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
