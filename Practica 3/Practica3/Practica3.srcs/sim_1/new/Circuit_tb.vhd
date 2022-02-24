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
        
    --Signal add_a : STD_LOGIC_VECTOR(2 downto 0);
    --Signal add_b : STD_LOGIC_VECTOR(2 downto 0);
    --Signal dataa : STD_LOGIC_VECTOR(3 downto 0);
    --Signal datab : STD_LOGIC_VECTOR(3 downto 0);
    --Signal fa : STD_LOGIC;
    --Signal fb : STD_LOGIC;
    --Signal ena : STD_LOGIC_VECTOR(0 to 2);
    --Signal sel_ALU : STD_LOGIC_VECTOR(2 downto 0);
    --Signal salida : STD_LOGIC_VECTOR(6 downto 0);
    --Signal CLK : STD_LOGIC;
    --Signal Carry : STD_LOGIC;
          
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
    
    --MUX 2:1
    procedure MUX(
        inputDataA : in std_logic_vector(3 downto 0);
        inputRomA : in std_logic_vector(3 downto 0);
        inputfa : in std_logic;
        outputMUX : out std_logic_vector(3 downto 0)
    ) is
    
    begin
        
        if inputfa = '0' then
            outputMUX := inputRomA;
        else
            outputMUX := inputDataA;
        End if;
        
    End MUX;  
    
    
    --Buffers
    procedure Buffers(
        inputDataB : in std_logic_vector(3 downto 0);
        inputRomB : in std_logic_vector(3 downto 0);
        inputfb : std_logic;
        outputBuffer : out std_logic_vector(3 downto 0)
    )is
            
    begin
   
        if not(inputfb)='1' then
            outputBuffer := inputDataB;
            
        elsif not(not(inputfb)) = '1' then
            outputBuffer := inputRomB;
        
        else
            outputBuffer := "ZZZZ";
        End if;
        
    End Buffers;

    --FLIP - FLOP
    procedure FLIPFLOP(
        inputEN : in std_logic;
        inputD : in std_logic_vector(3 downto 0);
        outputQ : out std_logic_vector(3 downto 0)
    ) is
    
    variable expectedOutput : std_logic_vector(3 downto 0);
    
    begin
        if inputEN = '1' then
            expectedOutput := inputD;
        else
            expectedOutput := expectedOutput;
                    
        End if;
        
        outputQ := expectedOutput;
        
    End FLIPFLOP;      
    
    --ALU
    procedure ALU(
        inputQ1 : in std_logic_vector(3 downto 0);
        inputQ2 : in std_logic_vector(3 downto 0);
        inputSel_ALU : in std_logic_vector(2 downto 0);
        outputS : out std_logic_vector(3 downto 0);
        outputC : out std_logic
    ) is
    
    variable s : std_logic_vector(4 downto 0);
    
    begin
        if(inputSel_ALU = "000") then
            if(inputQ1 < inputQ2) then
                s := "0000";
            else
                s := inputQ1 - inputQ2;
            end if;
        
        elsif (inputSel_ALU ="001") then
            s := inputQ1(3 downto 0) nor inputQ2(3 downto 0);
            
        elsif (inputSel_ALU ="010") then
            s := inputQ1 + 2;
            
        elsif (inputSel_ALU ="011") then
            s := inputQ1(3 downto 0) xnor inputQ2(3 downto 0);
            
        elsif (inputSel_ALU ="100") then
            s := inputQ2;
            
        elsif (inputSel_ALU ="101") then
            s := inputQ1 + inputQ1;
           
        elsif (inputSel_ALU ="110") then
            s := inputQ2 + inputQ1;
            
        else
            s := inputQ1(3 downto 0) and inputQ2(3 downto 0);
                                                         
        End if;
        outputC := s(4);
        outputS := s(3 downto 0);
        
    End ALU;
    
    --Decoder
    procedure Decoder(
        inputRe : in std_logic_vector(3 downto 0);
        outputS : out std_logic_vector(6 downto 0)
    ) is
    
    begin
        case inputRe is
                when "0000" =>
                    outputS := "0000001";
                when "0001" =>
                    outputS := "1001111"; 
                when "0010" =>
                    outputS := "0010010";
                when "0011" =>
                    outputS := "0000110";
                when "0100" =>
                    outputS := "1001100";
                when "0101" =>
                    outputS := "0100100";
                when "0110" =>
                    outputS := "1100000";
                when "0111" =>
                    outputS := "0001110";
                when "1000" =>
                    outputS := "0000000";
                when "1001" =>
                    outputS := "0000100";
                when "1010" =>
                    outputS := "0001000";
                when "1011" =>
                    outputS := "1100000";
                when "1100" =>
                    outputS := "0110001";
                when "1101" =>
                    outputS := "1000010";
                when "1110" =>
                    outputS := "0110000";
                when others =>
                    outputS := "0111000";                         
        End case;
    End Decoder;
        
begin
    uut : Circuit port map(
            
    );

end behavior;