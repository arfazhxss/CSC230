/*
 * solution2co.asm
 *
 *  Created: 2/5/2023 3:15:44 AM
 *   Author: someone else
 */ 

.equ input = 0b11010010
LDI XL, input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	 .def counter = r16

	 ; At First
	 ANDI XL, 0b01111111
	 MOV ZL, XL
	 CLR counter

loop:
	 ; Mask All but bit 0
	 MOV XH, XL
	 ANDI XH, 1
	 CPI XH, 1
	 BREQ incc

continue:
	LSR XL
	CPI XL, 0
	BREQ isOdd
	JMP loop

incc:
	INC counter
	JMP continue

isOdd:
	 ANDI counter, 1
	 CPI counter, 1
	 BREQ setOutput
end: ret

setOutput:
	CLR r17
	ldi r17, 0b10000000
	ADD ZL, r17
	JMP end
