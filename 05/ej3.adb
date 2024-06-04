--  3. Se dispone de un sistema compuesto por 1 central y 2 procesos. Los procesos envían
--  señales a la central. La central comienza su ejecución tomando una señal del proceso 1,
--  luego toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
--  señal de proceso 2, recibe señales del mismo proceso durante 3 minutos.
--  El proceso 1 envía una señal que es considerada vieja (se deshecha) si en 2 minutos no fue
--  recibida.
--  El proceso 2 envía una señal, si no es recibida en ese instante espera 1 minuto y vuelve a
--  mandarla (no se deshecha).

Procedure Sistema is

task P1;
task P2;
task central is 
    entry senialP1(data: IN String);
    entry senialP2(data: IN String);
    entry tresmin;
end central;
task timer is
    entry init;
end timer;

task body central is 
    turno2: boolean;
    s: String;
begin
    accept senialP1(data: IN String) do
        s:= data;
    end senialP1;
    --  procesar(s);
    loop
        select
            accept senialP1(data: IN String) do
                s:= data;
            end senialP1;
            --  procesar(s);
        or
            accept senialP2(data: IN String) do
                s:= data;
            end senialP2;
            --  procesar(s);
            timer.init;
            turno2:= true;
            while(turno2) loop
                select
                    accept tresmin;
                    turno2:= false;
                or
                    when(tresmin'count = 0) =>  accept senialP1(data: IN String) do
                                                    s:= data;
                                                end senialP1;
                                                --  procesar(s);
            end loop;
        end select
    end loop;
end central;

task body timer is
begin
    loop
        accept init;
        delay(180.0);
        central.tresmin; 
    end loop;
end;

task body P1 is
    data: string;
begin
    loop
        data:= "nueva señal";
        select
            central.senialP1(data);
        or delay 120.0
            null;
        end select;
    end loop;
end P1;

task body P2 is
    ok: boolean;
    data: string;
begin
    ok:=false;
    data:= "nueva señal";
    loop
        if(ok) data:= "nueva señal";
        select
            central.senialP2(data);
            ok:= true;
        else
            delay(60.0);
            ok:= false;
        end select;
    end loop;
end P2;

Begin
    null;
end Sistema;