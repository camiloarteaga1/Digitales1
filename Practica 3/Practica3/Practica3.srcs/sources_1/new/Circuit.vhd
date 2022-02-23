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

    signal outROMA : std_logic_vector(3 downto 0);
    signal outROMB : std_logic_vector(3 downto 0);
    signal aux : integer;
    signal BA : STD_LOGIC_VECTOR(3 downto 0);
    signal BB : STD_LOGIC_VECTOR(3 downto 0);
    signal S : STD_LOGIC_VECTOR(4 downto 0); --Pos 4, carry out
    signal Resultado : STD_LOGIC_VECTOR(3 downto 0);
    
    --Signals for Flip Flops
    signal QA, QB, QC : STD_LOGIC_VECTOR(3 downto 0);
    
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
    
    --Upper Components
        Rom_A : ROMa port map(
                 addA => Add_A,
                 outA => outROMA   
             );
             
        process
            begin
                wait for 10ms;
                if FA = '0' then
                    BA <= outROMA;
                else 
                    BA <= DataA;                    
                end if;
        end process;
        
    --FLIP - FLOP 1
    CLK_DIV1 : process(clk)
        begin
            if (clk' event and clk='1') then
                if(aux = 100000000) then
                    if (en(0) = '1') then
                        QA <= BA;
                    end if;
                    aux <= 0;
                else
                    aux <= aux+1;
                end if;
            end if;               
    end process;
    
    --Lower Components             
        Rom_B : ROMb port map(
                 addB => Add_B,
                 outB => outROMB   
             );
             
    --Buffers
        BB <= DataB when not(FB) = '1' else "ZZZZ";
        BB <= outROMB when not(not(FB)) = '1' else "ZZZZ";
        
    --FLIP - FLOP 2
        CLK_DIV2 : process(clk)
        begin
            if (clk' event and clk='1') then
                if(aux = 100000000) then
                    if (en(1) = '1') then
                        QB <= BB;
                    end if;
                    aux <= 0;
                else
                    aux <= aux+1;
                end if;
            end if;
        end process;
              
     --ALU
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
        CLK_DIV3 : process(clk)
        begin
            if (clk' event and clk='1') then
                if(aux = 100000000) then
                    if (en(2) = '1') then
                        QC <= s(3 downto 0);
                    end if;
                    aux <= 0;
                else
                    aux <= aux+1;
                end if;
            end if;
        end process;
        
    --Decoder                                            
end Behavioral;
