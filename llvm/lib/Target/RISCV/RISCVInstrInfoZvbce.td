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
