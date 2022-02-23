----------------------------------------------------------------------------------
-- Company: Universidad de Antioquia
-- Engineer: Simon Sanchez Rua - Juan Camilo Arteaga Ibarra
-- 
-- Create Date: 02/11/2022 05:24:01 PM
-- Design Name: Diseño e implemetacion de circuitos combinacionales modulare
-- Module Name: Circuit - Behavioral
-- Project Name: Practica 3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

use STD.textio.all;
use IEEE.std_logic_textio.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity Circuit is
  Port (
        Add_A : in STD_LOGIC_VECTOR(2 downto 0);
        Add_B : in STD_LOGIC_VECTOR(2 downto 0);
        DataA : in STD_LOGIC_VECTOR(3 downto 0);
        DataB : in STD_LOGIC_VECTOR(3 downto 0);
        FA : in STD_LOGIC;
        FB : in STD_LOGIC;
        en : in STD_LOGIC_VECTOR(0 to 2);
        Sel_ALU : in STD_LOGIC_VECTOR(2 downto 0);
        Salida : out STD_LOGIC_VECTOR(6 downto 0);
        clk : in STD_LOGIC;
        carry : out STD_LOGIC
  );
end Circuit;


architecture Behavioral of Circuit is

    --CLOCK 
    signal clk1 : std_logic;
    --Counter    
    signal aux : integer := 1;

    --ROMs outputs
    signal outROMA : std_logic_vector(3 downto 0);
    signal outROMB : std_logic_vector(3 downto 0);
    
    --Processes outputs
    signal BA : STD_LOGIC_VECTOR(3 downto 0);
    signal BB : STD_LOGIC_VECTOR(3 downto 0);
    signal S : STD_LOGIC_VECTOR(4 downto 0); --Pos 4, carry out
    signal Resultado : STD_LOGIC_VECTOR(3 downto 0);
    
    --Signals for Flip Flops
    signal QA, QB, QC : STD_LOGIC_VECTOR(3 downto 0);
    
    --ROMs
    component ROMa port
        ( addA : in std_logic_vector(2 downto 0);
          outA : out std_logic_vector(3 downto 0)
          ); 
    end component;
    
    component ROMb port
        ( addB : in std_logic_vector(2 downto 0);
          outB : out std_logic_vector(3 downto 0)
          ); 
    end component;

    begin
        
    --CLOCK
    CLK_DIV1 : process(clk)
        begin
            if (clk' event and clk='1') then
                if(aux = 100000000) then                    
                    aux <= 1;
                    clk1 <= not(clk1);
                else
                    aux <= aux + 1;
                end if;
            end if;
    end process;
        
--------Upper Components
        Rom_A : ROMa port map(
                 addA => Add_A,
                 outA => outROMA   
             );
    --MUX 2:1         
        process(FA)
            begin                
                if FA = '0' then
                    BA <= outROMA;
                else 
                    BA <= DataA;                    
                end if;
        end process;

     --FLIP FLOP
        process(clk1)
            begin
            if (clk1' event and clk1='1') then
                if (en(0) = '1') then
                    QA <= BA;
                end if;
            end if;          
        end process;        
    
    
--------Lower Components             
        Rom_B : ROMb port map(
                 addB => Add_B,
                 outB => outROMB   
             );
             
    --Buffers
        BB <= DataB when not(FB) = '1' else "ZZZZ";
        BB <= outROMB when not(not(FB)) = '1' else "ZZZZ";
    
--    process(FB)
--            begin
--                if not(FB) = '1' then
--                    BB <= DataB;
--                elsif not(FB) = '0' then
--                    BB <= "ZZZZ";
--                elsif not(not(FB)) = '1' then                     
--                    BB <= outROMB;
--                elsif not(not(FB)) = '0' then
--                    BB <= "ZZZZ";
--                end if;                                            
--        end process;

    --FLIP - FLOP 2
        process(clk1)
        begin
            if (clk1' event and clk1='1') then
                if (en(1) = '1') then
                    QB <= BB;
                end if;
            end if;
        end process;
              
--------ALU
        process(Sel_ALU)
            begin
                if(Sel_ALU = "000") then
                    if(QA < QB) then
                        s <= "0000";
                    else
                        s <= QA - QB;
                    end if;
                
                elsif (Sel_ALU ="001") then
                    s <= QA nor QB;
                    
                elsif (Sel_ALU ="010") then
                    s <= QA + 2;
                    
                elsif (Sel_ALU ="011") then
                    s <= QA xnor QB;
                    
                elsif (Sel_ALU ="100") then
                    s <= QB;
                    
                elsif (Sel_ALU ="101") then
                    s <= QA + QA;
                   
                elsif (Sel_ALU ="110") then
                    s <= QB + QA;
                    
                else
                    s <= QA and QB;
                                                                 
                end if;
                carry <= s(4);
            end process;
            
    --FLIP - FLOP 3
        process(clk1)
        begin
            if (clk1' event and clk1='1') then 
                if (en(2) = '1') then
                    QC <= s(3 downto 0);
                end if;                    
            end if;
        end process;
        
    --Decoder BCD
        process(QC)
        begin
            case QC is
                when "0000" =>
                    salida <= "0000001";
                when "0001" =>
                    salida <= "1001111"; 
                when "0010" =>
                    salida <= "0010010";
                when "0011" =>
                    salida <= "0000110";
                when "0100" =>
                    salida <= "1001100";
                when "0101" =>
                    salida <= "0100100";
                when "0110" =>
                    salida <= "1100000";
                when "0111" =>
                    salida <= "0001110";
                when "1000" =>
                    salida <= "0000000";
                when "1001" =>
                    salida <= "0000100";
                when "1010" =>
                    salida <= "0001000";
                when "1011" =>
                    salida <= "1100000";
                when "1100" =>
                    salida <= "0110001";
                when "1101" =>
                    salida <= "1000010";
                when "1110" =>
                    salida <= "0110000";
                when others =>
                     salida <= "0111000";                         
            end case; 
        end process;                          
end Behavioral;
