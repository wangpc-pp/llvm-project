//===-- RISCVInstrInfoZimemops.td - RISC-V Zimemops extension -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

let Predicates = [HasStdExtZimemops], hasSideEffects = 0,
    mayLoad = 1, mayStore = 1 in {
class MemCopy<bits<7> funct7, string opcodestr>
    : RVInstR<funct7, 0b011, OPC_MISC_MEM,
              (outs GPRNoX0:$rd_wb, GPRNoX0:$rs1_wb, GPRNoX0:$rs2_wb),
              (ins GPRNoX0:$rd, GPRNoX0:$rs1, GPRNoX0:$rs2),
              opcodestr, "(${rd}), (${rs1}), $rs2"> {
  let Constraints = "@earlyclobber $rd_wb,@earlyclobber $rs1_wb,"
                    "@earlyclobber $rs2_wb, $rd = $rd_wb, "
                    "$rs1 = $rs1_wb, $rs2 = $rs2_wb";
}

def MCOPY : MemCopy<0b0000000, "mcopy">, Sched<[]>;
def MMOVE : MemCopy<0b0000011, "mmove">, Sched<[]>;
} // Predicates = [HasStdExtZimemops], hasSideEffects = 0,
  // mayLoad = 1, mayStore = 1

let Predicates = [HasStdExtZimemops], hasSideEffects = 0,
    mayLoad = 0, mayStore = 1 in
def MSET : RVInstR<0b0000110, 0b011, OPC_MISC_MEM,
                  (outs GPRNoX0:$rd_wb, GPRNoX0:$rs2_wb),
                  (ins GPRNoX0:$rd, GPR:$rs1, GPRNoX0:$rs2),
                  "mset", "(${rd}), $rs1, $rs2">, Sched<[]> {
  let Constraints = "@earlyclobber $rd_wb,@earlyclobber $rs2_wb, "
                    "$rd = $rd_wb, $rs2 = $rs2_wb";
}
