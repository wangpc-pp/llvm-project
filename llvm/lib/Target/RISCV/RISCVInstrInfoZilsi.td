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
class PreIncLoad<bits<2> width, bit isUnsigned, string opcodestr>
    : IndexLoadCommon<0b000, width, isUnsigned, (outs GPR:$rd, GPR:$rs1_wb),
                      (ins GPRMemZeroOffset:$rs1, simm5:$inc),
                      opcodestr, "$rd, $rs1, $inc"> {
  bits<5> inc;

  let Inst{24-20} = inc;
  let Constraints = "@earlyclobber $rd, $rs1_wb = $rs1";
}

class PostIncLoad<bits<2> width, bit isUnsigned, string opcodestr>
    : IndexLoadCommon<0b001, width, isUnsigned, (outs GPR:$rd, GPR:$rs1_wb),
                      (ins GPRMemZeroOffset:$rs1, simm5:$inc),
                      opcodestr, "$rd, $rs1, $inc"> {
  bits<5> inc;

  let Inst{24-20} = inc;
  let Constraints = "@earlyclobber $rd, $rs1_wb = $rs1";
}
} // hasSideEffects = 0, mayLoad = 1, mayStore = 0

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class PreIncStore<bits<2> width, string opcodestr>
    : IndexStoreCommon<0b000, width, (outs GPR:$rs1_up),
                       (ins GPR:$rs2, GPRMemZeroOffset:$rs1, simm5:$inc),
                       opcodestr, "$rs2, $rs1, $inc"> {
  bits<5> inc;

  let Inst{11-7} = inc;
  let Constraints = "$rs1_up = $rs1";
}

class PostIncStore<bits<2> width, string opcodestr>
    : IndexStoreCommon<0b001, width, (outs GPR:$rs1_up),
                       (ins GPR:$rs2, GPRMemZeroOffset:$rs1, simm5:$inc),
                       opcodestr, "$rs2, $rs1, $inc"> {
  bits<5> inc;

  let Inst{11-7} = inc;
  let Constraints = "$rs1_up = $rs1";
}
} // hasSideEffects = 0, mayLoad = 0, mayStore = 1

let Predicates = [HasStdExtZilxib] in {
def LBIB     : PreIncLoad<0b00, 0, "lbib">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LBUIB    : PreIncLoad<0b00, 1, "lbuib">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LHIB     : PreIncLoad<0b01, 0, "lhib">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LHUIB    : PreIncLoad<0b01, 1, "lhuib">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LWIB     : PreIncLoad<0b10, 0, "lwib">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilxib]

let Predicates = [HasStdExtZilxib, IsRV64] in {
def LWUIB    : PreIncLoad<0b10, 1, "lwuib">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LDIB     : PreIncLoad<0b11, 0, "ldib">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilxib, IsRV64]

let Predicates = [HasStdExtZisxib] in {
def SBIB    : PreIncStore<0b00, "sbib">, Sched<[WriteSTB, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SHIB    : PreIncStore<0b01, "shib">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SWIB    : PreIncStore<0b10, "swib">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisxib]

let Predicates = [HasStdExtZisxib, IsRV64] in {
def SDIB    : PreIncStore<0b11, "sdib">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisxib, IsRV64]

let Predicates = [HasStdExtZilxia] in {
def LBIA     : PostIncLoad<0b00, 0, "lbia">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LBUIA    : PostIncLoad<0b00, 1, "lbuia">, Sched<[WriteLDB, ReadMemBase, ReadMemBase]>;
def LHIA     : PostIncLoad<0b01, 0, "lhia">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LHUIA    : PostIncLoad<0b01, 1, "lhuia">, Sched<[WriteLDH, ReadMemBase, ReadMemBase]>;
def LWIA     : PostIncLoad<0b10, 0, "lwia">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilxia]

let Predicates = [HasStdExtZilxia, IsRV64] in {
def LWUIA    : PostIncLoad<0b10, 1, "lwuia">, Sched<[WriteLDW, ReadMemBase, ReadMemBase]>;
def LDIA     : PostIncLoad<0b11, 0, "ldia">, Sched<[WriteLDD, ReadMemBase, ReadMemBase]>;
} // Predicates = [HasStdExtZilxia, IsRV64]

let Predicates = [HasStdExtZisxia] in {
def SBIA    : PostIncStore<0b00, "sbia">, Sched<[WriteSTB, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SHIA    : PostIncStore<0b01, "shia">, Sched<[WriteSTH, ReadStoreData, ReadStoreData, ReadMemBase]>;
def SWIA    : PostIncStore<0b10, "swia">, Sched<[WriteSTW, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisxia]

let Predicates = [HasStdExtZisxia, IsRV64] in {
def SDIA    : PostIncStore<0b11, "sdia">, Sched<[WriteSTD, ReadStoreData, ReadStoreData, ReadMemBase]>;
} // Predicates = [HasStdExtZisxia, IsRV64]

class Simm5Pattern<int width> : ComplexPattern<XLenVT, 1, "selectSimm5<"#width#">">;
def simm5width0 : Simm5Pattern<0>;
def simm5width1 : Simm5Pattern<1>;
def simm5width2 : Simm5Pattern<2>;
def simm5width3 : Simm5Pattern<3>;

class StoreIncPat<PatFrag st, Instruction Inst, int width, ValueType vt = XLenVT>
    : Pat<(st (vt GPR:$rd), GPR:$rs1, (!cast<Simm5Pattern>("simm5width" # width) simm5:$simm5)),
          (Inst GPR:$rd, GPR:$rs1, simm5:$simm5)>;

let Predicates = [HasStdExtZisxib] in {
def : StoreIncPat<pre_truncsti8, SBIB, 0>;
def : StoreIncPat<pre_truncsti16, SHIB, 1>;
def : StoreIncPat<pre_store, SWIB, 2, i32>;
} // Predicates = [HasStdExtZisxib]

let Predicates = [HasStdExtZisxib, IsRV64] in {
def : StoreIncPat<pre_truncsti32, SWIB, 2, i64>;
def : StoreIncPat<pre_store, SDIB, 3, i64>;
} // Predicates = [HasStdExtZisxib, IsRV64]

let Predicates = [HasStdExtZisxia] in {
def : StoreIncPat<post_truncsti8, SBIA, 0>;
def : StoreIncPat<post_truncsti16, SHIA, 1>;
def : StoreIncPat<post_store, SWIA, 2, i32>;
} // Predicates = [HasStdExtZisxia]

let Predicates = [HasStdExtZisxia, IsRV64] in {
def : StoreIncPat<post_truncsti32, SWIA, 2, i64>;
def : StoreIncPat<post_store, SDIA, 3, i64>;
} // Predicates = [HasStdExtZisxia, IsRV64]
