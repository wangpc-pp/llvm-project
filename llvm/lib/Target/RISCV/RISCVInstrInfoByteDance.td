//===- RISCVInstrInfoByteDance.td - ByteDance instructions -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for ByteDance extensions.
///
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
class IndexLoadCommon<bits<3> type, bits<2> width, bit isUnsigned,
                      dag outs, dag ins,
                      string opcodestr, string format>
    : RVInstI<0b111, OPC_LOAD, outs, ins, opcodestr, format> {
  let Inst{31-30} = width;
  let Inst{29} = isUnsigned;
  let Inst{28} = 0b0;
  let Inst{27-25} = type;
}
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class IndexStoreCommon<bits<3> type, bits<2> width, 
                       dag outs, dag ins,
                       string opcodestr, string format>
    : RVInstS<0b111, OPC_STORE, outs, ins, opcodestr, format> {
  let Inst{31-30} = width;
  let Inst{29-28} = 0b00;
  let Inst{27-25} = type;
}
}

// include "RISCVInstrInfoZflsx.td"
include "RISCVInstrInfoZilsx.td"
include "RISCVInstrInfoZilsi.td"
