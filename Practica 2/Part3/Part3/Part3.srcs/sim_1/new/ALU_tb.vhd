library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use STD.textio.all;
use IEEE.std_logic_textio.all;

library UNISIM;
use UNISIM.VComponents.all;

Entity ALU_tb Is
end ALU_tb;

Architecture behavior of ALU_tb Is
	Component ALU
	port (
          inputA : in STD_LOGIC_VECTOR(4 downto 0);
          inputB : in STD_LOGIC_VECTOR(4 downto 0);
          inputXY : in STD_LOGIC_VECTOR(1 downto 0);
          outputS : out STD_LOGIC_VECTOR(4 downto 0);
          output7 : out STD_LOGIC_VECTOR(6 downto 0)
		);	
	End Component;
	
	Signal switchA : STD_LOGIC_VECTOR(4 downto 0) ;
	Signal switchB : STD_LOGIC_VECTOR(4 downto 0) ;
	Signal switchXY : STD_LOGIC_VECTOR(1 downto 0) ;
	Signal outputProcess : STD_LOGIC_VECTOR(4 downto 0);
	Signal led_out : STD_LOGIC_VECTOR(6 downto 0);
	Signal led_exp_out : STD_LOGIC_VECTOR(6 downto 0);
		
	Signal count_int_A : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	Signal count_int_B : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    Signal count_int_XY : STD_LOGIC_VECTOR(1 downto 0) := "00";
    Signal inp_exp : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
	procedure expected_led (
	    outputSF : in std_logic_vector(4 downto 0);		
		led_expected : out std_logic_vector(6 downto 0)
	) is		
		   
	begin		    
		case outputSF(3 downto 0) is 
                when "0000" =>
                led_expected := "0000001";
                when "0001" =>
                led_expected := "1001111"; 
                when "0010" =>
                led_expected := "0010010";
                when "0011" =>
                led_expected := "0000110";
                when "0100" =>
                led_expected := "1001100";
                when "0101" =>
                led_expected := "0100100";
                when "0110" =>
                led_expected := "1100000";
                when "0111" =>
                led_expected := "0001110";
                when "1000" =>
                led_expected := "0000000";
                when "1001" =>
                led_expected := "0000100";
                when "1010" =>
                led_expected := "1111110";
                when "1011" =>
                led_expected := "0110000";
                when "1100" =>
                led_expected := "1101101";
                when "1101" =>
                led_expected := "1111001";
                when "1110" =>
                led_expected := "0110011";
                when others =>
                led_expected := "1011011";                 
            end case;
	    
	end expected_led;
	
begin
	uut:  ALU PORT MAP (
			inputA => switchA,
			inputB => switchB,
			inputXY => switchXY,
			outputS => outputProcess
		 );
		 
	process
		variable s : line;
		variable i : integer := 0;
		variable i2 : integer := 0;
		variable i3 : integer := 0;
		variable countA : integer := 0;
		variable countB : integer := 0;
		variable countXY : integer := 0; 
	    variable proc_out : STD_LOGIC_VECTOR(6 downto 0);
	    	    

	begin
	    switchA <= count_int_A;
	    switchB <= count_int_B;
	    switchXY <= count_int_XY;	    
        for i in 0 to 15 loop   
	      countA := countA + 1;
	               	  
		  wait for 50 ns;		  
		  write (s, switchA);
          writeline (output, s);
		  wait for 10 ns;
		  for i2 in 0 to 15 loop
		      countB := countB +1;
              wait for 50 ns;              
              write (s, switchB);
              writeline (output, s);
              for i3 in 0 to 3 loop
                  countXY := countXY + 1;
                  wait for 10 ns;                                                                       
                  expected_led (outputProcess, proc_out);
                  write (s, switchXY); write(s, string'(" "));write (s, outputProcess);write(s, string'(" "));write (s, proc_out);                  
                  writeline (output, s);                                    
                  switchXY <= switchXY + 1; 
              end loop;
              --count_int_XY <= "00";
              write(s, string'("Ended loop "));write(s, countB);
              writeline(output, s);                                      
          switchB <= switchB + 1;                    
          end loop;
          switchB <= count_int_B;               
--		  expected_led (switch, proc_out);
--		  led_exp_out <= proc_out;

		  -- If the outputs match, then announce it to the simulator console.
--          if (led_out = proc_out) then
--                write (s, string'("LED output MATCHED at ")); write (s, count ); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, led_out); 
--                writeline (output, s);
--          else
--              write (s, string'("LED output mis-matched at ")); write (s, count); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, led_out); 
--              writeline (output, s);
--          end if;
		  		  
		  -- Increment the switch value counters.
		  --count_int_A <= count_int_A + 1;
		  switchA <= switchA + 1;
        end loop;		 
       
	end process;
end behavior;
