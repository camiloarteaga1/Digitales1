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
    signal outp : std_logic;
    
    
    --Inverter for the structural model
    component opinv port
    ( a : in std_logic;
      c : out std_logic   
    );
    end component;
    
    --NAND for the structural model
    component opnor port
    ( inp : in std_logic_vector(1 downto 0);
      sout : out std_logic 
    );
    end component; 
    
    begin
    
    --Start(Data flow)
        
            
            pr(0) <= not(input(2)) nor input(1);
            pr(1) <= input(3) nor not(input(2));
            pr(2) <= not(pr(0));
            pr(3) <= not(pr(1));
            pr(4) <= pr(2) nor not(input(0));
            pr(5) <= pr(3) nor not(input(1));
            pr(6) <= pr(4) nor pr(5);
            pr(7) <= not pr(6);
            pr(8) <= not(input(3)) nor input(2);
            pr(9) <= not(input(3)) nor input(1);
            pr(10) <= pr(8) nor pr(9);
            pr(11) <= not pr(10);
            pr(12) <= pr(7) nor pr(11);
            output(0) <= pr(12);
     --End(Data Flow) 
     
     --Start(Structural)  
        --NOT X
        not_1 : opinv port map(
            a => input(3),
            c => st(0)      
        );
        
        --NOT Y
        not_2 : opinv port map(
            a => input(2),
            c => st(1)      
        );
        
        --NOT W
        not_3 : opinv port map(
            a => input(1),
            c => st(2)      
        );
        
        --NOT Z
        not_4 : opinv port map(
            a => input(0),
            c => st(3)      
        );
        
        --NANDs
        nand_1 : opnor port map(
            inp(0) => st(1),
            inp(1) => input(1),
            sout => st(4)
        );
        
        nand_2 : opnor port map(
            inp(0) => input(3),
            inp(1) => st(1),
            sout => st(5)
        );
        
        nand_3 : opnor port map(
            inp(0) => st(4),
            inp(1) => st(4),
            sout => st(6)
        );
        
        nand_4 : opnor port map(
            inp(0) => st(5),
            inp(1) => st(5),
            sout => st(7)
        );
        
        nand_5 : opnor port map(
            inp(0) => st(6),
            inp(1) => st(3),
            sout => st(8)
        );
        
        nand_6 : opnor port map(
            inp(0) => st(7),
            inp(1) => st(2),
            sout => st(9)
        );
        
        nand_7 : opnor port map(
            inp(0) => st(8),
            inp(1) => st(9),
            sout => st(10)
        );
        
        nand_8 : opnor port map(
            inp(0) => st(10),
            inp(1) => st(10),
            sout => st(11)
        );
        
        nand_9 : opnor port map(
            inp(0) => st(0),
            inp(1) => input(2),
            sout => st(12)
        );
        
        nand_10 : opnor port map(
            inp(0) => st(0),
            inp(1) => input(1),
            sout => st(13)
        );
        
        nand_11 : opnor port map(
            inp(0) => st(12),
            inp(1) => st(13),
            sout => st(14)
        );
        
        nand_12 : opnor port map(
            inp(0) => st(14),
            inp(1) => st(14),
            sout => st(15)
        );
        
        nand_13 : opnor port map(
            inp(0) => st(11),
            inp(1) => st(15),
            sout => output(1)
        ); 
     --END(Structural)
     -- | "0010" | "0011" | "0100" | "1110" | "1111"
     --Start(Comportamental)
    process(input)
        begin
        case input is
            when "0000"  => 
            outp <= '1';
            when "0001" =>
            outp <= '1';
            when "0010" =>
            outp <= '1';
            when "0011" =>
            outp <= '1';
            when "0100" =>
            outp <= '1';
            when "1110" =>
            outp <= '1';
            when "1111" =>
            outp <= '1';
            when others => 
            outp <= '0'; 
        end case;     
    end process;      
     --END(Comportamental)
    output(2) <= outp; 
end Behavioral;