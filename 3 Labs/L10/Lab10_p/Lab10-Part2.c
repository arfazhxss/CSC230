/*
 * Lab10_p.c
 *
 * Created: 4/2/2023 3:48:02 AM
 * Author : arfaz
 */ 

//#include <avr/io.h>
#include "CSC230.h"
#include <string.h>
#include <stdlib.h>


int main(void)
{
	lcd_init();
	while (1) {
		char line1[15]="OneTwoThreFour";
		int size = strlen(line1);
		char line2[14];
		itoa(size,line2,10);
		lcd_xy(1,0);
		lcd_puts(line1);
		lcd_xy(1,1);
		lcd_puts(line2);
		_delay_ms(1000);
		//char line[15] = "";
		//lcd_xy(1,0);
		//lcd_puts(line);
		//lcd_xy(1,1);
		//lcd_puts(line);
		lcd_init();
		_delay_ms(1000);
	}
}

