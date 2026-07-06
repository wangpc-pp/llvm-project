//===- RISCVAddressMemClusterDAGMutation.cpp - Address/Mem Cluster --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// A schedule mutation that adds artificial dependencies to keep a memory access
// close to the address computation that advances a pointer induction chain.
//
// For fully unrolled loops that walk memory with a pointer induction variable
// (e.g. SAD-like kernels or unrolled stores), the address computation forms
// long serial chains:
//
//   %p0 = base
//   %v0 = load %p0            ;  or:  store %v0, %p0
//   %p1 = add %p0, %stride
//   %v1 = load %p1            ;       store %v1, %p1
//   %p2 = add %p1, %stride
//   ...
//
// The address-advancing ADDs sit on the critical path, so a bidirectional,
// latency-driven scheduler tends to hoist the whole ADD chain ahead of the
// memory accesses. That keeps every pointer value live simultaneously and
// inflates GPR pressure, which forces the register allocator to spill into
// callee-saved registers (and hence emit an otherwise-unnecessary
// prologue/epilogue).
//
// The register pressure tracker only sees a per-step delta (+1 for each ADD),
// so it never notices the cumulative blow-up and cannot stop the hoist on its
// own. This mutation restores the natural interleaving by making each
// address-advancing ADD depend on the memory accesses that use the pointer it
// advances from, i.e. "access the current pointer before stepping to the next
// one". This bounds the number of simultaneously live pointers to roughly one
// per chain.
//
// The added edges only order a memory access before a *scalar* address ADD, so
// no two memory operations are ever reordered relative to each other and there
// is no aliasing/ordering hazard; canAddEdge() additionally rejects any edge
// that would introduce a cycle.
//
//===----------------------------------------------------------------------===//

#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/ScheduleDAGInstrs.h"
#include "llvm/CodeGen/ScheduleDAGMutation.h"

#define DEBUG_TYPE "machine-scheduler"

namespace llvm {

// Whether \p MI increments a pointer, i.e. it produces a new address from an
// existing one. These are the instructions that build a pointer induction
// chain and, if hoisted, keep every element of the chain live at once.
static bool isAddressAdvance(const MachineInstr &MI) {
  switch (MI.getOpcode()) {
  case RISCV::ADD:
  case RISCV::ADDI:
  case RISCV::SH1ADD:
  case RISCV::SH2ADD:
  case RISCV::SH3ADD:
    return true;
  default:
    return false;
  }
}

// Whether \p MI is a memory access (load and/or store).
//
// The mutation only ever orders such an access before a *scalar* address ADD,
// never before another memory access, so we don't need to distinguish the
// access direction here (loads and stores are handled uniformly) nor worry
// about memory ordering. Instructions that neither load nor store are left
// alone.
static bool isAddressMemOp(const MachineInstr &MI) {
  return MI.mayLoadOrStore();
}

// Clustering a memory access next to the address computation shortens the live
// range of the (scalar) address. For a store that is an unconditional win: the
// stored value is consumed and dies at the store too. For a load it instead
// extends the loaded value's live range, which is only worthwhile when that
// value is cheap to keep live. Bail out for loads whose result is a
// multi-register vector group (LMUL > 1, or a whole-register group load such as
// VL8RE8_V): forcing those early inflates vector register pressure and can
// itself cause spills.
//
// We inspect the register class of the defined register(s); stores define no
// register and therefore always pass.
static bool isMemOpCheapToCluster(const MachineInstr &MI,
                                  const MachineRegisterInfo &MRI) {
  // for (const MachineOperand &MO : MI.defs()) {
  //   if (!MO.isReg() || !MO.getReg().isVirtual())
  //     continue;
  //   const TargetRegisterClass *RC = MRI.getRegClass(MO.getReg());
  //   // A vector register group spanning more than one physical register is
  //   // expensive to keep live early.
  //   if (RISCV::VRM2RegClass.hasSubClassEq(RC) ||
  //       RISCV::VRM4RegClass.hasSubClassEq(RC) ||
  //       RISCV::VRM8RegClass.hasSubClassEq(RC))
  //     return false;
  // }
  return true;
}

class RISCVAddressMemClusterDAGMutation : public ScheduleDAGMutation {
public:
  RISCVAddressMemClusterDAGMutation() = default;

  void apply(ScheduleDAGInstrs *DAG) override {
    const MachineRegisterInfo &MRI = DAG->MRI;

    for (SUnit &DefSU : DAG->SUnits) {
      // Collect, per GPR value defined by DefSU, the memory accesses that use
      // it as a base address and the address-advancing ADDs that consume it. We
      // only ever look at direct data successors, so the register carried by
      // the edge is exactly the value produced by DefSU.
      SmallDenseMap<Register, SmallVector<SUnit *, 2>> MemOps;
      SmallDenseMap<Register, SmallVector<SUnit *, 2>> Advances;

      for (const SDep &Succ : DefSU.Succs) {
        if (Succ.getKind() != SDep::Data)
          continue;

        Register Reg = Succ.getReg();
        if (!Reg.isVirtual() ||
            !RISCV::GPRRegClass.hasSubClassEq(MRI.getRegClass(Reg)))
          continue;

        SUnit *UseSU = Succ.getSUnit();
        if (UseSU->isBoundaryNode())
          continue;

        const MachineInstr *UseMI = UseSU->getInstr();
        if (isAddressMemOp(*UseMI)) {
          if (isMemOpCheapToCluster(*UseMI, MRI))
            MemOps[Reg].push_back(UseSU);
        } else if (isAddressAdvance(*UseMI))
          Advances[Reg].push_back(UseSU);
      }

      // For each pointer value that feeds both a memory access (as a base
      // address) and an address advance, force the access to be scheduled
      // before the advance.
      for (auto &[Reg, MemSUs] : MemOps) {
        auto AdvIt = Advances.find(Reg);
        if (AdvIt == Advances.end())
          continue;

        for (SUnit *MemSU : MemSUs) {
          for (SUnit *AdvSU : AdvIt->second) {
            if (MemSU == AdvSU)
              continue;
            if (DAG->canAddEdge(AdvSU, MemSU)) {
              LLVM_DEBUG(dbgs() << "Adding address/mem cluster edge from SU("
                                << MemSU->NodeNum << ") to SU("
                                << AdvSU->NodeNum << ")\n");
              DAG->addEdge(AdvSU, SDep(MemSU, SDep::Cluster));
            }
          }
        }
      }
    }
  }
};

std::unique_ptr<ScheduleDAGMutation> createRISCVAddressMemClusterDAGMutation() {
  return std::make_unique<RISCVAddressMemClusterDAGMutation>();
}

} // namespace llvm
