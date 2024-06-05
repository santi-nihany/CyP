--  8. Una empresa de limpieza se encarga de recolectar residuos en una ciudad por medio de 3
--  camiones. Hay P personas que hacen continuos reclamos hasta que uno de los camiones
--  pase por su casa. 
--  Cada persona hace un reclamo, espera a lo sumo 15 minutos a que llegue un camión y si no,
--  vuelve a hacer el reclamo y a esperar a lo sumo 15 minutos a que llegue un camión y así 
--  sucesivamente hasta que el camión llegue y recolecte los residuos; en ese momento deja de
--  hacer reclamos y se va.
--  Cuando un camión está libre la empresa lo envía a la casa de la persona que más reclamos 
--  ha hecho sin ser atendido. Nota: maximizar la concurrencia.

Procedure Limpieza is

task type camion;
task type persona is
    entry atencion(basura: out string);
end persona;
task admin is
    entry reclamo(idP: in Integer);
    entry libre(idP: out string);
end admin;


task body admin is 
    reclamos: array(1..P) of Integer;
begin
    loop
        select
            accept reclamo(idP: in String) do
                reclamos(idP) := reclamos(idP) + 1;
            end reclamo;
        or
            when(not(max = -1)) =>
                accept libre(idP: out string) do
                    idP:= max;
                end libre;
                reclamos(idP):= -1;
        end select;
        max:= actualizarMax(reclamos, max);
    end loop;
end admin;

task body camion is
    idP: integer;
    b: string;
begin
    loop
        admin.libre(idP);
        personas(idP).atencion(b);
        recolectar(b);
    end loop;
end camion;

task body persona is
    rec: Integer;
    ok: boolean;
    b: string;
begin
    ok:= false;
    b:="basura";
    while(not ok) loop
        admin.reclamo(id);
        select
            accept atencion(basura:out string) do
                basura:= b;
            end atencion;
            ok:=true;
        or  delay(900);
            null;
        end select;
    end loop;
end persona;

personas: array(1..N) of persona;
camiones: array(1..3) of camion;

begin

end Limpieza;