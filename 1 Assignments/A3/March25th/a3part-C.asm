;
; a3part-A.asm
;
; Part A of assignment #3
;
;
; Student name: Arfaz Hossain
; Student ID: V00984826
; Date of completed work:
;
; **********************************
; Code provided for Assignment #3
;
; Author: Mike Zastre (2022-Nov-05)
;
; This skeleton of an assembly-language program is provided to help you 
; begin with the programming tasks for A#3. As with A#2 and A#1, there are
; "DO NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes announced on
; Brightspace or in written permission from the course instruction.
; *** Unapproved changes could result in incorrect code execution
; during assignment evaluation, along with an assignment grade of zero. ***
;


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================
;
; In this "DO NOT TOUCH" section are:
; 
; (1) assembler direction setting up the interrupt-vector table
;
; (2) "includes" for the LCD display
;
; (3) some definitions of constants that may be used later in
;     the program
;
; (4) code for initial setup of the Analog-to-Digital Converter
;     (in the same manner in which it was set up for Lab #4)
;
; (5) Code for setting up three timers (timers 1, 3, and 4).
;
; After all this initial code, your own solutions's code may start
;

.cseg
.org 0
	jmp reset

; Actual .org details for this an other interrupt vectors can be
; obtained from main ATmega2560 data sheet
;
.org 0x22
	jmp timer1

; This included for completeness. Because timer3 is used to
; drive updates of the LCD display, and because LCD routines
; *cannot* be called from within an interrupt handler, we
; will need to use a polling loop for timer3.
;
; .org 0x40
;	jmp timer3

.org 0x54
	jmp timer4

.include "m2560def.inc"
.include "lcd.asm"

.cseg
#define CLOCK 16.0e6
#define DELAY1 0.01
#define DELAY3 0.1
#define DELAY4 0.5

#define BUTTON_RIGHT_MASK 0b00000001	
#define BUTTON_UP_MASK    0b00000010
#define BUTTON_DOWN_MASK  0b00000100
#define BUTTON_LEFT_MASK  0b00001000

#define BUTTON_RIGHT_ADC  0x032
#define BUTTON_UP_ADC     0x0b0   
#define BUTTON_DOWN_ADC   0x160   
#define BUTTON_LEFT_ADC   0x22b
#define BUTTON_SELECT_ADC 0x316

.equ PRESCALE_DIV=1024   ; w.r.t. clock, CS[2:0] = 0b101

; TIMER1 is a 16-bit timer. If the Output Compare value is
; larger than what can be stored in 16 bits, then either
; the PRESCALE needs to be larger, or the DELAY has to be
; shorter, or both.
.equ TOP1=int(0.5+(CLOCK/PRESCALE_DIV*DELAY1))
.if TOP1>65535
.error "TOP1 is out of range"
.endif

; TIMER3 is a 16-bit timer. If the Output Compare value is
; larger than what can be stored in 16 bits, then either
; the PRESCALE needs to be larger, or the DELAY has to be
; shorter, or both.
.equ TOP3=int(0.5+(CLOCK/PRESCALE_DIV*DELAY3))
.if TOP3>65535
.error "TOP3 is out of range"
.endif

; TIMER4 is a 16-bit timer. If the Output Compare value is
; larger than what can be stored in 16 bits, then either
; the PRESCALE needs to be larger, or the DELAY has to be
; shorter, or both.
.equ TOP4=int(0.5+(CLOCK/PRESCALE_DIV*DELAY4))
.if TOP4>65535
.error "TOP4 is out of range"
.endif

reset:
; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

; Anything that needs initialization before interrupts
; start must be placed here.
 
call lcd_init
call lcd_clr

charset_index_initialization:
	ldi r20, 0
	sts CURRENT_CHARSET_INDEX, r20
	ldi r16, ' '
	sts LAST_BUTTON_PRESSED, r16
	clr r16
	clr r20

charset_initialization:
	ldi ZH, high (AVAILABLE_CHARSET*2)
	ldi ZL, low (AVAILABLE_CHARSET*2)
	ldi r16, 0

	loop1:
		LPM R20, Z+			; 1 addition after each loop
		inc r16
		cpi R20, 0x00
		breq endEncode1
		rjmp loop1
	endEncode1:
		clr r20
		dec r16
		dec r16
		sts STRING_SIZE, r16
		clr r16

topLine_initialization:
	ldi r16, ' '
	ldi r17, 0

	ldi ZH, high(TOP_LINE_CONTENT)
	ldi ZL, low(TOP_LINE_CONTENT)

	loop:
		st Z+, r16
		inc r17
		cpi r17, 15
		breq end_loop
		rjmp loop
	end_loop:
		NOP

 .def templow=r20
 .def temphigh=r21
 ldi templow, low(RAMEND)
 out SPL, templow
 ldi temphigh, high(RAMEND)
 out SPH, temphigh
 clr r20
 clr r21

.def DATAH=r25  ;DATAH:DATAL  store 10 bits data from ADC
.def DATAL=r24

.def BOUNDARY_H=r1  ;hold high byte value of the threshold for SELECT button
.def BOUNDARY_L=r0  ;hold low byte value of the threshold for SELECT button, r1:r0
.def BOUNDARY_RIGHT_H=r3  
.def BOUNDARY_RIGHT_L=r2
.def BOUNDARY_LEFT_H=r5  
.def BOUNDARY_LEFT_L=r4
.def BOUNDARY_UP_H=r7  
.def BOUNDARY_UP_L=r6
.def BOUNDARY_DOWN_H=r9  
.def BOUNDARY_DOWN_L=r8

ldi r16, low(BUTTON_SELECT_ADC);
mov BOUNDARY_L, r16
ldi r16, high(BUTTON_SELECT_ADC)
mov BOUNDARY_H, r16

ldi r16, low(BUTTON_RIGHT_ADC);
mov BOUNDARY_RIGHT_L, r16
ldi r16, high(BUTTON_RIGHT_ADC)
mov BOUNDARY_RIGHT_H, r16

ldi r16, low(BUTTON_LEFT_ADC);
mov BOUNDARY_LEFT_L, r16
ldi r16, high(BUTTON_LEFT_ADC)
mov BOUNDARY_LEFT_H, r16

ldi r16, low(BUTTON_UP_ADC);
mov BOUNDARY_UP_L, r16
ldi r16, high(BUTTON_UP_ADC)
mov BOUNDARY_UP_H, r16

ldi r16, low(BUTTON_DOWN_ADC);
mov BOUNDARY_DOWN_L, r16
ldi r16, high(BUTTON_DOWN_ADC)
mov BOUNDARY_DOWN_H, r16

.equ ADCSRA_BTN=0x7A
.equ ADCSRB_BTN=0x7B
.equ ADMUX_BTN=0x7C
.equ ADCL_BTN=0x78
.equ ADCH_BTN=0x79

; ***************************************************
; ******* END OF FIRST "STUDENT CODE" SECTION *******
; ***************************************************

; =============================================
; ====  START OF "DO NOT TOUCH" SECTION    ====
; =============================================

	; initialize the ADC converter (which is needed
	; to read buttons on shield). Note that we'll
	; use the interrupt handler for timer 1 to
	; read the buttons (i.e., every 10 ms)
	;
	ldi temp, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0)
	sts ADCSRA, temp
	ldi temp, (1 << REFS0)
	sts ADMUX, r16

	; Timer 1 is for sampling the buttons at 10 ms intervals.
	; We will use an interrupt handler for this timer.
	ldi r17, high(TOP1)
	ldi r16, low(TOP1)
	sts OCR1AH, r17
	sts OCR1AL, r16
	clr r16
	sts TCCR1A, r16
	ldi r16, (1 << WGM12) | (1 << CS12) | (1 << CS10)
	sts TCCR1B, r16
	ldi r16, (1 << OCIE1A)
	sts TIMSK1, r16

	; Timer 3 is for updating the LCD display. We are
	; *not* able to call LCD routines from within an 
	; interrupt handler, so this timer must be used
	; in a polling loop.
	ldi r17, high(TOP3)
	ldi r16, low(TOP3)
	sts OCR3AH, r17
	sts OCR3AL, r16
	clr r16
	sts TCCR3A, r16
	ldi r16, (1 << WGM32) | (1 << CS32) | (1 << CS30)
	sts TCCR3B, r16
	; Notice that the code for enabling the Timer 3
	; interrupt is missing at this point.

	; Timer 4 is for updating the contents to be displayed
	; on the top line of the LCD.
	ldi r17, high(TOP4)
	ldi r16, low(TOP4)
	sts OCR4AH, r17
	sts OCR4AL, r16
	clr r16
	sts TCCR4A, r16
	ldi r16, (1 << WGM42) | (1 << CS42) | (1 << CS40)
	sts TCCR4B, r16
	ldi r16, (1 << OCIE4A)
	sts TIMSK4, r16

	sei

