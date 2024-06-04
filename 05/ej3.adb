--  3. Se dispone de un sistema compuesto por 1 central y 2 procesos. Los procesos envían
--  señales a la central. La central comienza su ejecución tomando una señal del proceso 1,
--  luego toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
--  señal de proceso 2, recibe señales del mismo proceso durante 3 minutos.
--  El proceso 1 envía una señal que es considerada vieja (se deshecha) si en 2 minutos no fue
--  recibida.
--  El proceso 2 envía una señal, si no es recibida en ese instante espera 1 minuto y vuelve a
--  mandarla (no se deshecha).

procedure Sistema is

    task P1;
    task P2;
    task central is
        entry senialP1 (data : in String);
        entry senialP2 (data : in String);
        entry tresmin;
    end central;
    task timer is
        entry init;
    end timer;

    task body central is
        turno2 : Boolean;
        s      : String;
    begin
        accept senialP1 (data : in String) do
            s := data;
        end senialP1;
        --  procesar(s);
        loop
            select
                accept senialP1 (data : in String) do
                    s := data;
                end senialP1;
                --  procesar(s);
            or
                accept senialP2 (data : in String) do
                    s := data;
                end senialP2;
                --  procesar(s);
                timer.init;
                turno2 := True;
                while (turno2) loop
                    select
                        accept tresmin;
                        turno2 := False;
                    or when (tresmin'Count = 0) =>
                        accept senialP1 (data : in String) do
                            s := data;
                        end senialP1;
                        --  procesar(s);
                    end select;
                end loop;
            end select;
        end loop;
    end central;

    task body timer is
    begin
        loop
            accept init;
            delay (180.0);
            central.tresmin;
        end loop;
    end timer;

    task body P1 is
        data : String;
    begin
        loop
            data := "nueva señal";
            select
                central.senialP1 (data);
            or
                delay 120.0;
                null;
            end select;
        end loop;
    end P1;

    task body P2 is
        ok   : Boolean;
        data : String;
    begin
        ok   := False;
        data := "nueva señal";
        loop
            if (ok) then
                data := "nueva señal";
            end if;
            select
                central.senialP2 (data);
                ok := True;
            else
                delay (60.0);
                ok := False;
            end select;
        end loop;
    end P2;

begin
    null;
end Sistema;
