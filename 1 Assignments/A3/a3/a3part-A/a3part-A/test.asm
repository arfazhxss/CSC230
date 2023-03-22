/*
 * test.asm
 *
 *  Created: 3/22/2023 2:22:18 PM
 *   Author: arfaz
 */ 

	ldi r16, 3
	sts buttonval, r16
	clr r16

	start:
		lds r16, buttonval
		cpi r16, 1
		breq setLcdOne
		clr r16
		lds r16, buttonval
		cpi r16, 3
		breq setLcdTwo
		rjmp start
	
	setLcdOne:
		ldi r20, 122
		rjmp start
	
	setLcdTwo:
		ldi r20, 244
		rjmp start

.dseg
buttonval: .byte 1