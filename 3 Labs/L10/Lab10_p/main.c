/*
 * Lab10_p.c
 *
 * Created: 4/2/2023 3:48:02 AM
 * Author : arfaz
 */ 

//#include <avr/io.h>
#include "CSC230.h"


int main(void)
{
	DDRL = 0xFF;
	DDRB = 0xFF;
    PORTL = 0b10101010;
    PORTB = 0b00001010;
    _delay_ms(500);
    while (1) 
    {
		PORTL = 0b00000000;
		PORTB = 0b00000000;
		_delay_ms(1000);
		PORTL = 0b10101010;
		PORTB = 0b00001010;
		_delay_ms(1000);
    }
	return 1;
}

