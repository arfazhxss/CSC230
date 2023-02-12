;
; test1.asm
;
; Created: 2/4/2023 5:40:34 PM
; Author : arfaz
;


; Replace with your application code
.cseg
.org 0
.def number = r16
.def isEven = r19
	clr isEven
	ldi number, 0x0A

	andi number, 0b00000001
	breq even
 	done: jmp done
	;end: rjmp end

even: ldi isEven, 1
	rjmp done 