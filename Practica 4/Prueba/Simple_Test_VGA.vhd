----------------------------------------------------------------------------------
-- Company: Instituto Tecn√≥logico Metropolitano
-- Engineer: Ricardo Andr√©s Vel√°squez V√©lez
-- 
-- Create Date:    09:49:23 05/12/2014 
-- Design Name: 
-- Module Name:    Simple_Test_VGA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Este m√≥dulo verifica el correcto funcionamiento del modulo de control
--              VGA de un monitor o pantalla de computador. El test dibuja un cuadro
--              en el centro de la pantalla  y los switches en la board nexys 2 permiten
--					 seleccionar el color del cuadro del centro. El color del fondo es el 
--              inverso del cuadro.
--
-- Dependencies: vga_ctrl_640x480_60Hz
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity Simple_Test_VGA is
    Port ( CLK : in  STD_LOGIC; -- Clk a 50MHz
           RST : in  STD_LOGIC; -- reset
		  COLOR : in STD_LOGIC_VECTOR (11 downto 0); -- Color proveniente de los switches
           RGB : out  STD_LOGIC_VECTOR (11 downto 0); -- Color de salida a la pantalla
           HS : out  STD_LOGIC; -- SeÒal de sincronizacion horizontal
           VS : out  STD_LOGIC); -- SeÒal de sincronizacion vertical
			  
	-- Las siguientes declaraciones realizan la asignacion de pines 
--	attribute loc: string;
--	attribute loc of CLK : signal is "B8"; -- Pin de reloj
--	attribute loc of RST : signal is "B18"; -- Pulsador BTN0
--	attribute loc of COLOR : signal is "R17,N17,L13,L14,K17,K18,H18,G18"; -- Slide Switches SW7 a SW0
--	attribute loc of HS : signal is "T4"; -- Driver VGA
--	attribute loc of VS	: signal is "U3"; -- Driver VGA
--	attribute loc of RGB : signal is "R9,T8,R8,N8,P8,P6,U5,U4"; -- Driver VGA
end Simple_Test_VGA;

architecture Behavioral of Simple_Test_VGA is
       

-- Declaracion seÒales

	signal HCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal VCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal INT_RGB : STD_LOGIC_VECTOR (11 downto 0);
	signal clkint : std_logic;
	signal count : integer := 0;
	Signal VS2 : std_logic;
	
-- Declaracion de componente vga_ctrl_640x480_60Hz
	COMPONENT vga_ctrl_640x480_60Hz
	PORT(
		rst : IN std_logic;
		clk : IN std_logic;
		rgb_in : IN std_logic_vector(11 downto 0);          
		HS : OUT std_logic;
		VS : OUT std_logic;
		hcount : OUT std_logic_vector(10 downto 0);
		vcount : OUT std_logic_vector(10 downto 0);
		rgb_out : OUT std_logic_vector(11 downto 0);
		blank : OUT std_logic
		);
	END COMPONENT;
	
begin

    process (CLK)
	begin  
		if (CLK'event and CLK = '1') then
			clkint <= NOT clkint;
		end if;
	end process;   

-- Instanciacion componente vga_ctrl_640x480_60Hz
	VGA: vga_ctrl_640x480_60Hz 
	PORT MAP(
		rst => RST,
		clk => clkint,
		rgb_in => INT_RGB,
		HS => HS,
		VS => VS2,
		hcount => HCOUNT,
		vcount => VCOUNT,
		rgb_out => RGB,
		blank => open
	);
	
	VS <= VS2;
	
	process (VS2) 
	   begin
	       if (VS2'event and VS2 = '0') then
	           if count = 640 then
	               count <= 0;
                       
                else
                    count <= count + 5;
                    
                end if;
            end if;
   end process;                           
	-- Dibuja el cuadro y asigna colores
   INT_RGB <= COLOR when ( (VCOUNT>=150) AND (VCOUNT<=330) AND (HCOUNT>=0+count) AND (HCOUNT<=180+count)) else
			     not COLOR;
	
end Behavioral;

