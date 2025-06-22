program TestFuncionesProcedimientos;

function fun1 ( a:INTEGER ; b:REAL ) : INTEGER
begin
    proc2;
end;

function fun2() : REAL
begin
    proc1(1.3 , -4);
end;

procedure proc1 ( c:REAL ; d:INTEGER )
begin
    valor := fun1(1 , 1.0);
end;


procedure proc2
begin
    valor := fun2;
end;

const
   MAX_USERS = 100;
   PI        = 3.1416;
   MESSAGE   = 'Bienvenido al sistema';

var
   edad, contador : INTEGER;
   salario        : REAL;

begin
   edad     := 25;
   contador := 1;
   salario  := 1500.50;

   writeln('Máximo de usuarios : ', MAX_USERS);
   writeln('Valor de PI        : ', PI);
   writeln('Mensaje            : ', MESSAGE);
   writeln;

   writeln('Edad               : ', edad);
   writeln('Contador           : ', contador);
   writeln('Salario            : $', salario);
end.