//===-- RISCVInstrInfoZilsx.td - 'Zilsx' instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for 'Zilsx' (Index Load/Store
/// for Integer).
///
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
class IndexLoadI<bits<3> funct3, string opcodestr>
    : RVInstI<0b111, OPC_LOAD, (outs GPR:$rd),
              (ins GPRMemZeroOffset:$rs1, GPR:$rs2, uimm2:$scale),
              opcodestr, "$rd, $rs1, $rs2, $scale"> {
  bits<5> rs2;
  bits<2> scale;

  let Inst{31-30} = scale;
  let Inst{29-27} = funct3;
  let Inst{26-25} = 0b11;
  let Inst{24-20} = rs2;
}
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class IndexStoreI<bits<3> funct3, string opcodestr>
    : RVInstS<0b111, OPC_STORE, (outs),
              (ins GPR:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, uimm2:$scale),
              opcodestr, "$rs3, $rs1, $rs2, $scale"> {
  bits<5> rs3;
  bits<2> scale;

  let Inst{31-30} = scale;
  let Inst{29-27} = funct3;
  let Inst{26-25} = 0b11;
  let Inst{11-7} = rs3;
}
}

let Predicates = [HasStdExtZilsx] in {
def LXB  : IndexLoadI<0b000, "lxb">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXBU : IndexLoadI<0b001, "lxbu">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXH  : IndexLoadI<0b010, "lxh">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXHU : IndexLoadI<0b011, "lxhu">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXW  : IndexLoadI<0b100, "lxw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;

def SXB  : IndexStoreI<0b000, "sxb">, Sched<[WriteSTB, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXH  : IndexStoreI<0b001, "sxh">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXW  : IndexStoreI<0b010, "sxw">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;

def : InstAlias<"lxb $rd, $rs1, $rs2", (LXB GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"lxbu $rd, $rs1, $rs2", (LXBU GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"lxh $rd, $rs1, $rs2", (LXH GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"lxhu $rd, $rs1, $rs2", (LXHU GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"lxw $rd, $rs1, $rs2", (LXW GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;

def : InstAlias<"sxb $rs3, $rs1, $rs2", (SXB GPR:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"sxh $rs3, $rs1, $rs2", (SXH GPR:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"sxw $rs3, $rs1, $rs2", (SXW GPR:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
} // Predicates = [HasStdExtZilsx]

let Predicates = [HasStdExtZilsx, IsRV64] in {
def LXWU : IndexLoadI<0b101, "lxwu">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXD  : IndexLoadI<0b110, "lxd">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
def SXD  : IndexStoreI<0b011, "sxd">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;

def : InstAlias<"lxwu $rd, $rs1, $rs2", (LXWU GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"lxd $rd, $rs1, $rs2", (LXD GPR:$rd, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
def : InstAlias<"sxd $rs3, $rs1, $rs2", (SXD GPR:$rs3, GPRMemZeroOffset:$rs1, GPR:$rs2, 0)>;
} // Predicates = [HasStdExtZilsx, IsRV64]
