--  7. Hay un sistema de reconocimiento de huellas dactilares de la policía que tiene 8 Servidores
--  para realizar el reconocimiento, cada uno de ellos trabajando con una Base de Datos propia;
--  a su vez hay un Especialista que utiliza indefinidamente. El sistema funciona de la
--  siguiente manera: el Especialista toma una imagen de una huella (TEST) y se la envía a los
--  servidores para que cada uno de ellos le devuelva el código y el valor de similitud de la
--  huella que más se asemeja a TEST en su BD; al final del procesamiento, el especialista debe
--  conocer el código de la huella con mayor valor de similitud entre las devueltas por los 8
--  servidores. Cuando ha terminado de procesar una huella comienza nuevamente todo el
--  ciclo. Nota: suponga que existe una función Buscar(test, código, valor) que utiliza cada Servidor
--  donde recibe como parámetro de entrada la huella test, y devuelve como parámetros de
--  salida el código y el valor de similitud de la huella más parecida a test en la BD correspondiente.
--  Maximizar la concurrencia y no generar demora innecesaria.

procedure Policia is

    task type servidor;
    task especialista is
        entry test (huella : out String);
        entry res (codigo : in String; valor : in Integer);
    end especialista;

    task body servidor is
        codigo : String;
        valor  : Integer;
        hLocal: String;
    begin
        loop
            especialista.test(hLocal);
            Buscar (hLocal, codigo, valor);
            especialista.res (codigo, valor);
        end loop;
    end servidor;

    task body especialista is 
        hLocal, maxCod: String;
        i: Integer;
        c: cola;
    begin
        loop
            --  hLocal := tomarImagen();
            for i in 1..16 loop
                select
                    accept test (huella : in String) do
                        huella:= hLocal;
                    end test;
                or
                    accept res(codigo : in String; valor : in Integer) do 
                        push(c, (cod,valor));
                    end res;
                end select;
            end loop;
            maxCod := max(c);
        end loop;
    end especialista;

    servidores : array (1 .. 8) of servidor;
begin
    null;
end Policia;


notas:
    - el servidor pide huella, y recien ahí el especialista envía.
      Esto permite que los demas servidores que ya recibieron huella puedan enviar sus resultados.
    - primero recibo todos los valores, luego calculo maximo fuera del loop.
    - Se realizan 16 iteraciones de loop: 8 para enviar y 8 para recibir. 