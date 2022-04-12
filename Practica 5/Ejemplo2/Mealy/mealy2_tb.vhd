-- Código base tomado de tigarto en github. Ejemplo 2
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

    type STATES is (S0, S1, S2, S3); -- Definición de los estados
    signal state_int, next_state_int: STATES;

    signal clk_int, reset_int, x_int, z_int: STD_LOGIC;  -- Señales para la implementación
    -- signal btn_int : STD_LOGIC; -- Descomentar la señal si se utiliza el amortiguador

    -- Se define el componente principal del cual se hace el test_bench o simulación
    component FSM_MEALY is
      Port ( reset : in STD_LOGIC;
             clk : in STD_LOGIC;
             x : in STD_LOGIC;
             -- btn : in STD_LOGIC; -- Descomentar la señal si se utiliza el amortiguador
             z : out STD_LOGIC);
    end component;

begin

  -- Se realiza el port map del componente principal
  UUT: FSM_MEALY
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
  SYNC_PROC: process(clk_int, reset_int)
    begin
        if reset_int = '1' then
          state_int <= S0;        
        elsif clk_int'event and clk_int='1' then
          state_int <= next_state_int;            
         end if;
    end process;

    -- Salidas de la máquina de estados, están dadas por el caso que ocurra,
    -- es decir, el estado en el que se encuentran.
    OUTPUT_DECODE : process (state_int, x_int)
    begin
      z_int <= '0';
      case (state_int) is         
        when S3 =>
          if (x_int = '0') then
            z_int <= '1'; -- En caso de estar en el estado 3 y la entrada ser 0, la
                          -- salida será 1, de lo contrario 0.  
          end if;        
        when OTHERS =>
            z_int <= '0';
      end case;
    end process;
    
    -- Se definen las condiciones para el cambio de estado, lo cual depende
    -- de la entrada, el valor de x. Una vez entra la secuencia 0010.
    -- La máquina permite repetición.
    NEXT_STATE_DECODE : process(state_int, x_int)
    begin
        next_state_int <= S0;
        case(state_int) is            
            when S0 =>
              if (x_int = '0') then                
                next_state_int <= S1;              
              end if;
            when S1 =>
              if (x_int = '0') then       
                next_state_int <= S2;
              else 
                next_state_int <= S0;
              end if;
            when S2 =>
              if (x_int = '0') then
                next_state_int <= S2;                
              else 
                next_state_int <= S3;
              end if; 
            when S3 =>
              if (x_int = '0') then                
                next_state_int <= S1;                
              else 
                next_state_int <= S0;
              end if;           
        end case;
    end process;
   
end Behavioral;