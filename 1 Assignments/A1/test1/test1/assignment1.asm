; Assignment #1 
; Student Name: Arfaz Hossain
; V Number:	V00984826
;
; Problem 1
; Please copy your code for Problem 1 here between START and STOP marks
; and do not modify any other lines
add16:
; START -----------------------------------------------------------------

	 ;.equ input1 = 0b11111111
	 ;.equ input2 = 0b11111111
	 ;.equ input3 = 0b11111111
	 ;.equ input4 = 0b11111111
	 .equ maininput = 0b00000001
	 .def carryReg = R0
	 .def regincc = R20

	 ;LDI XL, input1
	 ;LDI XH, input2
	 ;LDI YL, input3
	 ;LDI YH, input4
	 LDI regincc, maininput

	 ADD ZL, XL
	 ADD ZL, YL
	 BRCS addZH
	 JMP continue1
 
 continue1:
	 ADD ZH, XH
	 BRCS continue2
	 JMP continue3
 
 continue2:
	 MOV carryReg, regincc
	 ADD ZH, YH
	 JMP end1
 
 continue3:
	 ADD ZH, YH
	 BRCS addR1
	 JMP end1
 
 addZH:
	ADD ZH, regincc
	JMP continue1
 
 addR1:
	MOV carryReg, regincc
	JMP end1
 
 end1:
 	 CLR XL
	 CLR XH
	 CLR YL
	 CLR YH
	 CLR ZL
	 CLR ZH
	 CLR R0
	 CLR R20
	 NOP


; STOP ------------------------------------------------------------------
	;ret
;
;
;
;
;
; Problem 2
; Please copy your code for Problem 2 here between START and STOP marks
; and do not modify any other lines
add_prity:
; START -----------------------------------------------------------------

;.equ in3 = 0b11010010
;ldi XL, in3
.def numone = R21
ANDI XL, 0b01111111

; main loop that checks each bit and branches out when there's a 1
; is checked with LogicalShifted loops of XL (r26), checked through YL (R28)
main:
	MOV YL, XL
	ANDI YL, 0b00000001
	CPI YL, 0b00000001
	BREQ increment
	RJMP continue

; increments numone (# of ones) if 1 is found
increment:
	INC numone

; continues the main-loop adding 1 if found, or not if-not-found
continue:
	LSR XL
	CPI XL, 0b00000000
	BREQ exitLOOP
	JMP main

; exits loop if LogicalShiftedLoops give us a 0b-0000-0000
; checking if the number of ones is odd, or not
exitLOOP:
	ANDI numone, 0b00000001
	CPI numone, 0b00000001
	BREQ odd
	JMP end2

; if odd, adds a 1 to 7th bit of R30
; else, continues to clear all memories
odd:
	CLR numone
	ldi numone, 0b10000000
	ADD ZL, R0
	JMP end2

end2:
	CLR XL
	CLR YL
	CLR R21
	CLR ZL
	NOP

; STOP ------------------------------------------------------------------
	ret
