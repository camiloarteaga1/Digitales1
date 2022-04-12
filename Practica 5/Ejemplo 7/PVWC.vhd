--C�digo base tomado de tigarto en github. Ejemplo 7
--https://github.com/tigarto/lab_digitales1/tree/master/5/example7


--Librerias usadas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PVWC is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Press : in STD_LOGIC;
           Press2 : in STD_LOGIC;
           LEDOPEN : out STD_LOGIC;
           LEDCLOSE : out STD_LOGIC;
           LEDSTOP : out STD_LOGIC;
           Open_CW : inout STD_LOGIC;
           Close_CCW : inout STD_LOGIC);
end PVWC;

architecture PVWC_arch of PVWC is

    --Declaracion de los estados de la maquina y las se�ales que controlan
    --los procesos de los estados y los leds que representan los estados.
    type State_Type is (w_closed, w_open, w_stop1, w_stop2);
    signal current_state, next_state : State_Type;
    signal LEDS : std_logic_vector(2 downto 0) := "000";

begin
    -------------------------------------------------------------------
    
    --Este proceso es la memoria que asigna el estado actual basandose
    --en el estado futuro, adem�s de que tiene en cuenta.
    STATE_MEMORY: process(Clock, Reset)
    begin
        if Reset = '1' then
          current_state <= w_closed;        
        elsif Clock'event and Clock='1' then
          current_state <= next_state;            
        end if;
    end process;
    -------------------------------------------------------------------
    
    --Este proceso es lo que equivale la tabla de estados al estado futuro
    --y los estados cambia acorde a los botones que se presionen, se ponen
    --en la lista de sensibilidad los botones debido a que la maquina es de
    --tipo mealy, asi que las salidas no solo dependen del reloj.
    NEXT_STATE_LOGIC : process(current_state, Press, Press2)
        begin
          case (current_state) is
            when w_closed => 
              if (Press = '1' and Press2 = '0') then
                next_state <= w_open;
              elsif ((Press = '0' or Press ='1') and Press2 = '1') then
                next_state <= w_stop1;
              else
                next_state <= w_closed;
              end if;
            when w_open => 
              if (Press ='0' and Press2 = '0') then
                next_state <= w_closed;
              elsif ((Press = '0' and Press = '1') and Press2 = '1') then
                next_state <= w_stop2;
              else
                next_state <= w_open;
              end if;
            when w_stop1 =>
                if((Press = '0' or Press = '1') and Press2 = '1') then
                  next_state <= w_stop2;
                elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                  next_state <= w_closed;            
                end if;   
            when w_stop2 =>
                if((Press = '0' or Press = '1') and Press2 = '1') then
                  next_state <= w_stop1;
                elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                  next_state <= w_open;
                              
                end if;      
            when others => next_state <= w_closed;        
          end case;
    end process;
    -------------------------------------------------------------------
    
    --El proceso siguiente es el que define el estado presente y
    --en este se definene las salidas dependiendo del estado en
    --el que se encuentre la maquina, adem�s de que las salidas 
    --son las que afectan al movimiento del motor (en este caso
    --la salida de los LEDS que representan al motor).
    OUTPUT_LOGIC : process (current_state, Press, Press2)
        begin
          case (current_state) is
              when w_closed => 
                  if (Press = '1' and Press2 = '0') then
                    Open_CW <= '1'; 
                    Close_CCW <= '0';
                  elsif ((Press = '0' or Press2 = '1') and Press2 = '1') then
                    Open_CW <= '1'; 
                    Close_CCW <= '1';
                  else
                    Open_CW <= '0'; 
                    Close_CCW <= '1';
                  end if;
              when w_open => 
                  if (Press = '0' and Press2 = '0') then
                    Open_CW <= '0'; 
                    Close_CCW <= '1';
                  elsif ((Press = '1' or Press = '0') and Press2 = '1') then
                    Open_CW <= '1'; 
                    Close_CCW <= '1';
                  else
                    Open_CW <= '1'; 
                    Close_CCW <= '0';
                  end if;
              when w_stop1 =>
                  if((Press = '0' or Press = '1') and Press2 = '1') then
                    Open_CW <= '1';
                    Close_CCW <= '1';
                  elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                    Open_CW <= '0';
                    Close_CCW <= '1';
                  end if;
              when w_stop2 =>
                  if((Press = '0' or Press = '1') and Press2 = '1') then
                    Open_CW <= '1';
                    Close_CCW <= '1';
                  elsif(Press2 = '0' and (Press = '1' or Press = '0')) then
                    Open_CW <= '1';
                    Close_CCW <= '0';
                  end if;  
                when others => 
                  Open_CW <= '0'; Close_CCW <= '0';
        end case;
    end process;
    
    -------------------------------------------------------------------
    
    --El proceso que realiza LED es el de asignar las salidas mealy
    --a los LEDs de la FPGA para simular lo que ser�a el motor.    
    LED : process (Open_CW,Close_CCW)
        begin
        
            if(Open_CW ='1' and Close_CCW = '0') then
                LEDS(0) <= '1';
                LEDS(1) <= '0';
                LEDS(2) <= '0';
            elsif(Open_CW ='0' and Close_CCW = '1') then
                LEDS(0) <= '0';
                LEDS(1) <= '1';
                LEDS(2) <= '0';
            elsif(Open_CW ='1' and Close_CCW = '1') then
                LEDS(0) <= '0';
                LEDS(1) <= '0';
                LEDS(2) <= '1';
            else
                LEDS(0) <= LEDS(0);
                LEDS(1) <= LEDS(1);
                LEDS(2) <= LEDS(2);  
            end if;
            
            LEDOPEN <= LEDS(0);
            LEDCLOSE <= LEDS(1);
            LEDSTOP <= LEDS(2);
    end process;        
end architecture;