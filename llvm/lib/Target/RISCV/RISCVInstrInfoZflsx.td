//===-- RISCVInstrInfoZflsx.td - 'Zflsx' instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for 'Zflsx' (Index Load/Store
/// for Floating-Point).
///
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
class IndexLoadF<bits<2> funct2, string opcodestr, DAGOperand rty>
    : RVInstI<0b110, OPC_LOAD_FP, (outs rty:$rd),
              (ins GPRMemZeroOffset:$rs1, GPR:$rs2, uimm3:$scale),
              opcodestr, "$rd, $rs1, $rs2, $scale"> {
  bits<5> rs2;
  bits<3> scale;

  let Inst{31-29} = scale;
  let Inst{28} = 0b1;
  let Inst{27-26} = funct2;
  let Inst{25} = 0b0;
  let Inst{24-20} = rs2;
}
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class IndexStoreF<bits<2> funct2, string opcodestr, DAGOperand rty>
    : RVInstS<0b110, OPC_STORE_FP, (outs),
              (ins rty:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, uimm3:$scale),
              opcodestr, "$rs3, $rs1, $rs2, $scale"> {
  bits<5> rs3;
  bits<3> scale;

  let Inst{31-29} = scale;
  let Inst{28} = 0b1;
  let Inst{27-26} = funct2;
  let Inst{25} = 0b0;
  let Inst{11-7} = rs3;
}
}

let Predicates = [HasStdExtZflsx, HasStdExtZfhmin] in {
def FLXH  : IndexLoadF<0b00, "flxh", FPR16>, Sched<[WriteFLD16, ReadMemBase, ReadMemBase]>;
def FSXH  : IndexStoreF<0b00, "fsxh", FPR16>, Sched<[WriteFST16, ReadStoreData, ReadStoreData, ReadMemBase]>;
def : InstAlias<"flxh $rd, $rs1, $rs2", (FLXH FPR16:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"fsxh $rs3, $rs1, $rs2", (FSXH FPR16:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
} // Predicates = [HasStdExtZflsx, HasStdExtZfhmin]

let Predicates = [HasStdExtZflsx, HasStdExtF] in {
def FLXW  : IndexLoadF<0b01, "flxw", FPR32>, Sched<[WriteFLD32, ReadMemBase, ReadMemBase]>;
def FSXW  : IndexStoreF<0b01, "fsxw", FPR32>, Sched<[WriteFST32, ReadStoreData, ReadStoreData, ReadMemBase]>;
def : InstAlias<"flxw $rd, $rs1, $rs2", (FLXW FPR32:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"fsxw $rs3, $rs1, $rs2", (FSXW FPR32:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
} // Predicates = [HasStdExtZflsx, HasStdExtF]

let Predicates = [HasStdExtZflsx, HasStdExtD] in {
def FLXD  : IndexLoadF<0b10, "flxd", FPR64>, Sched<[WriteFLD64, ReadMemBase, ReadMemBase]>;
def FSXD  : IndexStoreF<0b10, "fsxd", FPR64>, Sched<[WriteFST64, ReadStoreData, ReadStoreData, ReadMemBase]>;
def : InstAlias<"flxd $rd, $rs1, $rs2", (FLXD FPR64:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"fsxd $rs3, $rs1, $rs2", (FSXD FPR64:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
} // Predicates = [HasStdExtZflsx, HasStdExtD]


// Patterns
// We reuse Pattern classes defined in RISCVInstrInfoXTHead.td.
let Predicates = [HasStdExtZflsx, HasStdExtZfhmin] in {
defm : LdIdxPat<load, FLXH, f16>;
defm : StIdxPat<store, FSXH, FPR16, f16>;
} // Predicates = [HasStdExtZflsx, HasStdExtZfhmin]

let Predicates = [HasStdExtZflsx, HasStdExtF] in {
defm : LdIdxPat<load, FLXW, f32>;
defm : StIdxPat<store, FSXW, FPR32, f32>;
} // Predicates = [HasStdExtZflsx, HasStdExtF]

let Predicates = [HasStdExtZflsx, HasStdExtD] in {
defm : LdIdxPat<load, FLXD, f64>;
defm : StIdxPat<store, FSXD, FPR64, f64>;
} // Predicates = [HasStdExtZflsx, HasStdExtD]
