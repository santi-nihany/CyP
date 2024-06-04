--  6. En una playa hay 5 equipos de 4 personas cada uno (en total son 20 personas donde cada
--  una conoce previamente a que equipo pertenece). Cuando las personas van llegando
--  esperan con los de su equipo hasta que el mismo esté completo (hayan llegado los 4
--  integrantes), a partir de ese momento el equipo comienza a jugar. El juego consiste en que
--  cada integrante del grupo junta 15 monedas de a una en una playa (las monedas pueden ser
--  de 1, 2 o 5 pesos) y se suman los montos de las 60 monedas conseguidas en el grupo. Al
--  finalizar cada persona debe conocer grupo que más dinero junto. Nota: maximizar la
--  concurrencia. Suponga que para simular la búsqueda de una moneda por parte de una
--  persona existe una función Moneda() que retorna el valor de la moneda encontrada.

procedure Playa is 

task type persona is
    entry identificador(idP: in integer);
    entry comienza;
    entry ganador(e: in integer);
end persona;
task type equipo is
    entry llegada(idP: in Integer);
    entry monedas(valor: in integer);
end equipo;

task admin is 
    entry equipoTotal(idE: in Integer; total: in Integer);
end admin;

personas: array(1..20) of persona;
equipos: array(1..5) of equipo;

task body persona is 
    i, idP, idEquipo, suma: Integer;
begin
    accept identificador(idP: in Integer);
    equipos(idEquipo).llegada(idP);
    accept comienza;
    suma:=0;
    for i in 1..15 loop
        --  suma:= suma + Moneda();
    end loop;
    equipos(idEquipo).monedas(suma);

    accept ganador(e: in Integer);
end persona;

task body equipo is
    arr: array(1..4) of Integer;
    i, total, idE: Integer;
begin
    for i in 1..4 loop
        accept llegada(idP: in integer) do  --registro llegada
            arr(i) := idP;
        end llegada;
    end loop;
    for i in 1..4 loop                      -- aviso incio a los 4 integrantes 
        personas(arr(i)).comienza;
    end loop;
    
    total:= 0;
    for i in 1..4 loop                      -- sumo el total de los 4 integrantes
        accept monedas(valor: in Integer) do
            total:= total + valor;
        end monedas;
    end loop;

    admin.equipoTotal(idE, total);
end equipo;

task body admin is
    i, maxId, maxVal: Integer;
begin
    maxVal:= -1;
    for i in 1..5 loop
        accept equipoTotal(idE: in Integer; total: in Integer) do 
            if(total > maxVal)then
                maxId:= idE;
                maxVal:= total;
            end if;
        end equipoTotal;
    end loop;

    for i in 1..20 loop
        personas(i).ganador(maxId);
    end loop;
end admin;


begin

end Playa;