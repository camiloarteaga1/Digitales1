----------------------------------------------------------------------------------
-- Company: Universidad de Antioquia
-- Engineer: Simon Sanchez Rua - Juan Camilo Arteaga Ibarra
-- 
-- Design Name: Practica 2
-- Module Name: Parte 3 (ALU)
-- Project Name: Diseno e implementacion de circuitos combinacionales 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use STD.textio.all;
use IEEE.std_logic_textio.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;


entity ALU is
    Port( inputA : in STD_LOGIC_VECTOR(3 downto 0);
          inputB : in STD_LOGIC_VECTOR(3 downto 0);
          inputXY : in STD_LOGIC_VECTOR(1 downto 0);
          outputS : out STD_LOGIC_VECTOR(3 downto 0);
          output7 : out STD_LOGIC_VECTOR(6 downto 0)
          );              
end ALU;

architecture Behavioral of ALU is    

    begin
        process(inputXY)
            begin
                if inputXY = "11" then
                    outputS <= inputA xor inputB;
                elsif inputXY = "10" then
                    if inputB < 2 then
                        outputS <= "0000";
                    else
                        outputS <= inputB-2;
                    end if;                         
                elsif inputXY = "01" then
                    outputS <= inputA + inputB;
                else
                    outputS <= inputA nor inputB;                                                                   
                end if;                
        end process;                                                  
--        process(outputSF)
--            begin
--            case outputSF is 
--                when "0000" =>
--                output7 <= "0000001";                
--            end case;            
--        end process;            
end Behavioral;
