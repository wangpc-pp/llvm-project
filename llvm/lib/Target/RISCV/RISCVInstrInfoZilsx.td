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
class UnscaledIndexLoad<bits<3> type, bits<2> width, bit isUnsigned, string opcodestr>
    : IndexLoadCommon<type, width, isUnsigned, (outs GPR:$rd),
                      (ins GPRMemZeroOffset:$rs1, GPR:$rs2),
                      opcodestr, "$rd, $rs1, $rs2"> {
  bits<5> rs2;

  let Inst{24-20} = rs2;
}

class ScaledIndexLoad<bits<3> type, bits<2> width, bit isUnsigned, string opcodestr>
    : IndexLoadCommon<type, width, isUnsigned, (outs GPR:$rd),
                      (ins GPRMemZeroOffset:$rs1, GPR:$rs2),
                      opcodestr, "$rd, $rs1, $rs2"> {
  bits<5> rs2;

  let Inst{24-20} = rs2;
}
} // hasSideEffects = 0, mayLoad = 1, mayStore = 0

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class UnscaledIndexStore<bits<3> type, bits<2> width, string opcodestr>
    : IndexStoreCommon<type, width, (outs),
                       (ins GPR:$rs2, GPRMemZeroOffset:$rs1, GPR:$rs3),
                       opcodestr, "$rs2, $rs1, $rs3"> {
  bits<5> rs3;

  let Inst{11-7} = rs3;
}

class ScaledIndexStore<bits<3> type, bits<2> width, string opcodestr>
    : IndexStoreCommon<type, width, (outs),
                       (ins GPR:$rs2, GPRMemZeroOffset:$rs1, GPR:$rs3),
                       opcodestr, "$rs2, $rs1, $rs3"> {
  bits<5> rs3;

  let Inst{11-7} = rs3;
}
} // hasSideEffects = 0, mayLoad = 0, mayStore = 1

