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

-- Declaración arrays para posiciones
    
    type arinteger1 is array (0 to 5) of integer range 0 to 639; 
    type arinteger2 is array (0 to 5) of integer range 0 to 479;
    
-- Declaracion señales
    --Para 34 segmentos
    signal paintLet : STD_LOGIC_VECTOR(6 downto 0);
    signal rgb_aux2 : STD_LOGIC_VECTOR (11 downto 0);
    signal rgb_aux3 : STD_LOGIC_VECTOR (11 downto 0);
    signal segmentsT1 : STD_LOGIC_VECTOR(33 downto 0):= "1111111100000000110000000000000000";
    signal segmentsT2 : STD_LOGIC_VECTOR(33 downto 0):= "0000000000111100000000000000000000";
    signal segmentsT3 : STD_LOGIC_VECTOR(33 downto 0):= "0000001111000000001001000000000000";
    signal segmentsT4 : STD_LOGIC_VECTOR(33 downto 0):= "0000000000000011110000000001100000";
    signal segmentsT5 : STD_LOGIC_VECTOR(33 downto 0):= "0000000000111100000000000000000000";
    signal segmentsT6 : STD_LOGIC_VECTOR(33 downto 0):= "1100111111000011110000000000000000";
    signal LetPOS1 : arinteger1 := (500,500,500,515,500,500);
    signal LetPOS2 : arinteger2 := (10,65,120,121,175,230);
    --Pantalla
	signal HCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal VCOUNT: STD_LOGIC_VECTOR (10 downto 0);
	signal INT_RGB : STD_LOGIC_VECTOR (11 downto 0);
	signal INT_RGB2 : STD_LOGIC_VECTOR (11 downto 0);
	signal clkint : std_logic;
	signal clkCuco : std_logic;
	signal count : integer := 0;
	Signal COLOR : STD_LOGIC_VECTOR (11 downto 0); -- Color
	
	-- Para el contador
	Signal VS2 : std_logic;
	Signal aux : std_logic_vector(1 downto 0);
	Signal auxCuco : integer := 0;
	
	-- Para el dibujo de la ROM
	-- Cuco 1
	signal wColor1 : std_logic_vector(2 downto 0);
	
	-- Cuco 2
	signal wColor2 : std_logic_vector(2 downto 0);
	
	-- Salida
	Signal posx : integer range 0 to 49 := 0;
	Signal posy : integer range 0 to 49 := 0;
	Signal wColor : std_logic_vector(2 downto 0);
	
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
		--rgb_in2 : in std_logic_vector(11 downto 0);          
		HS : OUT std_logic;
		VS : OUT std_logic;
		hcount : OUT std_logic_vector(10 downto 0);
		vcount : OUT std_logic_vector(10 downto 0);
		rgb_out : OUT std_logic_vector(11 downto 0);
		blank : OUT std_logic
		);
	END COMPONENT;
	
-- Componente de 34 segmentos

    COMPONENT display34segm
        GENERIC(
                SG_WD : INTEGER :=5;
                DL : INTEGER :=100 
        );
        PORT(
            segments : in STD_LOGIC_VECTOR (33 downto 0);
            posx : in integer range 0 to 639;   --disp_posx 
            posy : in integer range 0 to 479;   --disp_posy
            hcount : in  STD_LOGIC_VECTOR (10 downto 0);
            vcount : in  STD_LOGIC_VECTOR (10 downto 0);
            paint : out  std_logic 
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
    --Declaración de los 34 segmentos
    
    DisplayLET1 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT1,
        posx => LetPOS1(0),
        posy => LetPOS2(0),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(0)      
    );  

DisplayLET2 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT2,
        posx => LetPOS1(1),
        posy => LetPOS2(1),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(1)      
    );  
    
DisplayLET3 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT3,
        posx => LetPOS1(2),
        posy => LetPOS2(2),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(2)      
    );

DisplayLET4 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT4,
        posx => LetPOS1(3),
        posy => LetPOS2(3),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(3)      
    );
    
DisplayLET5 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT5,
        posx => LetPOS1(4),
        posy => LetPOS2(4),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(4)      
    );

DisplayLET6 : display34segm
    GENERIC MAP(
            SG_WD => 3,
            DL => 50
    )
    PORT MAP(
        segments => segmentsT6,
        posx => LetPOS1(5),
        posy => LetPOS2(5),
        hcount => Hcount,
        vcount => Vcount,
        paint => paintLet(5)      
    );

        

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
		--rgb_in2 => INT_RGB2,
		HS => HS,
		VS => VS2,
		hcount => HCOUNT,
		vcount => VCOUNT,
		rgb_out => RGB,
		blank => open
	);

	VS <= VS2;
	
	 --RGB <= rgb_aux3;
	 
