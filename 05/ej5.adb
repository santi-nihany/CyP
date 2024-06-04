--  5. En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos
--  de U Usuarios de a uno a la vez y de acuerdo al orden en que se hacen los pedidos. Cada
--  usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la respuesta
--  del mismo que le indica si está todo bien o hay algún error. Mientras haya algún error vuelve
--  a trabajar con el documento y a enviarlo al servidor. Cuando el servidor le responde que
--  está todo bien el usuario se retira. Cuando un usuario envía un pedido espera a lo sumo 2
--  minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto y vuelve a
--  intentarlo (usando el mismo documento)

Procedure Universidad is

task type usuario;
task servidor is
    entry pedido(p: in text; ok: out boolean);
end;

task body usuario is
    okU: boolean;
    p: String;
begin
    loop                                          -- loop para enviar pedidos
        p:= nuevoPedido();                        -- genero nuevo pedido
        okU:= false;
        while(not okU) loop                       -- mientras el servidor responda not ok 
            select
                servidor.pedido(p, okU);     -- envio pedido
                if(not okU)then
                    p:= corregir();
                end if;
            or  delay (120);
                delay(60);                  -- si espero 2 min y no responde, espero 1 min más
            end select;
        end loop;
    end loop;
end usuario;

task body servidor is 
begin
    loop
        accept pedido(p: in text; ok: out boolean) do
            ok := itsOk(p);
        end pedido;
    end loop;
end servidor;

usuarios: array(1..U) of usuario; 
Begin

end Universidad;