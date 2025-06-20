program Test4;

const
    GLOB1 = 42;
    GLOB2 = 7;

var
    x, y    : INTEGER;
    z, w    : REAL;

procedure NoParamProc;

var
    a : INTEGER;
begin
    a := GLOB1 div GLOB2;
    writeln('NoParamProc a: ', a);
end;

const
    GLOB3 = 100;
    GLOB4 = 3;

function NestedCalls(p: INTEGER): INTEGER;

begin
    t := GLOB1 mod GLOB2;              { expresión mod con paréntesis omitidos }
    t := p * (GLOB1 mod GLOB2);        { mod dentro de paréntesis }
    NestedCalls := t + NestedCalls(p div 2);
end;

function RealMath(r: REAL): REAL;
var
    r2, r3 : REAL;
begin
    r2 := (r + 1.0) * 2.5;             { literales reales permitidos como factor }
    r3 := r2;                          { evitamos división real }
    RealMath := r3 - r;                { resta real }
end;

procedure DuplicateNames;
var
    x : INTEGER;                       { mismo nombre parámetro y local }
    y : REAL;
begin
    x := x + GLOB2;                    { x local sombreando parámetro }
    y := RealMath(x);                  { llamada a función real en proc }
    writeln('Duplicate x: ', x);
    writeln('Calc y: ', y);
end;

begin
    NoParamProc();
    writeln('After NoParamProc');

    z := NestedCalls(GLOB1);
    writeln('NestedCalls result: ', z);

    w := RealMath(z);
    writeln('RealMath result: ', w);

    DuplicateNames(5);
    writeln('End ofTest4');
end.