--Process para mover las letras y el contador para mover el cuco 	
	process (VS2) 
	   begin
       if (VS2'event and VS2 = '0') then
            if(LetPOS2(0) >= -20) then
                LetPOS2(0) <= LetPOS2(0)-5;
            else
                LetPOS2(0) <= 479;
            end if; 
            if(LetPOS2(1) >= -20) then
                LetPOS2(1) <= LetPOS2(1)-5;
            else
                LetPOS2(1) <= 479;
            end if;
            if(LetPOS2(2) >= -20) then
                LetPOS2(2) <= LetPOS2(2)-5;
            else
                LetPOS2(2) <= 479;
            end if;      
            if(LetPOS2(3) >= -20) then
                LetPOS2(3) <= LetPOS2(3)-5;
            else
                LetPOS2(3) <= 479;
            end if;    
            if(LetPOS2(4) >= -20) then
                LetPOS2(4) <= LetPOS2(4)-5;
            else
                LetPOS2(4) <= 479;
            end if;
            if(LetPOS2(5) >= -20) then
                LetPOS2(5) <= LetPOS2(5)-5;
            else
                LetPOS2(5) <= 479;
            end if;

            if count = 480 then
                count <= 0;
                auxCuco <= 0;
                
            else
                count <= count + 3;
                auxCuco <= auxCuco + 4;
                 
                if auxCuco = 80 then
                    auxCuco <= 0;
                    aux <= aux + 1;
                end if;
            end if;
        end if;
   end process; 
   
--    CLK_DIV1 : process(CLK)
--         begin
--             if auxCuco = 0 then
--                 clkCuco <= '0';
--                 auxCuco <= auxCuco + 1;
--             end if;        
                 
--             if (CLK' event and CLK='1') then
--                 if(auxCuco = 10000000) then                    
--                     clkCuco <= not(clkCuco);
--                     auxCuco <= 1;
--                 else
--                     auxCuco <= auxCuco + 1;
--                     aux <= aux + 1;
--                 end if;
--             end if;
--     end process;
   
   INT_RGB2 <= "111111111111" when (paintLet(0)='1' or paintLet(1)='1' or paintLet(2)='1' or paintLet(3) = '1' or paintLet(4) = '1' or paintLet(5) = '1');
   
   process (VS2)
       begin
            if ((VCOUNT>=(iposy+count)) AND (VCOUNT<(iposy+50+count)) AND (HCOUNT>=iposx) AND (HCOUNT<iposx+50)) then
           
                posx <= to_integer(unsigned(HCOUNT-iposx));
                posy <= to_integer(unsigned(VCOUNT-iposy-count));
           
                if aux(0) = '0' then
                    wcolor <= wcolor1;
                else
                    wcolor <= wcolor2;
                end if;
                
                if (wColor = "000") then
                    COLOR(7 downto 4) <= VCOUNT(8 downto 5);
                elsif (wColor = "001") then
                    COLOR(11 downto 0) <= Black(11 downto 0);
                elsif (wColor = "010") then
                    COLOR(11 downto 0) <= White(11 downto 0);
                elsif (wColor = "011") then
                    COLOR(11 downto 0) <= Red(11 downto 0);
                elsif (wColor = "100") then
                    COLOR(11 downto 0) <= Yellow(11 downto 0);
                elsif (wColor = "101") then
                    COLOR(11 downto 0) <= Gray(11 downto 0);
                elsif (wColor = "110") then
                    COLOR(11 downto 0) <= Orange(11 downto 0);                
                else
                    COLOR(7 downto 4) <= VCOUNT(8 downto 5);      
                end if;
                
                paintLet(6)<='1';
                
            else
                COLOR(7 downto 4) <= VCOUNT(8 downto 5);
                paintLet(6)<='0';
            
            end if; 
    end process; 
    
    INT_RGB <= "111111111111" when ((paintLet(0)='1' or paintLet(1)='1' or paintLet(2)='1' or paintLet(3) = '1' or paintLet(4) = '1' or paintLet(5) = '1') and paintLet(6) = '0')     
    else  X"0"&COLOR(7 downto 4)&X"0";
     
    INT_RGB <= COLOR when (paintLet(6) = '1')
    else  X"0"&COLOR(7 downto 4)&X"0";
     
--    process (VS2)
--       begin
--            if (paintLet(6)='1')
--            elsif(paintLet(0)='1' or paintLet(1)='1' or paintLet(2)='1' or paintLet(3) = '1' or paintLet(4) = '1' or paintLet(5) = '1') then
--                INT_RGB <= "111111111111";  
--            end if;
                 
--    end process;
-- 	Dibuja el cuadro y asigna colores
--   INT_RGB <= COLOR when ((VCOUNT>=290) AND (VCOUNT<=340) AND (HCOUNT>=220) AND (HCOUNT<=270)) else
-- 			     not COLOR;
	
end Behavioral;