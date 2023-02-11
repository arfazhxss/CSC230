.equ input = 0b11010010
ldi XL, input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.def numone = R20
ANDI XL, 0b01111111

main:
	MOV YL, XL
	ANDI YL, 0b00000001
	CPI YL, 0b00000001
	BREQ increment
	RJMP continue

increment:
	INC numone

continue:
	LSR XL
	CPI XL, 0b00000000
	BREQ exitLOOP
	JMP main

exitLOOP:
	ANDI numone, 0b00000001
	CPI numone, 0b00000001
	BREQ odd

odd:
	CLR numone
	ldi numone, 0b10000000
	ADD ZL, R0
	NOP
