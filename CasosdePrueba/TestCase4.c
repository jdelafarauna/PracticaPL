#include <stdio.h>



void main(void) {
    int i,total;
    total = 0;
    for (i = 1; i <= 5; i++) {
        total = (total + i);
    }
    while (total < 20) {
        total = (total + 2);
    }
    do {
        total = (total - 1);
    } while (!(total == 10));
    return 0;
}
