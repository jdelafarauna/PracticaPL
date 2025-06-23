#include <stdio.h>

#define MAX_USERS 100
#define PI 3.1416
#define MESSAGE "Bienvenido al sistema"


void main(void) {
    int edad,contador;
    float salario;
    edad = 25;
    contador = 1;
    salario = 1500.50;
    writeln("Máximo de usuarios : ", MAX_USERS);
    writeln("Valor de PI        : ", PI);
    writeln("Mensaje            : ", MESSAGE);
    writeln();
    writeln("Edad               : ", edad);
    writeln("Contador           : ", contador);
    writeln("Salario            : $", salario);
    return 0;
}
