.cseg
.org 0

	ldi R16, 0xFF
	sts DDRL, R16 ; DATA DIRECTION REGISTRAR
	out DDRB, R16

	ldi R16, 0b10000000
	sts PORTL, R16
	ldi R16, 0b00001010
	out PORTB, R16
done: jmp done