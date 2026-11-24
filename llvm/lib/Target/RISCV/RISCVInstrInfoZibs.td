//===-- RISCVInstrInfoZibs.td - 'Zibs' instructions --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the Zibs single-bit conditional branch instructions.
//
//===----------------------------------------------------------------------===//

class BranchBitImm<bit isSet, string opcodestr>
    : RVInst<(outs),
             (ins GPR:$rs1, uimmlog2xlen:$shamt, bare_simm13_lsb0:$imm12),
             opcodestr, "$rs1, $shamt, $imm12", [], InstFormatB>,
      Sched<[WriteJmp, ReadJmp]> {
  bits<12> imm12;
  bits<6> shamt;
  bits<5> rs1;

  let Inst{31} = imm12{11};
  let Inst{30-25} = imm12{9-4};
  let Inst{24-20} = shamt{4-0};
  let Inst{19-15} = rs1;
  let Inst{14} = 1;
  let Inst{13} = shamt{5};
  let Inst{12} = isSet;
  let Inst{11-8} = imm12{3-0};
  let Inst{7} = imm12{10};
  let Inst{6-0} = OPC_JALR.Value;

  let isBranch = 1;
  let isTerminator = 1;
  let hasSideEffects = 0;
  let mayLoad = 0;
  let mayStore = 0;
}

let Predicates = [HasStdExtZibs] in {
  def BBCLRI : BranchBitImm<0, "bbclri">;
  def BBSETI : BranchBitImm<1, "bbseti">;

  // Expanded by MC relaxation into an inverted branch followed by JAL.
  def PseudoLongBBCLRI : LongBcciPseudo<uimmlog2xlen, 8>;
  def PseudoLongBBSETI : LongBcciPseudo<uimmlog2xlen, 8>;
}
