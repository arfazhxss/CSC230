#include <stdio.h>
void print_northern_season(int month, int day);

int main() {
    print_northern_season(6, 10);
    
    return 0;
}

void print_northern_season(int month, int day) {
    
    if (((month == 12) && (day >= 21) && (day <= 31)) || (month == 1) || (month == 2) || ((month == 3) && (day < 20))) {
        printf("Winter\n");
    } else if (((month == 3) && (day >= 20) && (day <= 31)) || (month == 4) || (month == 5) || ((month == 6) && (day < 21))) {
        printf("Spring\n");
    } else if (((month == 6) && (day >= 21) && (day <= 31)) || (month == 7) || (month == 8) || ((month == 9) && (day < 22))) {
        printf("Summer\n");
    } else if (((month == 9) && (day >= 21) && (day <= 31)) || (month == 10) || (month == 11) || ((month == 12) && (day < 21))) {
        printf("Autumn\n");
    }
}