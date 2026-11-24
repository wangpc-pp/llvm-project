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

def ZibsMask : IntImmLeaf<XLenVT, [{ return Imm.isPowerOf2(); }]>;
def ZibsBitIndex : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(N->getAPIntValue().logBase2(), SDLoc(N),
                                   Subtarget->getXLenVT());
}]>;

def ZibsCond : PatLeaf<(cond), [{
  return ISD::isIntEqualitySetCC(N->get());
}]>;

multiclass ZibsSelect<DAGOperand RC, ValueType VT> {
  let usesCustomInserter = 1 in
  def _Using_CC_UImmLog2XLen_Zibs
      : Pseudo<(outs RC:$dst),
               (ins GPR:$lhs, uimmlog2xlen:$shamt, uimm1:$cc,
                    RC:$truev, RC:$falsev), []>;

  def : Pat<(riscv_selectcc (and (XLenVT GPR:$lhs), ZibsMask:$mask), 0,
                            ZibsCond:$cc, (VT RC:$truev), RC:$falsev),
            (!cast<Instruction>(NAME#"_Using_CC_UImmLog2XLen_Zibs")
                GPR:$lhs, (ZibsBitIndex ZibsMask:$mask), (CCtoRISCVCC $cc),
                RC:$truev, RC:$falsev)>;
}

let Predicates = [HasStdExtZibs] in {
  def : Pat<(riscv_brcc (and (XLenVT GPR:$rs1), ZibsMask:$mask), 0,
                         SETEQ, bb:$imm12),
            (BBCLRI GPR:$rs1, (ZibsBitIndex ZibsMask:$mask),
                    bare_simm13_lsb0_bb:$imm12)>;
  def : Pat<(riscv_brcc (and (XLenVT GPR:$rs1), ZibsMask:$mask), 0,
                         SETNE, bb:$imm12),
            (BBSETI GPR:$rs1, (ZibsBitIndex ZibsMask:$mask),
                    bare_simm13_lsb0_bb:$imm12)>;

  defm Select_GPR : ZibsSelect<GPR, XLenVT>;
}

let Predicates = [HasStdExtZibs, HasStdExtF] in
defm Select_FPR32 : ZibsSelect<FPR32, f32>;
let Predicates = [HasStdExtZibs, HasStdExtD] in
defm Select_FPR64 : ZibsSelect<FPR64, f64>;
let Predicates = [HasStdExtZibs, HasStdExtZfhmin] in
defm Select_FPR16 : ZibsSelect<FPR16, f16>;
let Predicates = [HasStdExtZibs, HasStdExtZfinx] in
defm Select_FPR32INX : ZibsSelect<FPR32INX, f32>;
let Predicates = [HasStdExtZibs, HasStdExtZdinx, IsRV64] in
defm Select_FPR64INX : ZibsSelect<FPR64INX, f64>;
let Predicates = [HasStdExtZibs, HasStdExtZdinx, IsRV32] in
defm Select_FPR64IN32X : ZibsSelect<FPR64IN32X, f64>;
let Predicates = [HasStdExtZibs, HasStdExtZhinxmin] in
defm Select_FPR16INX : ZibsSelect<FPR16INX, f16>;
