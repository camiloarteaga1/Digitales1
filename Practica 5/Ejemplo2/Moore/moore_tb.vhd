-- Código base tomado de tigarto en github. Ejemplo 2
-- https://github.com/tigarto/lab_digitales1/tree/master/5

-- Librerias utilizadas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity FSM_MOORE_TB is
end FSM_MOORE_TB;

architecture Behavioral of FSM_MOORE_TB is
    
    type STATES is (S0, S1, S2, S3, S4);  -- Definición de los estados
    signal state_int, next_state_int: STATES;

    signal clk_int, reset_int, x_int, z_int: STD_LOGIC;  -- Señales para la implementación
    -- signal btn_int : STD_LOGIC; -- Descomentar la señal si se utiliza el amortiguador

    -- Se define el componente principal del cual se hace el test_bench o simulación
    component FSM_MOORE is
      Port ( reset : in STD_LOGIC;
             clk : in STD_LOGIC;
             x : in STD_LOGIC;
             -- btn : in STD_LOGIC; -- Descomentar la señal si se utiliza el amortiguador        
             z : out STD_LOGIC);
    end component;

begin

  -- Se realiza el port map del componente principal
  UUT: FSM_MOORE
	Port map (
    reset => reset_int,
    clk => clk_int,
    x => x_int,
    -- btn => btn_int, -- Descomentar la señal si se utiliza el amortiguador
    z => z_int
  );

  -- Se genera el reloj para la simulación
  clk_gen_proc: process
  begin
    clk_int <= '0';
    wait for 5 ns;
    clk_int <= '1';
    wait for 5 ns;
  end process clk_gen_proc;

  -- Se crea el botón reset para el registro y funcionamiento de la máquina
  reset_gen_proc: process
  begin
    reset_int <= '0';
    wait for 8 ns;     -- 8 ns
    reset_int <= '1';
    wait for 12 ns;    -- 20 ns
    reset_int <= '0';
    wait for 200 ns;   -- 230 ns  
  end  process reset_gen_proc;

  -- Se generan los cambios de los valores de entrada para permitir los cambios de estado
  data_gen_proc: process
  begin    
    x_int <= '0'; 
    wait for 30 ns;    -- 30 ns
    x_int <= '1';
    wait for 10 ns;    -- 40 ns
    x_int <= '0';
    wait for 10 ns;    -- 50 ns
    x_int <= '1';
    wait for 20 ns;    -- 70 ns
    x_int <= '0';
    wait for 10 ns;    -- 80 ns
    x_int <= '1';
    wait for 20 ns;    -- 100 ns
    x_int <= '0';
    wait for 10 ns;    -- 110 ns
    x_int <= '1';
    wait for 7 ns;     -- 117 ns
    x_int <= '0';
    wait for 13 ns;    -- 130 ns
    x_int <= '1';
    wait for 10 ns;    -- 140 ns
    x_int <= '0';
    wait for 20 ns;    -- 160 ns
    x_int <= '1';
    wait for 30 ns;    -- 190 ns
    x_int <= '0';
    wait for 10 ns;    -- 200 ns
    x_int <= '1';
    wait for 20 ns;    -- 220 ns
    x_int <= '0';
    wait for 10 ns;    -- 230 ns    
  end process data_gen_proc;

  -- Se sincronizan el reloj y el reset creado con el cambio de estados
  SYNC_PROC: process(clk_int,reset_int)
      begin
          if reset_int = '1' then
            state_int <= S0;        
          elsif clk_int'event and clk_int='1' then
              state_int <= next_state_int;            
          end if;
      end process;

    -- Salidas de la máquina de estados, están dadas por el caso que ocurra,
    -- es decir, el estado en el que se encuentran.
    OUTPUT_DECODE : process (state_int)
    begin
      case (state_int) is 
         when S0 =>
           z_int <= '0';
         when S1 =>
           z_int <= '0';
         when S2 =>
           z_int <= '0';
         when S3 =>
           z_int <= '0'; 
         when S4 =>
           z_int <= '1'; -- Dadas las condiciones, si llega al estado S4 la salida será 1,
                         -- de lo contrario será 0.
         when others =>
           z_int <= '0';
      end case;
    end process;

    -- Se plantea la máquina como tal, en base al diagrama se escriben 
    -- las condiciones para el cambio de estados a partir del valor de entrada
    -- también dependiendo del estado se genera la salida pertinente.
    -- Una vez entra la secuencia 0010. La máquina permite repetición.
    NEXT_STATE_DECODE : process(state_int, x_int)
    begin
        next_state_int <= S0;
        case(state_int) is            
            when S0 =>
              if (x_int = '1') then                
                next_state_int <= S0;
              else
                next_state_int <= S1;              
              end if;
            when S1 =>
              if (x_int = '1') then       
                next_state_int <= S0;
              else 
                next_state_int <= S2;
              end if;
            when S2 =>
              if (x_int = '1') then
                next_state_int <= S3;                
              else 
                next_state_int <= S2;
              end if; 
            when S3 =>
              if (x_int = '1') then
                next_state_int <= S0;                
              else 
                next_state_int <= S4;
              end if; 
            when S4 =>
              if (x_int = '1') then
                next_state_int <= S0;                
              else 
                next_state_int <= S2;
              end if;          
        end case;
    end process;
       
end Behavioral;