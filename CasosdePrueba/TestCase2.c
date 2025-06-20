#include <stdio.h>


void NoParamProc() {
    int a;
    a = (GLOB1 / GLOB2);
    writeln('NoParamProc a: ');
}

int NestedCalls(int p) {
    t = (GLOB1 % GLOB2);
    t = (p * ((GLOB1 % GLOB2)));
    return (t + NestedCalls((p / 2)));
}
float RealMath(float r) {
    float r2,r3;
    r2 = (((r + 1.0)) * 2.5);
    r3 = r2;
    return (r3 - r);
}
void DuplicateNames() {
    int x;
    float y;
    x = (x + GLOB2);
    y = RealMath(x);
    writeln('Duplicate x: ');
    writeln('Calc y: ');
}
#define GLOB1 42
#define GLOB2 7
#define GLOB3 100
#define GLOB4 3

void main(void) {
    int x,y;
    float z,w;
    NoParamProc();
    writeln('After NoParamProc');
    z = NestedCalls(GLOB1);
    writeln('NestedCalls result: ');
    w = RealMath(z);
    writeln('RealMath result: ');
    DuplicateNames(5);
    writeln('End ofTest4');
    return 0;
}
