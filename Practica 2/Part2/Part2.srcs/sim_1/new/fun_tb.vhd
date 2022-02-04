--------------------------------------------
-- Module Name: tutorial
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use STD.textio.all;
use IEEE.std_logic_textio.all;

library UNISIM;
use UNISIM.VComponents.all;

Entity fun_tb Is
end fun_tb;

Architecture behavior of fun_tb Is
	Component fun
	port (
		input : in STD_LOGIC_VECTOR(3 downto 0);
		output : out STD_LOGIC_VECTOR(2 downto 0)
		);	
	End Component;
	
	Signal inp : STD_LOGIC_VECTOR(3 downto 0); --:="0000"
	Signal out_out : STD_LOGIC_VECTOR(2 downto 0); --:="000"
	Signal out_exp_out : STD_LOGIC;
    Signal inpf : STD_LOGIC_VECTOR(3 downto 0):="0000";		

	procedure expected_out (
		inp_in : in std_logic_vector(3 downto 0);
		out_expected : out std_logic
	) is
	
	Variable out_expected_int : std_logic;
		   
	begin		    
		out_expected_int := (not(inp_in(2)) or inp_in(1)or not(inp_in(0))) and (inp_in(3) or not(inp_in(2)) or not(inp_in(1))) and (not(inp_in(3)) or inp_in(2)) and (not(inp_in(3)) or inp_in(1));
	    out_expected := out_expected_int;
	end expected_out;
	
begin
	uut:  fun PORT MAP (
			input => inp,
			output => out_out
		 );	 
	 
    process
		variable s: line;
		variable i : integer := 0;
		variable count : integer := 0;
	    variable proc_out : STD_LOGIC;
	   
        begin
        for i in 0 to 15 loop   
	      count := count + 1;
	               	  
		  wait for 50 ns;
		  inp <= inpf;
		  wait for 10 ns;
		  expected_out(inp, proc_out);
		  out_exp_out <= proc_out;

--		  -- If the outputs match, then announce it to the simulator console.
          if (out_out(0) = proc_out and out_out(1) = proc_out and out_out(2) = proc_out) then
                write (s, string'("   LED output MATCHED at ")); write (s, count ); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, out_out); 
                writeline (output, s);
          else
              write(s, string'("LED output mis-matched at ")); write (s, count); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, out_out); 
              writeline (output, s);
          end if;
          inpf<=inpf+1;
        end loop;		 
       
       end process;
end behavior;