; =============================================
; ====    END OF "DO NOT TOUCH" SECTION    ====
; =============================================

; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

start:

	ldi r16, '*'
	sts CHAR_ONE, r16
	ldi r16, '_'
	sts CHAR_ZERO, r16

	timer3:
		in r16, TIFR3
		sbrs r16, OCF3A
		rjmp timer3
		ldi r16, 1<<OCF3A
		out TIFR3, r16

		lds r16, BUTTON_IS_PRESSED
		cpi r16, 0
		breq setLcdZero
		lds r16, BUTTON_IS_PRESSED
		cpi r16, 1
		breq setLcdOne
		rjmp timer3
	
	setLcdZero:
		push r16
		push r17
		in r16, SREG
		push r16

		ldi r16, 1 ;row
		ldi r17, 15 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		lds r16, CHAR_ZERO
		push r16
		rcall lcd_putchar
		pop r16

		rjmp timer3_end
	
	setLcdOne:
	
		ldi r16, 1 ;row
		ldi r17, 0 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		ldi r16, ' '
		push r16
		rcall lcd_putchar
		pop r16

		ldi r16, 1 ;row
		ldi r17, 1 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		ldi r16, ' '
		push r16
		rcall lcd_putchar
		pop r16

		ldi r16, 1 ;row
		ldi r17, 2 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		ldi r16, ' '
		push r16
		rcall lcd_putchar
		pop r16

		ldi r16, 1 ;row
		ldi r17, 3 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		ldi r16, ' '
		push r16
		rcall lcd_putchar
		pop r16
		push r16
		push r17
		in r16, SREG
		push r16

		ldi r16, 1 ;row
		ldi r17, 15 ;column
		push r16
		push r17
		rcall lcd_gotoxy
		pop r17
		pop r16
	
		lds r16, CHAR_ONE
		push r16
		rcall lcd_putchar
		pop r16

		lds r16, LAST_BUTTON_PRESSED

		cpi r16,'R'
		breq setLedRight

		cpi r16,'U'
		breq setLedUp

		cpi r16,'D'
		breq setLedDown

		cpi r16,'L'
		breq setLedLeft

		rjmp timer3_end

		setLedDown:
			ldi r16, 1 ;row
			ldi r17, 1 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
	
			ldi r16, 'D'
			push r16
			rcall lcd_putchar
			pop r16

			ldi r16, 0 ;row
			ldi r17, 0 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
			
			lds r16, TOP_LINE_CONTENT
			push r16
			rcall lcd_putchar
			pop r16

			rjmp timer3_end	

		setLedUp:
			ldi r16, 1 ;row
			ldi r17, 2 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
	
			ldi r16, 'U'
			push r16
			rcall lcd_putchar
			pop r16

			ldi r16, 0 ;row
			ldi r17, 0 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
			
			lds r16, TOP_LINE_CONTENT
			push r16
			rcall lcd_putchar
			pop r16

			rjmp timer3_end

		setLedRight:
			ldi r16, 1 ;row
			ldi r17, 3 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
	
			ldi r16, 'R'
			push r16
			rcall lcd_putchar
			pop r16

			rjmp timer3_end

		setLedLeft:
			ldi r16, 1 ;row
			ldi r17, 0 ;column
			push r16
			push r17
			rcall lcd_gotoxy
			pop r17
			pop r16
	
			ldi r16, 'L'
			push r16
			rcall lcd_putchar
			pop r16

			rjmp timer3_end

	timer3_end:
		pop r16
		out SREG, r16
		pop r17
		pop r16
		rjmp timer3
	

