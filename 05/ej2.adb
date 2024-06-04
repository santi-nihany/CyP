--  2. Se quiere modelar la cola de un banco que atiende un solo empleado, los clientes llegan y si
--  esperan más de 10 minutos se retiran

procedure Banco is

Task type cliente;
task banco is 
    entry llegada(consulta: IN String; respuesta: OUT String);
end banco;

Task body cliente is
    res: String;
begin
    select 
        banco.llegada("Hola BRODER", res);
    or delay 600.0
        null;
    end select;
end cliente;

Task body banco is
begin
    loop
        accept llegada(consulta: IN String; respuesta: OUT String) do 
            respuesta:= "Resuelto brooo";
        end llegada;
    end loop;
end;

clientes: array(1..10) of cliente;

begin
    null;
end Banco;