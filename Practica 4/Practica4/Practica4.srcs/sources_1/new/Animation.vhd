----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2022 04:13:07 PM
-- Design Name: 
-- Module Name: Animation - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity Animation is
    Port ( CLK : in  STD_LOGIC; -- Clk a 50MHz
           RST : in  STD_LOGIC; -- reset
		   COLOR : in STD_LOGIC_VECTOR (11 downto 0); -- Color proveniente de los switches
           RGB : out  STD_LOGIC_VECTOR (11 downto 0); -- Color de salida a la pantalla
           HS : out  STD_LOGIC; -- Señal de sincronizacion horizontal
           VS : out  STD_LOGIC); -- Señal de sincronizacion vertical
			  
	-- Las siguientes declaraciones realizan la asignacion de pines 
--	attribute loc: string;
--	attribute loc of CLK : signal is "B8"; -- Pin de reloj
--	attribute loc of RST : signal is "B18"; -- Pulsador BTN0
--	attribute loc of COLOR : signal is "R17,N17,L13,L14,K17,K18,H18,G18"; -- Slide Switches SW7 a SW0
--	attribute loc of HS : signal is "T4"; -- Driver VGA
--	attribute loc of VS	: signal is "U3"; -- Driver VGA
--	attribute loc of RGB : signal is "R9,T8,R8,N8,P8,P6,U5,U4"; -- Driver VGA
end Animation;

architecture Behavioral of Animation is
       

-- Declaracion señales

	signal HCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal VCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal INT_RGB : STD_LOGIC_VECTOR (11 downto 0);
	signal clkint : std_logic;
	signal count : integer := 0;
	
	-- Para el contador
	Signal VS2 : std_logic;
	Signal aux : std_logic_vector(1 downto 0);
	
	-- Para el dibujo de la ROM
	-- Cuco 1
	signal wColor1 : std_logic_vector(2 downto 0);
	
	-- Cuco 2
	signal wColor2 : std_logic_vector(2 downto 0);
	
	-- Salida
	Signal posx : integer range 0 to 49 := 0;
	Signal posy : integer range 0 to 49 := 0;
	signal wColor : std_logic_vector(2 downto 0);
	
	-- Constantes de la posición de dibujo
	constant iposx : integer := 150;
	constant iposy : integer := 0;
	
	-- Declaracion de colores
    constant Black : std_logic_vector(11 downto 0) := "000000000000";
    constant White : std_logic_vector(11 downto 0) := "111111111111";
    constant Red : std_logic_vector(11 downto 0) := "000000001101";
    constant Yellow : std_logic_vector(11 downto 0) := "110100101111";
    constant Orange : std_logic_vector(11 downto 0) := "101000111111";
    constant Gray : std_logic_vector(11 downto 0) := "101010111010";
	
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
	
	--ROM con Cuco 1
	COMPONENT Cuco1
	PORT(
	   addC1 : in integer range 0 to 49;
	   addC2 : in integer range 0 to 49;
	   colorCuco : out std_logic_vector(2 downto 0)
	   );
	END COMPONENT;
	
	--ROM con Cuco 2
	COMPONENT Cuco2
	PORT(
	   addC1 : in integer range 0 to 49;
	   addC2 : in integer range 0 to 49;
	   colorCuco : out std_logic_vector(2 downto 0)
	   );
	END COMPONENT;
	
begin

    -- Declaracion de imagenes
    Cuco_1 : Cuco1 port map(
                addC1 => posx,
                addC2 => posy,
                colorCuco => wColor1
                );
                
    Cuco_2 : Cuco2 port map(
                addC1 => posx,
                addC2 => posy,
                colorCuco => wColor2
                );

    -- Clock
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
	           if count = 480 then
	               count <= 0;
                       
                else
                    count <= count + 3;
                    aux <= aux + 1;
                    
                end if;
            end if;
   end process;
    
    process
       begin
            if ((VCOUNT>=(iposy+count)) AND (VCOUNT<(iposy+50+count)) AND (HCOUNT>=iposx) AND (HCOUNT<iposx+50)) then
            
                if aux(0) = '0' then
                    wcolor <= wcolor1;
                else 
                    wcolor <= wcolor2;
                end if;

                posx <= to_integer(unsigned(HCOUNT-iposx));
                posy <= to_integer(unsigned(VCOUNT-iposy-count));
--                  posx <= to_integer(unsigned(HCOUNT));
--                  posy <= to_integer(unsigned(VCOUNT));
                
                if (wColor = "000") then
                    INT_RGB <= COLOR;
                elsif (wColor = "001") then
                    INT_RGB <= Black;
                elsif (wColor = "010") then
                    INT_RGB <= White;
                elsif (wColor = "011") then
                    INT_RGB <= Red;
                elsif (wColor = "100") then
                    INT_RGB <= Yellow;
                elsif (wColor = "101") then
                    INT_RGB <= Gray;
                elsif (wColor = "110") then
                    INT_RGB <= Orange;
                else
                    INT_RGB <= COLOR;           
                end if;
            else
                INT_RGB <= COLOR;              
            end if;
    end process;
	-- Dibuja el cuadro y asigna colores
--   INT_RGB <= COLOR when ((VCOUNT>=290) AND (VCOUNT<=340) AND (HCOUNT>=220) AND (HCOUNT<=270)) else
--			     not COLOR;
	
end Behavioral;

