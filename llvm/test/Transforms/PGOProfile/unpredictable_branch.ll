; Test that -pgo-unpredictable-hints attaches !unpredictable to near-50:50
; two-way branches with sufficient sample count, and leaves skewed or
; low-sample branches alone. Without the flag, no !unpredictable is added.

; RUN: llvm-profdata merge %S/Inputs/unpredictable_branch.proftext -o %t.profdata

; Default: flag off, never emit !unpredictable.
; RUN: opt < %s -passes=pgo-instr-use -pgo-test-profile-file=%t.profdata -S | FileCheck %s --check-prefix=OFF

; Flag on: balanced branch gets !unpredictable, skewed/small do not.
; RUN: opt < %s -passes=pgo-instr-use -pgo-test-profile-file=%t.profdata -pgo-unpredictable-hints -S | FileCheck %s --check-prefix=ON

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; OFF-NOT: !unpredictable

define i32 @test_balanced(i32 %i) {
; ON-LABEL: @test_balanced
entry:
  %cmp = icmp sgt i32 %i, 0
  br i1 %cmp, label %if.then, label %if.end
; ON: br i1 %cmp, label %if.then, label %if.end
; ON-SAME: !prof ![[BW_BAL:[0-9]+]]
; ON-SAME: !unpredictable ![[UNPRED:[0-9]+]]

if.then:
  %add = add nsw i32 %i, 2
  br label %if.end

if.end:
  %retv = phi i32 [ %add, %if.then ], [ %i, %entry ]
  ret i32 %retv
}

define i32 @test_skewed(i32 %i) {
; ON-LABEL: @test_skewed
entry:
  %cmp = icmp sgt i32 %i, 0
  br i1 %cmp, label %if.then, label %if.end
; ON: br i1 %cmp, label %if.then, label %if.end
; ON-NOT: !unpredictable

if.then:
  %add = add nsw i32 %i, 2
  br label %if.end

if.end:
  %retv = phi i32 [ %add, %if.then ], [ %i, %entry ]
  ret i32 %retv
}

define i32 @test_small(i32 %i) {
; ON-LABEL: @test_small
entry:
  %cmp = icmp sgt i32 %i, 0
  br i1 %cmp, label %if.then, label %if.end
; ON: br i1 %cmp, label %if.then, label %if.end
; ON-NOT: !unpredictable

if.then:
  %add = add nsw i32 %i, 2
  br label %if.end

if.end:
  %retv = phi i32 [ %add, %if.then ], [ %i, %entry ]
  ret i32 %retv
}

; ON-DAG: ![[BW_BAL]] = !{!"branch_weights", i32 500, i32 500}
; ON-DAG: ![[UNPRED]] = !{}
