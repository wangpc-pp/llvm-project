; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -verify-machineinstrs \
; RUN:   | FileCheck %s --check-prefix=RV32
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+experimental-zispi \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefix=RV32-ZISPI
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 \
; RUN:   -mattr=+experimental-zispi,+xcvmem -verify-machineinstrs \
; RUN:   | FileCheck %s --check-prefix=RV32-ZISPI-XCVMEM
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -verify-machineinstrs \
; RUN:   | FileCheck %s --check-prefix=RV64
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+experimental-zispi \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefix=RV64-ZISPI

define ptr @spi_b(ptr %base, i8 %value) {
; RV32-LABEL: spi_b:
; RV32:       # %bb.0:
; RV32-NOT:     spi.b
; RV32:         addi a0, a0, 1
; RV32:         sb a1, 0({{a[0-9]+}})
; RV32-ZISPI-LABEL: spi_b:
; RV32-ZISPI:       # %bb.0:
; RV32-ZISPI-NEXT:    spi.b a1, (a0)
; RV32-ZISPI-NEXT:    ret
; RV64-LABEL: spi_b:
; RV64:       # %bb.0:
; RV64-NOT:     spi.b
; RV64:         addi a0, a0, 1
; RV64:         sb a1, 0({{a[0-9]+}})
; RV64-ZISPI-LABEL: spi_b:
; RV64-ZISPI:       # %bb.0:
; RV64-ZISPI-NEXT:    spi.b a1, (a0)
; RV64-ZISPI-NEXT:    ret
  store i8 %value, ptr %base
  %next = getelementptr i8, ptr %base, iXLen 1
  ret ptr %next
}

define ptr @spi_h(ptr %base, i16 %value) {
; RV32-ZISPI-LABEL: spi_h:
; RV32-ZISPI:       # %bb.0:
; RV32-ZISPI-NEXT:    spi.h a1, (a0)
; RV32-ZISPI-NEXT:    ret
; RV64-ZISPI-LABEL: spi_h:
; RV64-ZISPI:       # %bb.0:
; RV64-ZISPI-NEXT:    spi.h a1, (a0)
; RV64-ZISPI-NEXT:    ret
  store i16 %value, ptr %base
  %next = getelementptr i16, ptr %base, iXLen 1
  ret ptr %next
}

define ptr @spi_w(ptr %base, i32 %value) {
; RV32-ZISPI-LABEL: spi_w:
; RV32-ZISPI:       # %bb.0:
; RV32-ZISPI-NEXT:    spi.w a1, (a0)
; RV32-ZISPI-NEXT:    ret
; RV64-ZISPI-LABEL: spi_w:
; RV64-ZISPI:       # %bb.0:
; RV64-ZISPI-NEXT:    spi.w a1, (a0)
; RV64-ZISPI-NEXT:    ret
  store i32 %value, ptr %base
  %next = getelementptr i32, ptr %base, iXLen 1
  ret ptr %next
}

define ptr @spi_d(ptr %base, i64 %value) {
; RV32-ZISPI-LABEL: spi_d:
; RV32-ZISPI:       # %bb.0:
; RV32-ZISPI-NOT:    spi.d
; RV64-ZISPI-LABEL: spi_d:
; RV64-ZISPI:       # %bb.0:
; RV64-ZISPI-NEXT:    spi.d a1, (a0)
; RV64-ZISPI-NEXT:    ret
  store i64 %value, ptr %base
  %next = getelementptr i64, ptr %base, iXLen 1
  ret ptr %next
}

define ptr @not_unit_stride(ptr %base, i32 %value) {
; RV32-ZISPI-LABEL: not_unit_stride:
; RV32-ZISPI-NOT:    spi.
; RV32-ZISPI-XCVMEM-LABEL: not_unit_stride:
; RV32-ZISPI-XCVMEM:       # %bb.0:
; RV32-ZISPI-XCVMEM-NEXT:    cv.sw a1, (a0), 8
; RV32-ZISPI-XCVMEM-NEXT:    ret
; RV64-ZISPI-LABEL: not_unit_stride:
; RV64-ZISPI-NOT:    spi.
  store i32 %value, ptr %base
  %next = getelementptr i32, ptr %base, iXLen 2
  ret ptr %next
}

define ptr @old_base_live(ptr %base, i32 %value, ptr %out) {
; RV32-ZISPI-LABEL: old_base_live:
; RV32-ZISPI-NOT:   spi.
; RV64-ZISPI-LABEL: old_base_live:
; RV64-ZISPI-NOT:   spi.
  store i32 %value, ptr %base
  %next = getelementptr i32, ptr %base, iXLen 1
  store ptr %base, ptr %out
  ret ptr %next
}

define ptr @store_base_value(ptr %base) {
; RV32-ZISPI-LABEL: store_base_value:
; RV32-ZISPI:       spi.w a0, (a0)
; RV64-ZISPI-LABEL: store_base_value:
; RV64-ZISPI:       spi.d a0, (a0)
  store ptr %base, ptr %base
  %next = getelementptr ptr, ptr %base, iXLen 1
  ret ptr %next
}
