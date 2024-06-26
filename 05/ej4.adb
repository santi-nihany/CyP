--  4. En una clínica existe un médico de guardia que recibe continuamente peticiones de
--  atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la
--  clínica ser atendidos.
--  Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo
--  haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del
--  médico. Si no es atendida tres veces, se enoja y se retira de la clínica.
--  Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente
--  le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el
--  momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la
--  petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa
--  trabajando y haciendo más peticiones.
--  El médico atiende los pedidos teniendo dándoles prioridad a los enfermos que llegan para ser
--  atendidos. Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto
--  tiempo. Cuando está libre aprovecha a procesar las notas dejadas por las enfermeras.

procedure Clinica is

    task medico is
        entry pedidoP (p : in String; res: out String);
        entry pedidoE (p : in String; res: out String);
        entry nota(nota: in String);
    end medico;
    task type persona;
    task type enfermera is
        entry dejarNota(nota: out String);
    end enfermera;
    task consultorio;


    task body medico is
        resLocal     : String;
    begin
        resLocal:= "default";
        loop
            select
                accept pedidoP (p : in String; res: out String) do     -- prioridad: recibo pedido de persona
                    -- res:= procesar(p);                                   -- envío respuesta
                end pedidoP;
            or when (pedidoP'Count = 0) =>                              -- si no hay pedido de persona
                accept pedidoE (p : in String; res : out String) do         -- recibo pedido de enfermera
                    -- res:= procesar(p);                                   -- envío respuesta
                end pedidoE;
            or when (pedidoP'Count = 0 and pedidoE'Count = 0) =>        -- si no hay pedido de persona ni enfermera
                accept nota(nota: in string) do            -- recibo nota pendiente
                    -- procesar(nota);
                end nota;
            end select;
        end loop;
    end medico;

    task body consultorio is 
        c: cola;     -- cola de notas pendientes 
        n: String;   -- nota lectura
        priN:String; -- primera nota pendiente
    begin
        priN:="vacio";
        loop
            select
                enfermera.dejarNota (n);        -- enfermera envia nota
                if(priN = "vacio")then          -- si no hay notas pendientes
                    priN:= n;                       -- actualizo primera nota
                else                            -- sino (si hay notas pendientes)
                    push(c, n);                -- encolo nota
                end if;
            else                                    -- si no envian nada instantaneamente
                if(not (priN = "vacio"))then            -- si hay nota pendiente
                    select
                        medico.nota(priN);           -- envio nota pendiente a medico (si esta listo para recibir)
                        -- actualizo primera nota pendiente
                        if(not empty(c))then
                            pop(c,n);
                            priN:= n;
                        else
                            priN:= "vacio";
                        end if;
                    else 
                        null;
                    end select;
                end if;
            end select;
        end loop;
    end consultorio;

    task body persona is
        count : Integer;
        res   : String;
    begin
        count := 0;
        while (count < 3) loop
            count := count + 1;
            select
                medico.pedidoP ("pedido", res);
                count := 3;
            or
                delay (300); -- 5min
                if (count < 3) then
                    delay (600); -- 10min
                end if;
            end select;
        end loop;
    end persona;

    task body enfermera is
        res : String;
    begin
        loop
            select 
                medico.pedidoE ("pedido", res);                             -- si medico esta libre para recibir pedido, envio pedido
            else                                                            -- sino
                accept dejarNota(notaE: out String) do                          -- envío nota a consultorio
                    notaE:="pedido";
                end dejarNota;
            end select;
        end loop;
    end enfermera;
    
    personas   : array (1 .. P) of persona;
    enfermeras : array (1 .. E) of enfermera;
begin
    null;
end Clinica;

--  notas:
--      - medico recibe y resuelve dentro del accept, ya que no tiene nada mas que hacer en ese momento y sus clientes tampoco.
--      - para persona: Una vez que el medico acepta, se bloquea esperando la respuesta. No continúa el delay.
--        Si no se envía respuesta con res: out es error grave ya que no es rendezvous, sino PMS.
--      - uso variable pri en la task consultorio para poder enviar al medico la nota sin necesidad de hacer un pop de la cola.
--        Puede pensarse como nota "actual", proxima a ser enviada.
--      - enfermera deja nota y continua con su trabajo, no debe esperar a recibir respuesta.
--        Si lo hiciera, cumpliría el mismo rol que esperar la respuesta al pedido.