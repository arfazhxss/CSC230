#include <stdio.h>

#define NUM_COLS 5
#define MAX_NUMS 100

void multiply_by_scalar_table_2d(int table[][NUM_COLS], int num_rows, int num_cols, int scalar);
void multiply_by_scalar_table_ptrs(int* table[], int num_rows, int num_cols, int scalar);
int table_max_2d(int table[][NUM_COLS], int num_rows, int num_cols);
int table_max_ptrs(int* table[], int num_rows, int num_cols);
void get_location_of_min_2d(int table[][NUM_COLS], int num_rows, int num_cols, int* location_row, int* location_col);
void get_location_of_min_ptrs(int* table[], int num_rows, int num_cols, int* location_row, int* location_col);
int read_to_array(FILE* file_handle, int array[]);
void write_from_array(FILE* file_handle, int array[], int len);

/* Purpose: prints the elements in array2d, elements separated by commas
 *            and rows separated by newlines
 * Parameters: int table[][NUM_COLS] - the 2d array of elements, num_row by num_cols
 *             int num_rows - the number of elements in the array
 *             int num_cols - the number columns >=0 and <=NUM_COLS
 * NOTE: This function should use the provided helper function above. See print_table_ptrs for an example
 */
void print_table_2d(int table[][NUM_COLS], int num_rows, int num_cols) {
    //Your code here
}

/* Purpose: prints the elements in array separated by commas
 * Parameters: int array[] - the array of elements
 *             int len - the number of elements in the array
 */
void print_array (int array[], int len) {
    int i = 0;
    for (i = 0; i < len; i++){
        printf("%d", array[i]);
        if (i!=len-1) {
            printf(",");
        }
    }
    printf("\n");
}

/* Purpose: prints the elements in array_ptrs, elements separated by commas
 *            and rows separated by newlines
 * Parameters: int* table[] - an array of num_rows arrays that are each num_cols long
 *             int num_rows - the number of elements in the array
 *             int num_cols - the number columns >=0
 */
void print_table_ptrs(int* table[], int num_rows, int num_cols) {
    int row = 0;
    for (row = 0; row < num_rows; row++){
        print_array(table[row], num_cols);
    }
}

/* Purpose: multiply every elements in array by muliplier
 * Parameters: int array[] - the array of elements
 *             int len - the number of elements in the array
 *             int multiplier
 */
void multiply_by(int array[], int len, int multiplier){
    int i = 0;
    for (i = 0; i < len; i++){
        array[i] *= multiplier;
    }
}

int main() {
    int a3[3] = {6, 5, 4};
    int b3[3] = {2, 1, 5};
    int a4[4] = {1, 6, 0, 2};
    int b4[4] = {2, 3, -6, 2};
    int c4[4] = {1, 2, -3, 5};
    
    int* table_ptrs_2by3[]= {a3, b3};
    int* table_ptrs_3by4[]= {a4, b4, c4};

    int table_2d_6byNUMCOLS[6][NUM_COLS] = {{37, 83,   75,  23,   71},
                                           {3,  14,   15,   3,    2},
                                           {65,  3,   58,  79,    3},
                                           {2,  38,   86,  26,    4},
                                           {3,   3,    8,   3,    2},
                                           {88, 10,   36,  11,    6}};

    int table_2d_2by4[2][NUM_COLS] = {{3,  3,  8,  3},
                                     {88, 10, 36, 11}};
    
    printf("test multiply_by_scalar_table_2d table_2d_6byNUMCOLS:\n");
    multiply_by_scalar_table_2d(table_2d_6byNUMCOLS, 6, 5, 10);
    print_table_2d(table_2d_6byNUMCOLS, 6, 5);

    printf("test multiply_by_scalar_table_ptrs table_2d_2by4:\n");
    multiply_by_scalar_table_2d(table_2d_2by4, 2, 4,-2);
    print_table_2d(table_2d_2by4, 2, 4);

    int max_2d;
    max_2d = table_max_2d(table_2d_6byNUMCOLS, 6, 5);
    printf("test table_max_ptr table_2d_6byNUMCOLS: %d\n", max_2d);

    max_2d = table_max_2d(table_2d_2by4, 2, 4);
    printf("test table_max_ptr table_2d_2by4: %d\n", max_2d);

    return 0;
}

void multiply_by_scalar_table_2d(int table[][NUM_COLS], int num_rows, int num_cols, int scalar) {
    for(int row=0; row<num_rows; row++) {
        for(int col=0; col<num_cols; col++) {
            printf("%d", scalar*table[row][col]);
            if (col<(num_cols-1)) {
                printf(", ");
            }
        }
        printf("\n");
    }
}

int table_max_2d(int table[][NUM_COLS], int num_rows, int num_cols) {
    int max = 0;
    for(int row=0; row<num_rows; row++) {
        for(int col=0; col<num_cols; col++) {
        if (table[row][col]>max) {
            max = table[row][col];
        }
        }
    }    
    printf("max is: %d\n", max);
    return max;
}


    /* TODO 5:
    implement and test the function get_location_of_min_ptrs according to the following description:
    - this function finds the location of the smallest value in matrix and
    stores the row and column of that location to memory pointed to by location_row and location_col
    - if the smallest value occurs in more than one row, choose the location with the lowest row number
    - if the smallest value occurs more than once in that row, choose the location with the lowest column number
    NOTE: output is dependant on current values in arrays passed,
         as multiply_by_scalar_table_ptrs would have changed them if above tests left uncommented
    */

void get_location_of_min_ptrs(int* table[], int num_rows, int num_cols, int* location_row, int* location_col) {
    int min = 0;
    for(int row=0; row<num_rows; row++) {
        *location_row = *table[row][col];
        for(int col=0; col<num_cols; col++) {
            *location_col = *table[row][col];
        }
    }  
}
