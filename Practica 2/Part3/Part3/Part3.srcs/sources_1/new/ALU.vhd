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
    Port( inputA : in STD_LOGIC_VECTOR(4 downto 0);
          inputB : in STD_LOGIC_VECTOR(4 downto 0);
          inputXY : in STD_LOGIC_VECTOR(1 downto 0);
          outputS : out STD_LOGIC_VECTOR(4 downto 0);          
          output7 : out STD_LOGIC_VECTOR(6 downto 0)
          );              
end ALU;

architecture Behavioral of ALU is    

    Signal outputSF : std_logic_vector(4 downto 0); 
    begin
        process(inputXY)
        
            begin
            outputS(4) <= '0';
                if inputXY = "11" then
                    outputS(3 downto 0) <= inputA(3 downto 0) xor inputB(3 downto 0);
                    outputSF(3 downto 0) <= inputA(3 downto 0) xor inputB(3 downto 0);                      
                elsif inputXY = "10" then
                    if inputB < 2 then
                        outputS <= "00000";
                        outputSF <= "00000";
                    else
                        outputS <= inputB-2;
                        outputSF <= inputB-2;
                    end if;                         
                elsif inputXY = "01" then
                    outputS <= inputA + inputB;
                    outputSF <= inputA + inputB;
                    
                else
                    outputS(3 downto 0) <= inputA(3 downto 0) nor inputB(3 downto 0);
                    outputSF(3 downto 0) <= inputA(3 downto 0) nor inputB(3 downto 0);                                                                   
                end if;                
                case outputSF(3 downto 0) is 
                when "0000" =>
                output7 <= "0000001";
                when "0001" =>
                output7 <= "1001111"; 
                when "0010" =>
                output7 <= "0010010";
                when "0011" =>
                output7 <= "0000110";
                when "0100" =>
                output7 <= "1001100";
                when "0101" =>
                output7 <= "0100100";
                when "0110" =>
                output7 <= "1100000";
                when "0111" =>
                output7 <= "0001110";
                when "1000" =>
                output7 <= "0000000";
                when "1001" =>
                output7 <= "0000100";
                when "1010" =>
                output7 <= "1111110";
                when "1011" =>
                output7 <= "0110000";
                when "1100" =>
                output7 <= "1101101";
                when "1101" =>
                output7 <= "1111001";
                when "1110" =>
                output7 <= "0110011";
                when others =>
                 output7 <= "1011011";                 
            end case;                
        end process;                                                  
--        process(outputSF)
--            begin
--            case outputSF is 
--                when "0000" =>
--                output7 <= "0000001";                
--            end case;            
--        end process;            
end Behavioral;
