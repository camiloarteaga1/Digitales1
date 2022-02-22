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
        BA : out STD_LOGIC_VECTOR(3 downto 0);
        BB : out STD_LOGIC_VECTOR(3 downto 0);
        S : out STD_LOGIC_VECTOR(4 downto 0); --Pos 4, carry out
        Resultado : out STD_LOGIC_VECTOR(3 downto 0);
        Salida : out STD_LOGIC_VECTOR(6 downto 0);
        clk : in STD_LOGIC
  );
end Circuit;

architecture Behavioral of Circuit is

signal outMUXA : std_logic_vector(3 downto 0);
signal outMUXB : std_logic_vector(3 downto 0);

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
process (FA, BA)
    if FA = '0' then          
         RomA_1 : ROMa port map(
         addA => Add_A,
         outA => BA   
         );
     else
        BA <= DataA;
    end if;           
end process;
end Behavioral;