stop:
	rjmp stop


timer1: ; INTURRUPT HANDLER FOR BUTTONS 
	push r16

	ldi r16, 0x87  ;0x87 = 0b10000111
	sts ADCSRA_BTN, r16

	ldi r16, 0x00
	sts ADCSRB_BTN, r16
	ldi r16, 0x40  ;0x40 = 0b01000000
	sts ADMUX_BTN, r16
	
	lds	r16, ADCSRA_BTN	
	ori r16, 0x40
	sts	ADCSRA_BTN, r16

	wait:
		lds r16, ADCSRA_BTN
		andi r16, 0x40
		brne wait
		
	lds DATAL, ADCL_BTN
	lds DATAH, ADCH_BTN

	cp DATAL, BOUNDARY_L
	cpc DATAH, BOUNDARY_H
	brsh nobutton ; branch if higher

	ldi r16, 1
	sts BUTTON_IS_PRESSED, r16
	;pop r16
	
	cp DATAL, BOUNDARY_RIGHT_L
	cpc DATAH, BOUNDARY_RIGHT_H
	brlo rightButton

	cp DATAL, BOUNDARY_UP_L
	cpc DATAH, BOUNDARY_UP_H
	brlo upButton

	cp DATAL, BOUNDARY_DOWN_L
	cpc DATAH, BOUNDARY_DOWN_H
	brlo downButton
	
	cp DATAL, BOUNDARY_LEFT_L
	cpc DATAH, BOUNDARY_LEFT_H
	brlo leftButton

	cp DATAL, BOUNDARY_L
	cpc DATAH, BOUNDARY_H
	brlo selectButton

	selectButton:
		ldi r16, ' '
		sts LAST_BUTTON_PRESSED, r16
		rjmp end_timer1

	upButton:
		ldi r16, 'U'
		sts LAST_BUTTON_PRESSED, r16
		rjmp end_timer1

	downButton:
		ldi r16, 'D'
		sts LAST_BUTTON_PRESSED, r16
		rjmp end_timer1

	leftButton:
		ldi r16, 'L'
		sts LAST_BUTTON_PRESSED, r16
		rjmp end_timer1
	
	rightButton:
		ldi r16, 'R'
		sts LAST_BUTTON_PRESSED, r16
		rjmp end_timer1

	nobutton: 
		ldi r16, 0
		sts BUTTON_IS_PRESSED, r16
		;rjmp end_timer1

	end_timer1:
		pop r16
		reti

