-- Código base tomado de tigarto en github. Ejemplo 1
-- https://github.com/tigarto/lab_digitales1/tree/master/5

-- Librerias utilizadas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity FSM_MOORE is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           x : in STD_LOGIC;
           --btn : in std_logic; -- En caso de utilizar el amortiguador
           z : out STD_LOGIC);
end FSM_MOORE;

architecture Behavioral of FSM_MOORE is

    -- Declaraciones modelo FSM, estados de la máquina
    type STATES is (A, B, C, D);
    signal state, next_state: STATES;
    
    -- En caso de usar el amortiguador descomentar (26 a 29)
    -- constant MAX_COUNT : integer := 1000000;
    -- signal btnprev : std_logic := '0';
    -- signal counter : integer := 0;
    -- signal fsm_clk : std_logic;

begin

    -- Si se va a implementar el amortiguador para la obtención de los datos
    -- de una manera precisa, es decir, cuando se haga uso de la FPGA Basys 3,
    -- se debe descomentar el código Debouncer y el registro de estados 1 (líneas 42 a 64),
    -- además, de comentar el registro de estados 2 (líneas 66 a 74).
    -- No olvidar revisar el test_bench.

    -- Amortiguador: estabiliza la señal emitida por el botón a partir de un Switch que emite
    -- otra señal, de modo que para el proceso de la máquina no se hayan problemas por señales
    -- de muy corta duración, ruido.
    -- Debouncer : process(clk)
    --     begin
    --         if(clk'event and clk='1') then
    --             if (btnprev /= btn) then
    --                 counter <= 0;
    --                 btnprev <= btn;
    --             elsif (counter >= MAX_COUNT) then
    --                 fsm_clk <= btnprev;
    --             else
    --                 counter<=counter+1;
    --             end if;
    --        end if;   
    --    end process;

    -- -- Registro de estados 1, botón reset, devuelve al estado inicial
    -- SYNC_PROC: process(fsm_clk,reset)
    -- begin
    --     if reset = '1' then
    --       state <= A;        
    --     elsif fsm_clk'event and fsm_clk='1' then
    --         state <= next_state;            
    --     end if;
    -- end process;

    -- Registro de estados 2, botón reset, devuelve al estado inicial
    SYNC_PROC: process(clk,reset)
    begin
        if reset = '1' then
          state <= A;        
        elsif clk'event and clk='1' then
            state <= next_state;            
        end if;
    end process;

    -- Salidas de la máquina de estados, están dadas por el caso que ocurra,
    -- es decir, el estado en el que se encuentran.
    OUTPUT_DECODE : process (state)
    begin
      case (state) is 
         when A =>
           z <= '0';
         when B =>
           z <= '0';
         when C =>
           z <= '0';
         when D =>
           z <= '1';  -- Dadas las condiciones, si llega al estado D la salida será 1,
                      -- de lo contrario será 0.
         when others =>
           z <= '0';
      end case;
    end process;

    -- Se definen las condiciones para el cambio de estado, lo cual depende
    -- de la entrada, el valor de x. Una vez entra la secuencia de 3 o más ceros, la salida es 1.
    NEXT_STATE_DECODE : process(state, x)
    begin
        next_state <= A;
        case(state) is            
            when A =>
              if (x = '0') then -- El cambio de estados se genera cuando la entrada es 0 
                next_state <= B;              
              end if;
            when B =>
              if (x = '0') then       
                next_state <= C;
              else 
                next_state <= A;
              end if;
            when C =>
              if (x = '0') then
                next_state <= D;                
              else 
                next_state <= A;
              end if; 
            when D =>
              if (x = '0') then
                next_state <= D;               
              else 
                next_state <= A;
              end if;           
        end case;
    end process;
end Behavioral;