let Predicates = [HasStdExtZilx] in {
def LXB     : UnscaledIndexLoad<0b010, 0b00, 0, "lxb">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXB_UW  : UnscaledIndexLoad<0b011, 0b00, 0, "lxb.uw">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXBU    : UnscaledIndexLoad<0b010, 0b00, 1, "lxbu">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXBU_UW : UnscaledIndexLoad<0b011, 0b00, 1, "lxbu.uw">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LXH     : UnscaledIndexLoad<0b010, 0b01, 0, "lxh">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXH_UW  : UnscaledIndexLoad<0b011, 0b01, 0, "lxh.uw">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXHU    : UnscaledIndexLoad<0b010, 0b01, 1, "lxhu">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXHU_UW : UnscaledIndexLoad<0b011, 0b01, 1, "lxhu.uw">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXW     : UnscaledIndexLoad<0b010, 0b10, 0, "lxw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXW_UW  : UnscaledIndexLoad<0b011, 0b10, 0, "lxw.uw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;

def LXH_S     : ScaledIndexLoad<0b100, 0b01, 0,  "lxh.s">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXH_S_UW  : ScaledIndexLoad<0b101, 0b01, 0,  "lxh.s.uw">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXHU_S    : ScaledIndexLoad<0b100, 0b01, 1,  "lxhu.s">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXHU_S_UW : ScaledIndexLoad<0b101, 0b01, 1,  "lxhu.s.uw">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LXW_S     : ScaledIndexLoad<0b100, 0b10, 0,  "lxw.s">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXW_S_UW  : ScaledIndexLoad<0b101, 0b10, 0,  "lxw.s.uw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilx]

let Predicates = [HasStdExtZilx, IsRV64] in {
def LXWU    : UnscaledIndexLoad<0b010, 0b10, 1, "lxwu">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXWU_UW : UnscaledIndexLoad<0b011, 0b10, 1, "lxwu.uw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXD     : UnscaledIndexLoad<0b010, 0b11, 0, "lxd">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
def LXD_UW  : UnscaledIndexLoad<0b011, 0b11, 0, "lxd.uw">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;

def LXWU_S    : ScaledIndexLoad<0b100, 0b10, 1, "lxwu.s">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXWU_S_UW : ScaledIndexLoad<0b101, 0b10, 1, "lxwu.s.uw">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LXD_S     : ScaledIndexLoad<0b100, 0b11, 0, "lxd.s">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
def LXD_S_UW  : ScaledIndexLoad<0b101, 0b11, 0, "lxd.s.uw">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilsx, IsRV64]

let Predicates = [HasStdExtZisx] in {
def SXB    : UnscaledIndexStore<0b010, 0b00, "sxb">, Sched<[WriteSTB, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXB_UW : UnscaledIndexStore<0b011, 0b00, "sxb.uw">, Sched<[WriteSTB, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXH    : UnscaledIndexStore<0b010, 0b01, "sxh">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXH_UW : UnscaledIndexStore<0b011, 0b01, "sxh.uw">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXW    : UnscaledIndexStore<0b010, 0b10, "sxw">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXW_UW : UnscaledIndexStore<0b011, 0b10, "sxw.uw">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;

def SXH_S    : ScaledIndexStore<0b100, 0b01, "sxh.s">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXH_S_UW : ScaledIndexStore<0b101, 0b01, "sxh.s.uw">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXW_S    : ScaledIndexStore<0b100, 0b10, "sxw.s">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXW_S_UW : ScaledIndexStore<0b101, 0b10, "sxw.s.uw">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisx]

let Predicates = [HasStdExtZisx, IsRV64] in {
def SXD    : UnscaledIndexStore<0b010, 0b11, "sxd">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXD_UW : UnscaledIndexStore<0b011, 0b11, "sxd.uw">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;

def SXD_S    : ScaledIndexStore<0b100, 0b11, "sxd.s">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SXD_S_UW : ScaledIndexStore<0b101, 0b11, "sxd.s.uw">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisx, IsRV64]

def AddrRegReg0 : AddrRegReg<0>;
def AddrRegReg1 : AddrRegReg<1>;
def AddrRegReg2 : AddrRegReg<2>;
def AddrRegReg3 : AddrRegReg<3>;

def AddrRegZextReg0 : AddrRegZextReg<0>;
def AddrRegZextReg1 : AddrRegZextReg<1>;
def AddrRegZextReg2 : AddrRegZextReg<2>;
def AddrRegZextReg3 : AddrRegZextReg<3>;

let AddedComplexity = 2 in {
class UnscaledIndexLoadPat<PatFrag LoadOp, RVInst Inst, ValueType vt = XLenVT>
    : Pat<(vt (LoadOp (AddrRegReg0 (XLenVT GPR:$rs1), (XLenVT GPR:$rs2)))),
          (Inst GPR:$rs1, GPR:$rs2)>;

class UnscaledIndexStorePat<PatFrag StoreOp, RVInst Inst, RegisterClass StTy,
                            ValueType vt = XLenVT>
    : Pat<(StoreOp (vt StTy:$rd), (AddrRegReg0 (XLenVT GPR:$rs1), (XLenVT GPR:$rs2))),
          (Inst StTy:$rd, GPR:$rs1, GPR:$rs2)>;
} // AddedComplexity = 2

let AddedComplexity = 3 in {
class UnscaledZextIndexStorePat<PatFrag StoreOp, RVInst Inst, RegisterClass StTy,
                            ValueType vt = XLenVT>
    : Pat<(StoreOp (vt StTy:$rd), (AddrRegZextReg0 (XLenVT GPR:$rs1), (XLenVT GPR:$rs2))),
          (Inst StTy:$rd, GPR:$rs1, GPR:$rs2)>;

class UnscaledZextIndexLoadPat<PatFrag LoadOp, RVInst Inst, ValueType vt = XLenVT>
    : Pat<(vt (LoadOp (AddrRegZextReg0 (XLenVT GPR:$rs1), (XLenVT GPR:$rs2)))),
          (Inst GPR:$rs1, GPR:$rs2)>;
} // AddedComplexity = 3

let AddedComplexity = 4 in {
class ScaledIndexLoadPat<PatFrag LoadOp, RVInst Inst, int Scale, ValueType vt = XLenVT>
    : Pat<(vt (LoadOp (!cast<AddrRegReg>("AddrRegReg" # Scale)
                      (XLenVT GPR:$rs1), (XLenVT GPR:$rs2)))),
          (Inst GPR:$rs1, GPR:$rs2)>;

class ScaledIndexStorePat<PatFrag StoreOp, RVInst Inst, RegisterClass StTy,
                          int Scale, ValueType vt = XLenVT>
    : Pat<(StoreOp (vt StTy:$rd),
                   (!cast<AddrRegReg>("AddrRegReg" # Scale) (XLenVT GPR:$rs1), (XLenVT GPR:$rs2))),
          (Inst StTy:$rd, GPR:$rs1, GPR:$rs2)>;
} // AddedComplexity = 4

let AddedComplexity = 6 in {
class ScaledZextIndexLoadPat<PatFrag LoadOp, RVInst Inst, int Scale, ValueType vt = XLenVT>
    : Pat<(vt (LoadOp (!cast<AddrRegZextReg>("AddrRegZextReg" # Scale)
                      (XLenVT GPR:$rs1), (XLenVT GPR:$rs2)))),
          (Inst GPR:$rs1, GPR:$rs2)>;

class ScaledZextIndexStorePat<PatFrag StoreOp, RVInst Inst, RegisterClass StTy,
                              int Scale, ValueType vt = XLenVT>
    : Pat<(StoreOp (vt StTy:$rd),
                   (!cast<AddrRegZextReg>("AddrRegZextReg" # Scale) (XLenVT GPR:$rs1), (XLenVT GPR:$rs2))),
          (Inst StTy:$rd, GPR:$rs1, GPR:$rs2)>;
} // AddedComplexity = 6

// Patterns
let Predicates = [HasStdExtZilx] in {
def : UnscaledIndexLoadPat<extloadi8, LXB>;
def : UnscaledIndexLoadPat<sextloadi8, LXB>;
def : UnscaledIndexLoadPat<zextloadi8, LXBU>;

def : UnscaledIndexLoadPat<extloadi16, LXH>;
def : UnscaledIndexLoadPat<sextloadi16, LXH>;
def : UnscaledIndexLoadPat<zextloadi16, LXHU>;

def : UnscaledIndexLoadPat<load, LXW, i32>;

def : ScaledIndexLoadPat<extloadi16, LXH_S, 1>;
def : ScaledIndexLoadPat<sextloadi16, LXH_S, 1>;
def : ScaledIndexLoadPat<zextloadi16, LXHU_S, 1>;

def : ScaledIndexLoadPat<load, LXW_S, 2, i32>;
} // Predicates = [HasStdExtZilx]

let Predicates = [HasStdExtZilx, IsRV64] in {
def : UnscaledIndexLoadPat<extloadi32, LXW, i64>;
def : UnscaledIndexLoadPat<sextloadi32, LXW, i64>;
def : UnscaledIndexLoadPat<zextloadi32, LXWU, i64>;

def : UnscaledIndexLoadPat<load, LXD, i64>;

def : ScaledIndexLoadPat<extloadi32, LXW_S, 2, i64>;
def : ScaledIndexLoadPat<sextloadi32, LXW_S, 2, i64>;
def : ScaledIndexLoadPat<zextloadi32, LXWU_S, 2, i64>;

def : ScaledIndexLoadPat<load, LXD_S, 3, i64>;

def : UnscaledZextIndexLoadPat<extloadi8, LXB_UW>;
def : UnscaledZextIndexLoadPat<sextloadi8, LXB_UW>;
def : UnscaledZextIndexLoadPat<zextloadi8, LXBU_UW>;

def : UnscaledZextIndexLoadPat<extloadi16, LXH_UW>;
def : UnscaledZextIndexLoadPat<sextloadi16, LXH_UW>;
def : UnscaledZextIndexLoadPat<zextloadi16, LXHU_UW>;

def : UnscaledZextIndexLoadPat<load, LXW_UW, i32>;

def : UnscaledZextIndexLoadPat<extloadi32, LXW_UW>;
def : UnscaledZextIndexLoadPat<sextloadi32, LXW_UW>;
def : UnscaledZextIndexLoadPat<zextloadi32, LXWU_UW>;

def : UnscaledZextIndexLoadPat<load, LXD_UW>;

def : ScaledZextIndexLoadPat<extloadi16, LXH_S_UW, 1>;
def : ScaledZextIndexLoadPat<sextloadi16, LXH_S_UW, 1>;
def : ScaledZextIndexLoadPat<zextloadi16, LXHU_S_UW, 1>;

def : ScaledZextIndexLoadPat<load, LXW_S_UW, 2, i32>;

def : ScaledZextIndexLoadPat<extloadi32, LXW_S_UW, 2, i64>;
def : ScaledZextIndexLoadPat<sextloadi32, LXW_S_UW, 2, i64>;
def : ScaledZextIndexLoadPat<zextloadi32, LXWU_S_UW, 2, i64>;

def : ScaledZextIndexLoadPat<load, LXD_S_UW, 3, i64>;
} // Predicates = [HasStdExtZilx, IsRV64]

let Predicates = [HasStdExtZisx] in {
def : UnscaledIndexStorePat<truncstorei8, SXB, GPR>;
def : UnscaledIndexStorePat<truncstorei16, SXH, GPR>;
def : UnscaledIndexStorePat<store, SXW, GPR, i32>;

def : ScaledIndexStorePat<truncstorei16, SXH_S, GPR, 1>;
def : ScaledIndexStorePat<store, SXW_S, GPR, 2, i32>;
} // Predicates = [HasStdExtZisx]

let Predicates = [HasStdExtZisx, IsRV64] in {
def : UnscaledIndexStorePat<truncstorei32, SXW, GPR, i64>;
def : UnscaledIndexStorePat<store, SXD, GPR, i64>;

def : UnscaledZextIndexStorePat<truncstorei8, SXB_UW, GPR>;
def : UnscaledZextIndexStorePat<truncstorei16, SXH_UW, GPR>;
def : UnscaledZextIndexStorePat<truncstorei32, SXW_UW, GPR, i64>;
def : UnscaledZextIndexStorePat<store, SXD_UW, GPR, i64>;

def : ScaledIndexStorePat<truncstorei32, SXW_S, GPR, 2, i64>;
def : ScaledIndexStorePat<store, SXD_S, GPR, 3, i64>;

def : ScaledZextIndexStorePat<truncstorei16, SXH_S_UW, GPR, 1>;
def : ScaledZextIndexStorePat<truncstorei32, SXW_S_UW, GPR, 2, i64>;
def : ScaledZextIndexStorePat<store, SXD_S_UW, GPR, 3, i64>;
} // Predicates = [HasStdExtZisx, IsRV64]
