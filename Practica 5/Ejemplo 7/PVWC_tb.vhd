--C�digo base tomado de tigarto en github. Ejemplo 7
--https://github.com/tigarto/lab_digitales1/tree/master/5/example7


--Librerias usadas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PVWC_TB is
end PVWC_TB;

architecture PVWC_TB_arch of PVWC_TB is

    --Declaracion de las entradas y salidas de la maquina simulada.
    type State_Type is (w_closed, w_open, w_stop1, w_stop2);
    signal current_state_int, next_state_int : State_Type;
    signal Clock, Reset, Press,Press2, Open_CW, Close_CCW: STD_LOGIC;   
    
    --Declaracion del componente de la maquina de estado del motor
    component PVWC is
      Port ( Clock : in STD_LOGIC;
             Reset : in STD_LOGIC;
             Press : in STD_LOGIC;
             Press2 : in STD_LOGIC;
             LEDOPEN : out STD_LOGIC;
             LEDCLOSE : out STD_LOGIC;
             LEDSTOP : out STD_LOGIC;
             Open_CW : inout STD_LOGIC;
             Close_CCW : inout STD_LOGIC);
    end component;

begin
  
  --Asignacion de las se�ales a los puertos del componente.
  DUT: PVWC
	Port map (
    Clock => Clock,
    Reset => Reset,
    Press => Press,
    Press2 => Press2,
    Open_CW => Open_CW,
    Close_CCW => Close_CCW
  );

    -------------------------------------------------------------------
      
  --Este proceso simula un reloj que controla los estados
  --se puso a esta frecuencia para que se notaran m�s 
  --facilmente los cambios de estado y las salidas del 
  --motor (movimientos del motor).
  Clock_stimulus: process
  begin
    Clock <= '0';
    wait for 10 ns;
    Clock <= '1';
    wait for 10 ns;
  end process;

    -------------------------------------------------------------------
  
  --Este proceso simula al boton de reset.  
  Reset_stimulus: process
  begin
    Reset <= '0';
    wait for 100 ns;     -- 5 ns
    Reset <= '1';
    wait for 10 ns;   -- 200 ns  
  end  process;
    -------------------------------------------------------------------
  
  --Este proceso simula los diferentes tipos de entradas
  --de Press y Press2, se colocaron varios para evaluar
  --todos los casos posibles con las entradas que son del 
  --orden 2^2 al ser de 2 bits.
  Press_stimulus: process
  begin
    Press <= '0';
    Press2 <= '0';   
    wait for 20 ns;     -- 25 ns    
    Press <= '1';
    Press2 <= '0';
    wait for 5 ns;      -- 30 ns    
    Press <= '0';
    Press2 <= '1';
    wait for 5 ns;      -- 30 ns    
    Press <= '1';
    Press2 <= '1';
    wait for 15 ns;     -- 45 ns    
    Press <= '1';
    Press2 <= '0';
    wait for 5 ns;     -- 50 ns    
    Press <= '0';
    Press2 <= '1';
    wait for 5 ns;
  end process;
  
    -------------------------------------------------------------------
    
    --Este proceso es la memoria que asigna el estado actual basandose
    --en el estado futuro, adem�s de que tiene en cuenta.  
    STATE_MEMORY: process(Clock, Reset)
        begin
            if Reset = '1' then
              current_state_int <= w_closed;        
            elsif Clock'event and Clock='1' then
              current_state_int <= next_state_int;            
            end if;
        end process;
    
    -------------------------------------------------------------------
    
    --Este proceso es lo que equivale la tabla de estados al estado futuro
    --y los estados cambia acorde a los botones que se presionen, se ponen
    --en la lista de sensibilidad los botones debido a que la maquina es de
    --tipo mealy, asi que las salidas no solo dependen del reloj.
    NEXT_STATE_LOGIC : process(current_state_int, Press, Press2)
        begin
          case (current_state_int) is
            when w_closed => 
              if (Press = '1' and Press2 = '0') then
                next_state_int <= w_open;
              elsif ((Press = '0' or Press ='1') and Press2 = '1') then
                next_state_int <= w_stop1;
              else
                next_state_int <= w_closed;
              end if;
            when w_open => 
              if (Press ='0' and Press2 = '0') then
                next_state_int <= w_closed;
              elsif ((Press = '0' and Press = '1') and Press2 = '1') then
                next_state_int <= w_stop2;
              else
                next_state_int <= w_open;
              end if;
            when w_stop1 =>
                if((Press = '0' or Press = '1') and Press2 = '1') then
                  next_state_int <= w_stop2;
                elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                  next_state_int <= w_closed;            
                end if;   
            when w_stop2 =>
                if((Press = '0' or Press = '1') and Press2 = '1') then
                  next_state_int <= w_stop1;
                elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                  next_state_int <= w_open;
                              
                end if;      
            when others => next_state_int <= w_closed;        
          end case;
    end process;
   
end architecture;