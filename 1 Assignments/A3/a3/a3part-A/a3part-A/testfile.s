.def DATAH=r25  ;DATAH:DATAL  store 10 bits data from ADC
.def DATAL=r24
.def BOUNDARY_H=r1  ;hold high byte value of the threshold for button
.def BOUNDARY_L=r0  ;hold low byte value of the threshold for button, r1:r0


.equ ADCSRA_BTN=0x7A
.equ ADCSRB_BTN=0x7B
.equ ADMUX_BTN=0x7C
.equ ADCL_BTN=0x78
.equ ADCH_BTN=0x79

.equ RIGHT  = 0x032
.equ UP     = 0x0FA 
.equ DOWN   = 0x1C2 
.equ LEFT   = 0x28A 
.equ SELECT = 0x352 

.cseg
.org 0
	ldi r16, 0x87  ;0x87 = 0b10000111
	sts ADCSRA_BTN, r16

	ldi r16, 0x00
	sts ADCSRB_BTN, r16
	ldi r16, 0x40  ;0x40 = 0b01000000
	sts ADMUX_BTN, r16

	; detect if "RIGHT" button is pressed r1:r0 <- 0x032
	ldi r16, low(RIGHT);
	mov BOUNDARY_L, r16
	ldi r16, high(RIGHT)
	mov BOUNDARY_H, r16

/*  // //  DONT NEED JUST CHECK FUNC CALL // //  
loop:
	ldi r19, 0b00000010  ; turn on the light at the bottom
	sts PORTB_LED, r19

	call check_button
	cpi  r23, 1
	brne loop

	ldi r19, 0x00  ; turn off the light if "RIGHT" is pressed for 1 second
	sts PORTB_LED, r19
	ldi	r20, 0x40
	;call delay
	rjmp loop
*/

check_button:
	lds	r16, ADCSRA_BTN	

	; bit 6 =1 ADSC (ADC Start Conversion bit), remain 1 if conversion not done
	; ADSC changed to 0 if conversion is done
	ori r16, 0x40 ; 0x40 = 0b01000000
	sts	ADCSRA_BTN, r16

	; wait for it to complete, check for bit 6, the ADSC bit
wait:	lds r16, ADCSRA_BTN
		andi r16, 0x40
		brne wait

		; read the value, use XH:XL to store the 10-bit result
		lds DATAL, ADCL_BTN
		lds DATAH, ADCH_BTN

		clr r23
		; if DATAH:DATAL < BOUNDARY_H:BOUNDARY_L
		;     r23=1  "right" button is pressed
		; else
		;     r23=0
		cp DATAL, BOUNDARY_L
		cpc DATAH, BOUNDARY_H
		brsh skip		
		ldi r23,1
skip:	ret