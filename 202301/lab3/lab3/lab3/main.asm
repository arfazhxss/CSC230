;
; lab3.asm
;
; Created: 1/30/2023 11:41:21 AM
; Author : arfazhussain
;


; if the number loaded to r16 is even, set r 19 to 1, 0 otherwise
.cseg
.org 0
.def number = r16 ; give a symbolic name for register 16
.def isEven = r19 
	clr isEven
	ldi number, 0x0A ; load 10 to r16

	; AND R16 with 1
	; after AND operation, the value in R16 is 0
	andi number, 0b00000001
	breq even
done: jmp done ; infinite loop

even: ldi isEven, 1
	rjmp done