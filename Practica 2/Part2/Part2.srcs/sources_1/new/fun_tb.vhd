----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2022 12:22:21 AM
-- Design Name: 
-- Module Name: fun_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

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
	
	Signal switch : STD_LOGIC_VECTOR(3 downto 0);
	Signal out_out : STD_LOGIC_VECTOR(2 downto 0);
	Signal out_exp_out : STD_LOGIC;
		

	procedure expected_out (
		inp_in : in std_logic_vector(3 downto 0);
		out_expected : out std_logic
	) is
	
	Variable out_expected_int : std_logic;
		   
	begin		    
		out_expected_int := (not(inp_in(1)) or inp_in(2)or not(inp_in(3))) and (inp_in(0) or not(inp_in(1)) or not(inp_in(2))) and (not(inp_in(0)) or inp_in(1)) and (not(inp_in(0)) or inp_in(2));
	    out_expected := out_expected_int;
	end expected_out;
	
begin
	uut:  fun PORT MAP (
			input => switch,
			output => out_out
		 );
		 
	process
		variable s : line;
		variable i : integer := 0;
		variable count : integer := 0;
	    variable proc_out : std_logic;

	begin
        for i in 0 to 15 loop   
	      count := count + 1;
	               	  
		  
		  wait for 10 ns;
		  expected_out(switch, proc_out);
		  out_exp_out <= proc_out;
		  
		  -- If the outputs match, then announce it to the simulator console.
          if (out_out(0) = proc_out ) then
                write (s, string'("LED output MATCHED at ")); write (s, count ); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, out_out); 
                writeline (output, s);
          else
              write (s, string'("LED output mis-matched at ")); write (s, count); write (s, string'(". Expected: ")); write (s, proc_out); write (s, string'(" Actual: ")); write (s, out_out); 
              writeline (output, s);
          end if;
        end loop;		 
       
	end process;
end behavior;