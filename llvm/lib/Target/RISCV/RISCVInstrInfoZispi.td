//===-- RISCVInstrInfoZispi.td - 'Zispi' instructions -----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for the experimental 'Zispi'
/// (Unit-Stride Post-Increment Integer Stores) extension.
///
//===----------------------------------------------------------------------===//

// Zispi uses an encoding reserved by the Zilx 0.1 draft in the AMO major
// opcode. The base register occupies both rs1 and rd because the architectural
// destination is the post-incremented base. rs2 contains the value to store.
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
class ZispiStore<bits<3> funct3, string opcodestr>
    : RVInst<(outs GPRNoX0:$rs1_wb), (ins GPR:$rs2, GPRNoX0:$rs1),
             opcodestr, "$rs2, (${rs1})", [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;

  let Inst{31-27} = 0b10110;
  let Inst{26-25} = 0b00;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rs1;
  let Inst{6-0} = OPC_AMO.Value;
  let Constraints = "$rs1_wb = $rs1";
}

let Predicates = [HasStdExtZispi] in {
def SPI_B : ZispiStore<0b000, "spi.b">,
            Sched<[WriteSTB, ReadStoreData, ReadMemBase]>;
def SPI_H : ZispiStore<0b001, "spi.h">,
            Sched<[WriteSTH, ReadStoreData, ReadMemBase]>;
def SPI_W : ZispiStore<0b010, "spi.w">,
            Sched<[WriteSTW, ReadStoreData, ReadMemBase]>;
}

let Predicates = [HasStdExtZispi, IsRV64] in
def SPI_D : ZispiStore<0b011, "spi.d">,
            Sched<[WriteSTD, ReadStoreData, ReadMemBase]>;

class ZispiStorePat<PatFrag StoreOp, Instruction Inst, int Increment,
                    ValueType VT = XLenVT>
    : Pat<(StoreOp (VT GPR:$rs2), GPRNoX0:$rs1, Increment),
          (Inst GPR:$rs2, GPRNoX0:$rs1)>;

let Predicates = [HasStdExtZispi] in {
def : ZispiStorePat<post_truncsti8, SPI_B, 1>;
def : ZispiStorePat<post_truncsti16, SPI_H, 2>;
def : ZispiStorePat<post_store, SPI_W, 4, i32>;
}

let Predicates = [HasStdExtZispi, IsRV64] in {
def : ZispiStorePat<post_truncsti32, SPI_W, 4, i64>;
def : ZispiStorePat<post_store, SPI_D, 8, i64>;
}