; timer3:
;
; Note: There is no "timer3" interrupt handler as you must use
; timer3 in a polling style (i.e. it is used to drive the refreshing
; of the LCD display, but LCD functions cannot be called/used from
; within an interrupt handler).


timer4: ; INTURRUPT HANDLER
	push r30
	push r31
	push r16
	push r17

	;Start at zero, when the right button is pressed we want to increment char index
	; When the left button is pressed we want to decrement char index
	; When we press up button we want to go to the charset index and increment it
	
	lds r16, BUTTON_IS_PRESSED
	cpi r16, 0
	breq end_timer4
	lds r16, LAST_BUTTON_PRESSED
	cpi r16, 'D'
	breq downButtonPressed
	cpi r16, 'U'
	breq upButtonPressed

	downButtonPressed:
		lds r16, CURRENT_CHARSET_INDEX 
		cpi r16, 0
		breq skip1
		dec r16
		skip1:
		sts CURRENT_CHARSET_INDEX, r16
		rjmp setTopContent

	upButtonPressed:
		lds r16, CURRENT_CHARSET_INDEX 
		lds r17, STRING_SIZE
		cp r16, r17
		breq skip2
		inc r16
		skip2:
		sts CURRENT_CHARSET_INDEX, r16
		rjmp setTopContent
	
	setTopContent:
		ldi r30, low(AVAILABLE_CHARSET*2)
		ldi r31, high(AVAILABLE_CHARSET*2)
		lds r16, CURRENT_CHARSET_INDEX
		add r30, r16
		clr r16
		adc r31, r16
		lpm r16, Z
		sts TOP_LINE_CONTENT, r16
	
	end_timer4:
		pop r17
		pop r16
		pop r31
		pop r30
		reti


; ****************************************************
; ******* END OF SECOND "STUDENT CODE" SECTION *******
; ****************************************************


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; r17:r16 -- word 1
; r19:r18 -- word 2
; word 1 < word 2? return -1 in r25
; word 1 > word 2? return 1 in r25
; word 1 == word 2? return 0 in r25
;
compare_words:
	; if high bytes are different, look at lower bytes
	cp r17, r19
	breq compare_words_lower_byte

	; since high bytes are different, use these to
	; determine result7
	;
	; if C is set from previous cp, it means r17 < r19
	; 
	; preload r25 with 1 with the assume r17 > r19
	ldi r25, 1
	brcs compare_words_is_less_than
	rjmp compare_words_exit

compare_words_is_less_than:
	ldi r25, -1
	rjmp compare_words_exit

compare_words_lower_byte:
	clr r25
	cp r16, r18
	breq compare_words_exit

	ldi r25, 1
	brcs compare_words_is_less_than  ; re-use what we already wrote...

compare_words_exit:
	ret

.cseg
AVAILABLE_CHARSET: .db "0123456789abcdef_", 0


.dseg

BUTTON_IS_PRESSED: .byte 1			; updated by timer1 interrupt, used by LCD update loop
LAST_BUTTON_PRESSED: .byte 1        ; updated by timer1 interrupt, used by LCD update loop

TOP_LINE_CONTENT: .byte 16			; updated by timer4 interrupt, used by LCD update loop
CURRENT_CHARSET_INDEX: .byte 16		; updated by timer4 interrupt, used by LCD update loop
CURRENT_CHAR_INDEX: .byte 1			; ; updated by timer4 interrupt, used by LCD update loop


; =============================================
; ======= END OF "DO NOT TOUCH" SECTION =======
; =============================================


; ***************************************************
; **** BEGINNING OF THIRD "STUDENT CODE" SECTION ****
; ***************************************************

.dseg
CHAR_Zero: .byte 1
CHAR_ONE: .byte 1
STRING_SIZE: .byte 1

; If you should need additional memory for storage of state,
; then place it within the section. However, the items here
; must not be simply a way to replace or ignore the memory
; locations provided up above.


; ***************************************************
; ******* END OF THIRD "STUDENT CODE" SECTION *******
; ***************************************************