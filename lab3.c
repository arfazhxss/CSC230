#include <stdio.h>

void print_reverse(int array[], int size);
int contains_odds(int array[], int size);
void multiply_by(int array1[], int size, int arg);

int main() {
    in   t array[5] = {1, 2, 3, 4, 5};
    multiply_by(array, 5, 5);
    return 0;
}

void print_reverse(int array[], int size) {
    for(int i=size-1; i>-1; i--) {
        printf("%d", array[i]);
        if (i!= 0) {
            printf(", ");
        }
    }
}

int contains_odds(int array[], int size) {
    int val = 0;
    for (int i=0; i<size-1; i++) {
    int num = array[i];
    if ((num%2)!=0) {
        val = 1;
    }

    }
    return val;
}

void multiply_by(int array1[], int size, int arg) {
    for (int i =0; i<size; i++) {
    array1[i]=array1[i]*arg;
    printf("%d ", array1[i]);
    }
}