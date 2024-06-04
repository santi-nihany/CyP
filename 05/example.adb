procedure Programa is

task nombreT1 is
    ENTRY nombreE1(A,B: IN Integer; C:OUT Character; D: IN OUT Boolean);
end nombreT1;

task type nombreTipoT is 
    ENTRY nombreE2;
end nombreTipoT;

TASK BODY nombreT1 is
begin
    Accept nombreE1(A,B: IN Integer; C:OUT Character; D: IN OUT Boolean) do
        if (a + b > 5) then
            C:= 'a';
        else 
            C:= 'j';
        end if;
    end nombreE1;
end nombreT1;

TASK BODY nombreTipoT is
begin
    accept nombreE2;
end nombreTipoT;

begin
    -- Programa principal
End Programa;
