; RUN: opt -mtriple=riscv32 -mattr=+experimental-zibs -passes='require<profile-summary>,function(codegenprepare)' -S < %s | FileCheck %s --check-prefix=ZIBS
; RUN: opt -mtriple=riscv64 -mattr=+experimental-zibs -passes='require<profile-summary>,function(codegenprepare)' -S < %s | FileCheck %s --check-prefix=ZIBS
; RUN: opt -mtriple=riscv64 -passes='require<profile-summary>,function(codegenprepare)' -S < %s | FileCheck %s --check-prefix=BASE
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zibs -verify-machineinstrs < %s | FileCheck %s --check-prefix=ASM
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zibs -verify-machineinstrs < %s | FileCheck %s --check-prefix=ASM

declare void @callee()

define void @sink_bit_mask(i32 %x, i1 %cond) {
; ZIBS-LABEL: @sink_bit_mask(
; ZIBS: entry:
; ZIBS-NOT: and i32 %x, 128
; ZIBS: left:
; ZIBS-NEXT: [[L:%.*]] = and i32 %x, 128
; ZIBS-NEXT: %c1 = icmp eq i32 [[L]], 0
; ZIBS: right:
; ZIBS-NEXT: [[R:%.*]] = and i32 %x, 128
; ZIBS-NEXT: %c2 = icmp ne i32 [[R]], 0
; BASE-LABEL: @sink_bit_mask(
; BASE: entry:
; BASE-NEXT: %mask = and i32 %x, 128
; ASM-LABEL: sink_bit_mask:
; ASM: bb{{clri|seti}} {{[a-z0-9]+}}, 7,

entry:
  %mask = and i32 %x, 128
  br i1 %cond, label %left, label %right
left:
  %c1 = icmp eq i32 %mask, 0
  br i1 %c1, label %taken, label %exit
right:
  %c2 = icmp ne i32 %mask, 0
  br i1 %c2, label %taken, label %exit
taken:
  call void @callee()
  br label %exit
exit:
  ret void
}

define i1 @materialize_bit_test(i32 %x, i1 %cond) {
; ZIBS-LABEL: @materialize_bit_test(
; ZIBS: entry:
; ZIBS-NEXT: %mask = and i32 %x, 128
; BASE-LABEL: @materialize_bit_test(
; BASE: entry:
; BASE-NEXT: %mask = and i32 %x, 128
entry:
  %mask = and i32 %x, 128
  br i1 %cond, label %left, label %right
left:
  %c1 = icmp eq i32 %mask, 0
  br label %exit
right:
  %c2 = icmp ne i32 %mask, 0
  br label %exit
exit:
  %r = phi i1 [ %c1, %left ], [ %c2, %right ]
  ret i1 %r
}
