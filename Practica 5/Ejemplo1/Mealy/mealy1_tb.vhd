-- Código base tomado de tigarto en github. Ejemplo 1
-- https://github.com/tigarto/lab_digitales1/tree/master/5

-- Librerias utilizadas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity FSM_MEALY_TB is
end FSM_MEALY_TB;

architecture Behavioral of FSM_MEALY_TB is

    Type STATES is (A, B, C); -- Definición de los estados
    signal state_int, next_state_int: STATES;
    signal clk_int, reset_int, x_int, z_int: STD_LOGIC;  -- Señales para la implementación
    -- signal btn_int : STD_LOGIC; -- Descomentar la señal si se utiliza el amortiguador

    -- Se define el componente principal del cual se hace el test_bench o simulación
    component FSM_MEALY is
      Port ( reset : in STD_LOGIC;
             clk : in STD_LOGIC;
             x : in STD_LOGIC;
             --btn : in std_logic; -- Descomentar la señal si se utiliza el amortiguador
             z : out STD_LOGIC);
    end component;

begin

  -- Se realiza el port map del componente principal
  UUT: FSM_MEALY
	Port map (
    reset => reset_int,
    clk => clk_int,
    x => x_int,
    --btn => btn_int, -- Descomentar la señal si se utiliza el amortiguador
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
    wait for 180 ns;   -- 200 ns  
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
    wait for 33 ns;    -- 83 ns
    x_int <= '0';
    wait for 20 ns;    -- 103 ns
    x_int <= '1';
    wait for 40 ns;    -- 143 ns
    x_int <= '0';
    wait for 27 ns;    -- 170 ns
    x_int <= '1';
    wait for 20 ns;    -- 190 ns
    x_int <= '0';
    wait for 10 ns;    -- 200 ns    
  end process data_gen_proc;

  -- Se sincronizan el reloj y el reset creado con el cambio de estados
  Sync : process(clk_int, reset_int)
    begin
      if reset_int = '1' then
        state_int <= A;
      elsif clk_int'event and clk_int = '1' then
        state_int <= next_state_int;
      end if;
  end process;

  -- Se plantea la máquina como tal, a partir del diagrama se escriben 
  -- las condiciones para el cambio de estados a partir del valor de entrada
  -- también dependiendo del estado se genera la salida pertinente
  process(state_int, x_int)
    begin
      z_int <= '0';
        case(state_int) is            
            when A =>
              if (x_int = '0') then             
                next_state_int <= B;              
              end if;
            when B =>
              if (x_int = '0') then       
                next_state_int <= C;
              else 
                next_state_int <= A;
              end if;
            when C =>
              if (x_int = '0') then
                next_state_int <= C;
                 z_int <= '1'; -- Una vez entra la secuencia de 3 o más ceros, la salida es 1     
              else 
                next_state_int <= A;
              end if;                                        
        end case;
  end process;
   
end Behavioral;