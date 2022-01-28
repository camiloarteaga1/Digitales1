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
           output : out STD_LOGIC_VECTOR (2 downto 0);
           a, b : in std_logic;
           c : out std_logic
    );
end fun;

architecture ownand of fun is
    begin
        c <= a nand b;
end ownand;

architecture inv of fun is
    begin
        c <= not a;
end inv;

architecture Behavioral of fun is

    signal pr : std_logic_vector(12 downto 0); --signal for Data Flow
    signal st : std_logic_vector(15 downto 0); --signal for strutctural
    signal co : std_logic_vector(11 downto 0); --signal for comportamental
    
    --Inverter for the structural model
    component inv port
    ( ai : in std_logic;
      oinv : out std_logic   
    );
    end component;
    
    --NAND for the structural model
    component ownand port
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
        not_1 : inv port map(
            ai => input(0),
            oinv => st(0)      
        );
        
        --NOT Y
        not_2 : inv port map(
            ai => input(1),
            oinv => st(1)      
        );
        
        --NOT W
        not_3 : inv port map(
            ai => input(2),
            oinv => st(2)      
        );
        
        --NOT Z
        not_4 : inv port map(
            ai => input(3),
            oinv => st(3)      
        );
        
        --NANDs
        nand_1 : ownand port map(
            inp(0) => st(1),
            inp(1) => input(2),
            sout => st(4)
        );
        
        nand_2 : ownand port map(
            inp(0) => input(0),
            inp(1) => st(1),
            sout => st(5)
        );
        
        nand_3 : ownand port map(
            inp(0) => st(4),
            inp(1) => st(4),
            sout => st(6)
        );
        
        nand_4 : ownand port map(
            inp(0) => st(5),
            inp(1) => st(5),
            sout => st(7)
        );
        
        nand_5 : ownand port map(
            inp(0) => st(6),
            inp(1) => st(3),
            sout => st(8)
        );
        
        nand_6 : ownand port map(
            inp(0) => st(7),
            inp(1) => st(2),
            sout => st(9)
        );
        
        nand_7 : ownand port map(
            inp(0) => st(8),
            inp(1) => st(9),
            sout => st(10)
        );
        
        nand_8 : ownand port map(
            inp(0) => st(10),
            inp(1) => st(10),
            sout => st(11)
        );
        
        nand_9 : ownand port map(
            inp(0) => st(0),
            inp(1) => input(1),
            sout => st(12)
        );
        
        nand_10 : ownand port map(
            inp(0) => st(0),
            inp(1) => input(2),
            sout => st(13)
        );
        
        nand_11 : ownand port map(
            inp(0) => st(12),
            inp(1) => st(13),
            sout => st(14)
        );
        
        nand_12 : ownand port map(
            inp(0) => st(14),
            inp(1) => st(14),
            sout => st(15)
        );
        
        nand_13 : ownand port map(
            inp(0) => st(11),
            inp(1) => st(15),
            sout => output(1)
        ); 
     --END(Structural)
     
     --Start(Comportamental)
        process(input)
            begin
                co(0) <= not(input(1)) nand input(2);
                co(1) <= input(0) nand not(input(1));
                co(2) <= co(0) nand co(0);
                co(3) <= co(1) nand co(1);
                co(4) <= co(2) nand not(input(3));
                co(5) <= co(3) nand not(input(2));
                co(6) <= co(4) nand co(5);
                co(7) <= co(6) nand co(6);
                co(8) <= not(input(0)) nand input(1);
                co(9) <= not(input(0)) nand input(2);
                co(10) <= co(8) nand co(9);
                co(11) <= co(10) nand co(10);
                output(2) <= co(7) nand co(11);
        end process;
     --END(Comportamental)

end Behavioral;
