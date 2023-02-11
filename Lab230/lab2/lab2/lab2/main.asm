;
; lab2.asm
;
; Created: 1/23/2023 11:39:51 AM
; Author : arfazhussain
;


; Replace with your application code
.cseg
.org 0

.def number = r16
	ldi number, 0x0A ;load 10 to R16
	;AND R16 with 1
	; after AND operation, the value in R16 is 0
	andi number, 0b00000001
	done: jmp done ;infinite loop
