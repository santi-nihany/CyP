--  8. Una empresa de limpieza se encarga de recolectar residuos en una ciudad por medio de 3
--  camiones. Hay P personas que hacen continuos reclamos hasta que uno de los camiones
--  pase por su casa.
--  Cada persona hace un reclamo, espera a lo sumo 15 minutos a que llegue un camión y si no,
--  vuelve a hacer el reclamo y a esperar a lo sumo 15 minutos a que llegue un camión y así
--  sucesivamente hasta que el camión llegue y recolecte los residuos; en ese momento deja de
--  hacer reclamos y se va.
--  Cuando un camión está libre la empresa lo envía a la casa de la persona que más reclamos
--  ha hecho sin ser atendido. Nota: maximizar la concurrencia.

procedure Limpieza is

    task type camion;
    task type persona is
        entry identificador (id : in Integer);
        entry atencion (basura : out String);
    end persona;
    task admin is
        entry reclamo (idP : in Integer);
        entry libre (idP : out String);
    end admin;

    task body admin is
        reclamos : array (1 .. P) of Integer;
    begin
        loop
            select
                accept reclamo (idP : in String) do
                    reclamos (idP) := reclamos (idP) + 1;
                end reclamo;
            or when (not (max = -1)) =>
                accept libre (idP : out String) do
                    idP := max;
                end libre;
                reclamos (idP) := -1;
            end select;
            max := actualizarMax (reclamos, max);
        end loop;
    end admin;

    task body camion is
        idP : Integer;
        b   : String;
    begin
        loop
            admin.libre (idP);
            personas (idP).atencion (b);
            recolectar (b);
        end loop;
    end camion;

    task body persona is
        id : Integer;
        ok : Boolean;
        b  : String;
    begin
        accept identificador (id);
        ok := False;
        b  := "basura";
        while (not ok) loop
            admin.reclamo (id);
            select
                accept atencion (basura : out String) do
                    basura := b;
                end atencion;
                ok := True;
            or
                delay (900);
                null;
            end select;
        end loop;
    end persona;

    personas : array (1 .. N) of persona;
    camiones : array (1 .. 3) of camion;

begin
    for j in 1 .. P loop
        personas (j).identificador (j);
    end loop;
end Limpieza;
