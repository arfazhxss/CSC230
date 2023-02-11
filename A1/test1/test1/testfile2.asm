/*
 * AsmFile1.asm
 *
 *  Created: 2/4/2023 8:18:55 PM
 *   Author: arfaz
 */ 

	 .equ input1 = 0b11111111
	 .equ input2 = 0b11111111
	 .equ input3 = 0b11111111
	 .equ input4 = 0b11111111
	 .equ maininput = 0b00000001
	 .def carryReg = R0
	 .def regincc = R20

	 LDI XL, input1
	 LDI XH, input2
	 LDI YL, input3
	 LDI YH, input4
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
	 JMP end
 continue3:
	 ADD ZH, YH
	 BRCS addR1
	 JMP end
 addZH:
	ADD ZH, regincc
	JMP continue1
 addR1:
	MOV carryReg, regincc
	JMP end
 end:
 	 CLR XL
	 CLR XH
	 CLR YL
	 CLR YH
	 CLR ZL
	 CLR ZH
	 CLR R0
	 CLR R20