--  1. Se requiere modelar un puente de un solo sentido, el puente solo soporta el peso de 5
--  unidades de peso. Cada auto pesa 1 unidad, cada camioneta pesa 2 unidades y cada camión
--  3 unidades. Suponga que hay una cantidad innumerable de vehículos (A autos, B
--  camionetas y C camiones).
--  a. Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.
--  b. Modifique la solución para que tengan mayor prioridad los camiones que el resto de los
--  vehículos

procedure Puente is

    task type auto;
    task type camioneta;
    task type camion;

    task puenteT is
        entry pasoAuto;
        entry pasoCamioneta;
        entry pasoCamion;
        entry salida (peso : in Integer);
    end puenteT;

    task body auto is
        peso : constant Integer := 1;
    begin
        puenteT.pasoAuto;
        --  usarPuente();
        puenteT.salida (peso);
    end auto;

    task body camioneta is
        peso : constant Integer := 2;
    begin
        puenteT.pasoCamioneta;
    end camioneta;

    task body camion is
        peso : constant Integer := 3;
    begin
        puenteT.pasoCamion;
    end camion;

    task body puente is
        pesoTotal : Integer;
    begin
        pesoTotal := 0;
        loop
            select
                accept salida (peso : in Integer) do
                    pesoTotal := pesoTotal - peso;
                end salida;
            or when (pesoTotal + 1 <= 5 and pasoCamion'Count = 0) =>
                accept pasoAuto;
            or when (pesoTotal + 2 <= 5 and pasoCamion'Count = 0) =>
                accept pasoCamioneta;
            or when (pesoTotal + 3 <= 5) =>
                accept pasoCamion;
            end select;
        end loop;
    end puente;

    A          : constant Integer := 10;
    B          : constant Integer := 15;
    C          : constant Integer := 5;
    autos      : array (1 .. A) of auto;
    camionetas : array (1 .. B) of camioneta;
    camiones   : array (1 .. C) of camion;
begin
    null;
end Puente;
