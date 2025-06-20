program Test4;

var
    i, total : INTEGER;

begin
    total := 0;

    { bucle FOR }
    for i := 1 to 5 do
        begin
            total := total + i;
        end;

    { bucle WHILE }
    while total < 20 do
        begin
            total := total + 2;
        end;

    { bucle REPEAT-UNTIL }
    repeat
        total := total - 1;
    until total = 10;

end.

