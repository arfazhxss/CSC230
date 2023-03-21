; a2-signalling.asm
; University of Victoria
; CSC 230: Spring 2023
; Instructor: Ahmad Abdullah
;
; Student name: Arfaz Hossain
; Student ID: V00984826
; Date of completed work:
;
; *******************************
; Code provided for Assignment #2 
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section

	ldi R22, high(0x21ff)
	ldi R23, low(0x21ff)
	out SPH, R22
	out SPL, R23

; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	;rjmp test_part_a
	;rjmp test_part_b
	;rjmp test_part_c
	;rjmp test_part_d
	;rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16
	
	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000
	
test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:

	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	;ldi r21, '-'
	;push r21
	;rcall encode_letter
	;pop r21
	;push r25
	;rcall leds_with_speed
	;pop r25

	;rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD00 << 1)
	ldi r24, LOW(WORD00 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end

; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

set_leds:
	clr R20
	.equ clearBit = 0b00000000
	.equ fullBit = 0b11111111
	.equ fullByte = 0b10000000
	.def countBit = R20
	ldi XL, fullbit ; PORTB
	ldi XH, fullBit ; PORTL
	ldi YL, fullByte
	andi r16, 0b00111111
	lsl r16
	lsl r16

	continue001:
		cpi countBit, 0b10
		breq continueBtoL
	
	continuePortB:
		inc countBit
		lsl r16
		brcs addPortB
		lsr XL
		lsr XL
		jmp continue001

	addPortB:
		lsr XL
		lsr XL
		add XL, YL
		jmp continue001
	
	continueBtoL:
		lsr XL
		lsr XL
		lsr XL
		lsr XL

	continue002:
		cpi countBit, 0b110
		breq setPort

	continuePortL:
		inc countBit
		lsr XH
		lsr XH
		lsl r16
		brcs addPortL
		jmp continue002

	addPortL:
		add XH, YL
		jmp continue002

	setPort:
		ldi R20, 0xFF
		sts DDRL, R20
		out DDRB, R20
		sts PORTL, XH
		out PORTB, XL
		jmp clearA

	clearA:
		clr r16
		clr r20
		clr r26
		clr r27
		clr r28
		ret


slow_leds:
	clr r16
	add r16, r17
	rcall set_leds
	rcall delay_long
	clr r16
	rcall set_leds
	ret


fast_leds:
	clr r16
	add r16, r17
	rcall set_leds
	rcall delay_short
	clr r16
	rcall set_leds
	ret


leds_with_speed:
	.set PARAM_OFFSET = 4
	clr r17
	in YH, SPH
	in YL, SPL

	ldd r17, Y + PARAM_OFFSET + 0

	ldi R19, 0b11000000
	and R19, R17
	cpi R19, 0b11000000
	breq slow_leds
	rcall fast_leds

	clr R19
	ret

; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
	.set PARAM_OFFSET = 4
	clr r25
	clr r18
	clr r19 ; counter
	ldi r19, 6
	clr r20
	
	in YH, SPH
	in YL, SPL
	ldd r18, Y + PARAM_OFFSET + 0

	ldi ZH, high (PATTERNS*2)
	ldi ZL, low (PATTERNS*2)
	
	loop:
		LPM R20, Z			; 8 additions after each loop, unless exception
		ADIW ZH:ZL, 8
		;cpi R20, 0b00101101
		;breq endEncode
		cp R20, R18
		breq found			; exception
		cpi R20, 0x00
		breq endEncode
		rjmp loop
	found:
		ldi r25, 0b00111111
		SBIW ZH:ZL, 7
		rjmp foundLoop
	foundLoop:
		LPM R20, Z+
		cpi R20, 0b01101111
		breq turnOnLED
		LSL R25
		dec R19
		cpi R19, 0
		breq LedSpeed
		rjmp foundLoop

		turnOnLED:
			LSL R25
			INC R25
			dec R19
			cpi R19, 0
			breq LedSpeed
			rjmp foundLoop
		
		LedSpeed:
			LPM R20, Z
			cpi R20, 2
			breq fasted
			rjmp endEncode

			fasted:
				andi R25, 0b00111111
				rjmp endEncode

	endEncode: 
		clr r18
		clr r19
		clr r20
		clr YH
		clr YL
		ret


display_message:
	CLR ZH
	CLR ZL
	MOV ZH, R25
	MOV ZL, R24
	CLR R25
	CLR R24
	
	display_message_loop:
		LPM R21, Z+
		MOV XL, ZL
		MOV XH, ZH
		push R21
		cpi R21, 0
		breq end_display
		rcall encode_letter
		pop r21
		MOV ZL, XL
		MOV ZH, XH
		push R25
		call leds_with_speed
		pop R25
		rcall delay_long
		rjmp display_message_loop
	end_display: 
		CLR R17
		CLR R21
		CLR R22
		CLR R23
		CLR R25
		CLR R26
		CLR R27
		CLR R29
		CLR R30
		CLR R31
		pop r31
		pop r30
		pop r31
		pop r30
		ijmp		


; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************




; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables
.cseg
.org 0x600

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "X", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

