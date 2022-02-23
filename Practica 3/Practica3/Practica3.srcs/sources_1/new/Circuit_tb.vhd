----------------------------------------------------------------------------------
-- Company: UdeA
-- Engineer: Simon Sanchez Rua - Juan Camilo Arteaga Ibarra
-- 
-- Create Date: 2/23/2022
-- Design Name: Circuit_tb
-- Module Name: Circuit_tb - Behavioral
-- Project Name: Practica 3
-- Target Devices: Basys 3
-- 
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

Entity Circuit_tb Is
end Circuit_tb;

Architecture behavior of Circuit_tb Is
	Component Circuit
        port (
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
    end Component;
        
    Signal add_a : STD_LOGIC_VECTOR(2 downto 0);
    Signal add_b : STD_LOGIC_VECTOR(2 downto 0);
    Signal dataa : STD_LOGIC_VECTOR(3 downto 0);
    Signal datab : STD_LOGIC_VECTOR(3 downto 0);
    Signal fa : STD_LOGIC;
    Signal fb : STD_LOGIC;
    Signal ena : STD_LOGIC_VECTOR(0 to 2);
    Signal sel_ALU : STD_LOGIC_VECTOR(2 downto 0);
    Signal salida : STD_LOGIC_VECTOR(6 downto 0);
    Signal CLK : STD_LOGIC;
    Signal Carry : STD_LOGIC;
          
    --RomA           
    procedure RomA(
        addrs : in std_logic_vector(2 downto 0);
        data : out std_logic_vector(3 downto 0)
    ) is
        
        type rom_type is array (0 to 7) of std_logic_vector (3 downto 0);
        constant ROM : rom_type :=(x"7",x"6",x"5",x"3",x"1",x"F",x"D",x"A");
        
        begin
            data := ROM(conv_integer(addrs));
        
    end RomA;
    
    --RomB
    procedure RomB(
        addrs : in std_logic_vector(2 downto 0);
        data : out std_logic_vector(3 downto 0)
    ) is
        
        type rom_type is array (0 to 7) of std_logic_vector (3 downto 0);
        constant ROM : rom_type :=(x"5",x"7",x"3",x"8",x"2",x"9",x"1",x"A");
        
        begin
            data := ROM(conv_integer(addrs));
        
    end RomB;
    
    --Buffers
    procedure Buffers(
        inputData : in std_logic_vector(3 downto 0) := "0000";
        inputRomB : in std_logic_vector(3 downto 0) := "0000";
        outputBuffer : out std_logic_vector(3 downto 0)
    )is
    
    variable expectedOutput : std_logic_vector(3 downto 0);
            
    begin
   
        if not(fb)='1' then
            expectedOutput := inputData;
            
        elsif not(not(fb)) = '1' then
            expectedOutput := inputRomB;
        
        else
            expectedOutput := "ZZZZ";
        end if;
        
        outputBuffer := expectedOutput;
    End Buffers;
            
    
            
begin
end behavior;