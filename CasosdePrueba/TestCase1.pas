program Test1;

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


