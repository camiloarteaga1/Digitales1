----------------------------------------------------------------------------------
-- Company: Universidad de Antioquia
-- Engineer: Simon Sanchez Rua - Juan Camilo Arteaga Ibarra
-- 
-- Design Name: Practica 2
-- Module Name: Parte 2 (fun - Behavioral)
-- Project Name: Diseno e implementacion de circuitos combinacionales 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity fun is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (2 downto 0)
           --a, b : in std_logic;
           --c : out std_logic
    );
end fun;

architecture Behavioral of fun is

    signal pr : std_logic_vector(12 downto 0); --signal for Data Flow
    signal st : std_logic_vector(15 downto 0); --signal for strutctural
    signal co : std_logic_vector(15 downto 0); --signal for comportamental
    
    --Inverter for the structural model
    component opinv port
    ( ai : in std_logic;
      oinv : out std_logic   
    );
    end component;
    
    --NAND for the structural model
    component opnand port
    ( inp : in std_logic_vector(1 downto 0);
      sout : out std_logic 
    );
    end component; 
    
    begin
    
    --Start(Data flow)
        output(0) <= pr(12);
            
            pr(0) <= not(input(1)) nand input(2);
            pr(1) <= input(0) nand not(input(1));
            pr(2) <= pr(0) nand pr(0);
            pr(3) <= pr(1) nand pr(1);
            pr(4) <= pr(2) nand not(input(3));
            pr(5) <= pr(3) nand not(input(2));
            pr(6) <= pr(4) nand pr(5);
            pr(7) <= pr(6) nand pr(6);
            pr(8) <= not(input(0)) nand input(1);
            pr(9) <= not(input(0)) nand input(2);
            pr(10) <= pr(8) nand pr(9);
            pr(11) <= pr(10) nand pr(10);
            pr(12) <= pr(7) nand pr(11);
     --End(Data Flow) 
     
     --Start(Structural)  
        --NOT X
        not_1 : opinv port map(
            ai => input(0),
            oinv => st(0)      
        );
        
        --NOT Y
        not_2 : opinv port map(
            ai => input(1),
            oinv => st(1)      
        );
        
        --NOT W
        not_3 : opinv port map(
            ai => input(2),
            oinv => st(2)      
        );
        
        --NOT Z
        not_4 : opinv port map(
            ai => input(3),
            oinv => st(3)      
        );
        
        --NANDs
        nand_1 : opnand port map(
            inp(0) => st(1),
            inp(1) => input(2),
            sout => st(4)
        );
        
        nand_2 : opnand port map(
            inp(0) => input(0),
            inp(1) => st(1),
            sout => st(5)
        );
        
        nand_3 : opnand port map(
            inp(0) => st(4),
            inp(1) => st(4),
            sout => st(6)
        );
        
        nand_4 : opnand port map(
            inp(0) => st(5),
            inp(1) => st(5),
            sout => st(7)
        );
        
        nand_5 : opnand port map(
            inp(0) => st(6),
            inp(1) => st(3),
            sout => st(8)
        );
        
        nand_6 : opnand port map(
            inp(0) => st(7),
            inp(1) => st(2),
            sout => st(9)
        );
        
        nand_7 : opnand port map(
            inp(0) => st(8),
            inp(1) => st(9),
            sout => st(10)
        );
        
        nand_8 : opnand port map(
            inp(0) => st(10),
            inp(1) => st(10),
            sout => st(11)
        );
        
        nand_9 : opnand port map(
            inp(0) => st(0),
            inp(1) => input(1),
            sout => st(12)
        );
        
        nand_10 : opnand port map(
            inp(0) => st(0),
            inp(1) => input(2),
            sout => st(13)
        );
        
        nand_11 : opnand port map(
            inp(0) => st(12),
            inp(1) => st(13),
            sout => st(14)
        );
        
        nand_12 : opnand port map(
            inp(0) => st(14),
            inp(1) => st(14),
            sout => st(15)
        );
        
        nand_13 : opnand port map(
            inp(0) => st(11),
            inp(1) => st(15),
            sout => output(1)
        ); 
     --END(Structural)
     
     --Start(Comportamental)
    process(input)
        begin
        case input is
            when "0000" | "0\001" | "0010" | "0011" | "0100" | "1110" | "1111" => 
            output(2) <= '1';
            when others => 
            output(2) <= '0'; 
        end case;
    end process;      
     --END(Comportamental)

end Behavioral;