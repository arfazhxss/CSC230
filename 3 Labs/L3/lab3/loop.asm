/*
 * loop.asm
 *
 *  Created: 1/30/2023 11:46:20 AM
 *   Author: arfazhussain
 */ 
 ; switch to code (flash) memory segment
 .cseg

 ; set the location counter of the current memory
 .org 0 ; begin assembling at address 0

 ; Define symbolic names for resources used
 ;ldi r24, 0x00
 ;ldi r25, 0x400
 adiw r25:r24, 0x400
 .def count = r17 ; r17 holds counter value
	ldi count, 0; initialize count to 0 - note ...

loop:
	inc count	; increment the counter
	cpi count, 0x04		; can use hexdecimal number as well
	breq done
	rjmp loop

done: jmp done