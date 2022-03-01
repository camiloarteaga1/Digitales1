----------------------------------------------------------------------------------
-- Company: UdeA
-- Engineer: Simon Sanchez Rua - Juan Camilo Arteaga Ibarra
-- 
-- Create Date: 2/23/2022
-- Design Name: Circuit_tb
-- Module Name: Circuit_tb - Behavioral
-- Project Name: Practica 3
-- Target Devices: Basys 3
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

Architecture Behavioral of Circuit_tb Is
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
            carry : out STD_LOGIC;
            clockprobe : out std_logic
            );	
    end Component;
        
    Signal add_a : STD_LOGIC_VECTOR(2 downto 0) := "000";
    Signal add_b : STD_LOGIC_VECTOR(2 downto 0) := "000";
    Signal dataa : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    Signal datab : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    Signal fa : STD_LOGIC := '0';
    Signal fb : STD_LOGIC := '0';
    Signal ena : STD_LOGIC_VECTOR(0 to 2) := "001";
    Signal sel_ALU : STD_LOGIC_VECTOR(2 downto 0) := "000";
    Signal salida : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    Signal CLK : STD_LOGIC := '0';
    Signal clkprobe : STD_LOGIC := '0';
    Signal Carry : STD_LOGIC := '0';
    Signal clkpr : std_logic := '0';
            
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
            outputQ := inputD;
        else
            outputQ := expectedOutput;
                    
        End if;
        
        --outputQ := expectedOutput;
        
    End FLIPFLOP;      
    
    --ALU
    procedure ALU(
        inputQa1 : in std_logic_vector(3 downto 0);
        inputQb2 : in std_logic_vector(3 downto 0);
        inputSel_ALU : in std_logic_vector(2 downto 0);
        outputS : out std_logic_vector(3 downto 0);
        outputC : out std_logic
    ) is
    
    variable s : std_logic_vector(4 downto 0) := "00000";
    variable inputQ1 : std_logic_vector(4 downto 0);
    variable inputQ2 : std_logic_vector(4 downto 0);
    
    begin
    
        inputQ1 := '0'&inputQa1;
        inputQ2 := '0'&inputQb2;
        
        if(inputSel_ALU = "000") then
            if(inputQ1 < inputQ2) then    
                s := "00000";              
            else
                s := inputQ1 - inputQ2;
            end if;
        
        elsif (inputSel_ALU ="001") then
            s(3 downto 0) := inputQ1(3 downto 0) nor inputQ2(3 downto 0);
            
        elsif (inputSel_ALU ="010") then
            s := inputQ1 + 2;
            
        elsif (inputSel_ALU ="011") then
            s(3 downto 0) := inputQ1(3 downto 0) xnor inputQ2(3 downto 0);
            
        elsif (inputSel_ALU ="100") then
            s := inputQ2;
            
        elsif (inputSel_ALU ="101") then
            s := inputQ1 + inputQ1;
           
        elsif (inputSel_ALU ="110") then
            s := inputQ2 + inputQ1;
            
        else
            s(3 downto 0) := inputQ1(3 downto 0) and inputQ2(3 downto 0);
                                                         
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
        Add_A => add_a,
        Add_B => add_b,
        DataA => dataa,
        DataB => datab,
        FA => fa,
        FB => fb,
        en => ena,
        Sel_ALU => sel_ALU,
        Salida => salida,
        clk => CLK,
        carry => Carry,
        clockprobe => clkprobe
    );
    
    process
        begin
            CLK <= '0';
            wait for 5ns;
            CLK <= '1';
            wait for 5ns;
    end process;
    
    process
        begin
            
            ena(2) <= '1';
            clkpr <= '0';
            
            wait for 95ms;
            ena(0) <= '1';
            ena(1) <= '1';
            
            wait for 5ms;
            clkpr <= '1';
            
            wait for 5ms;
            ena(2) <= '0';
            
            wait for 95ms;            
            clkpr <= '0';
            
            wait for 95ms;
            ena(2) <= '1';
            
            wait for 5ms;
            clkpr <= '1';                    
            
            wait for 5ms;
            ena(0) <= '0';
            ena(1) <= '0';
            
            wait for 95ms;
    end process;
    
    process
        variable s : line;
        variable auxa : integer := 0;
        variable auxb : integer := 0;
        variable count_adda : integer := 0;
        variable count_addb : integer := 0;
        variable count_dataa : integer := 0;
        variable count_datab : integer := 0;
        variable count_dataSel : integer := 0;
        variable output7 : std_logic_vector(6 downto 0);
        variable flipflop1 : std_logic_vector(3 downto 0);
        variable flipflop2 : std_logic_vector(3 downto 0);
        variable flipflop3 : std_logic_vector(3 downto 0);
        variable upper : std_logic_vector(3 downto 0);
        variable lower : std_logic_vector(3 downto 0);      
        variable outputALU : std_logic_vector(3 downto 0);
        variable outCarry : std_logic;
        variable enable : std_logic;
        variable outRomA : std_logic_vector(3 downto 0);
        variable outRomB : std_logic_vector(3 downto 0);
      
    begin
        for auxa in 0 to 1 loop
            if auxa = 0 then
                fa <= '0';
            else
                fa <= '1';                
            end if;
            for auxb in 0 to 1 loop
                if auxb = 0 then
                    fb <= '0';
                else
                    fb <= '1';                
                end if;
                write(s, string'(" FA: "));write (s, fa);write(s, string'(" FB: "));write (s, fb);
                writeline (output, s); 
                if fa = '0' and fb = '0' then
                    for count_adda in 0 to 7 loop
                        for count_datab in 0 to 15 loop
                            wait for 100ms;
                            
                            RomA(add_a, outRomA);
                            RomB(add_b, outRomB);
                            MUX(dataa, outRomA, fa, upper);
                            Buffers(datab, outRomB, fb, lower);     
                            FLIPFLOP(ena(0), upper, flipflop1); --First Flip-Flop                            
                            FLIPFLOP(ena(1), lower, flipflop2); --Second Flip-Flop  
                                                      
                            
                            for count_dataSel in 0 to 7 loop
                            
                                if count_dataSel = 0 then
                                    wait for 200ms;
                                else
                                    wait for 400ms;
                                end if;
                                                             
--                                write(s, string'("Enable A: "));write (s, ena(2));
--                                writeline(output, s);
--                                write(s, string'("Enable D: "));write (s, ena(2));
--                                writeline(output, s);
                                ALU(flipflop1, flipflop2, sel_ALU, outputALU, outCarry);
                                --Carry <= outCarry;
                                FLIPFLOP(ena(2), outputALU, flipflop3); --Third FLip-Flop
                                Decoder(flipflop3, output7); --Last operation                                
                                
                                write(s, string'("Address A: "));write (s, add_a);write(s, string'(" ROM A: "));write (s, outRomA);write(s, string'(" Data B: "));write (s, datab);write(s, string'(" FLIP FLOP A: "));write (s, flipflop1);write(s, string'(" FLIP FLOP B: "));write (s, flipflop2);write(s, string'(" FLIP FLOP C: "));write (s, flipflop3);
                                writeline(output, s);
                                write(s, string'(" Expected Out Decoder: "));write (s, output7);write(s, string'(" Actual Out Decoder: "));write (s, salida);write(s, string'(" Expected Out Carry: "));write (s, outCarry);write(s, string'(" Actual Out Carry: "));write (s, Carry);                  
                                writeline (output, s);
                                write(s, string'(" Expected ALU: "));write (s, outputALU);
                                writeline (output, s);
                                write(s, string'(" sel ALU: "));write (s, sel_ALU);
                                writeline (output, s); 
                                sel_ALU <= sel_ALU + 1; --Change the Sel Alu value
                                          
                            end loop;
                            wait for 100ms;
                            sel_ALU <= "000";
                            datab <= datab + 1;
                            
                        end loop;
                        
                        datab <= "0000";
                        add_a <= add_a + 1;
                        
                    end loop;
                    
                    add_a <= "000";
                    
                elsif fa = '0' and fb = '1' then
                    for count_adda in 0 to 7 loop
                        for count_addb in 0 to 7 loop
                            wait for 100ms;
                             
                            RomA(add_a, outRomA);
                            RomB(add_b, outRomB);
                            MUX(dataa, outRomA, fa, upper);
                            Buffers(datab, outRomB, fb, lower);                                                                                   
                            FLIPFLOP(ena(0), upper, flipflop1); --First Flip-Flop                            
                            FLIPFLOP(ena(1), lower, flipflop2); --Second Flip-Flop
                            
                            for count_dataSel in 0 to 7 loop
                            
                                if count_dataSel = 0 then
                                    wait for 200ms;
                                else
                                    wait for 400ms;
                                end if;
                                
                                ALU(flipflop1, flipflop2, sel_ALU, outputALU, outCarry);
                                --Carry <= outCarry;
                                FLIPFLOP(ena(2), outputALU, flipflop3); --Third FLip-Flop
                                Decoder(flipflop3, output7); --Last operation
                                
                                write(s, string'("Address A: "));write (s, add_a);write(s, string'(" ROM A: "));write (s, outRomA);write(s, string'(" Data B: "));write (s, datab);write(s, string'(" FLIP FLOP A: "));write (s, flipflop1);write(s, string'(" FLIP FLOP B: "));write (s, flipflop2);write(s, string'(" FLIP FLOP C: "));write (s, flipflop3);
                                writeline(output, s);
                                write(s, string'(" Expected Out Decoder: "));write (s, output7);write(s, string'(" Actual Out Decoder: "));write (s, salida);write(s, string'(" Expected Out Carry: "));write (s, outCarry);write(s, string'(" Actual Out Carry: "));write (s, Carry);                  
                                writeline (output, s);
                                write(s, string'(" Expected ALU: "));write (s, outputALU);
                                writeline (output, s);
                                write(s, string'(" sel ALU: "));write (s, sel_ALU);
                                writeline (output, s);
                                sel_ALU <= sel_ALU + 1; --Change the Sel Alu value 
                                
                            end loop;
                            
                            wait for 100ms;
                            sel_ALU <= "000";
                            add_b <= add_b + 1;
                            
                        end loop;
                        
                        add_b <= "000";
                        add_a <= add_a + 1;
                        
                    end loop;
                    add_a <= "000";
                
                elsif fa = '1' and fb = '0' then
                    for count_dataa in 0 to 15 loop
                        for count_datab in 0 to 15 loop
                            wait for 100ms;
                           
                            RomA(add_a, outRomA);
                            RomB(add_b, outRomB);
                            MUX(dataa, outRomA, fa, upper);
                            Buffers(datab, outRomB, fb, lower);
                            FLIPFLOP(ena(0), upper, flipflop1); --First Flip-Flop
                            FLIPFLOP(ena(1), lower, flipflop2); --Second Flip-Flop
                            
                            for count_dataSel in 0 to 7 loop
                            
                                if count_dataSel = 0 then
                                    wait for 200ms;
                                else
                                    wait for 400ms;
                                end if;
                                
                                ALU(flipflop1, flipflop2, sel_ALU, outputALU, outCarry);
                                --Carry <= outCarry;
                                FLIPFLOP(ena(2), outputALU, flipflop3); --Third FLip-Flop
                                Decoder(flipflop3, output7); --Last operation
                                
                                write(s, string'("Address A: "));write (s, add_a);write(s, string'(" ROM A: "));write (s, outRomA);write(s, string'(" Data B: "));write (s, datab);write(s, string'(" FLIP FLOP A: "));write (s, flipflop1);write(s, string'(" FLIP FLOP B: "));write (s, flipflop2);write(s, string'(" FLIP FLOP C: "));write (s, flipflop3);
                                writeline(output, s);
                                write(s, string'(" Expected Out Decoder: "));write (s, output7);write(s, string'(" Actual Out Decoder: "));write (s, salida);write(s, string'(" Expected Out Carry: "));write (s, outCarry);write(s, string'(" Actual Out Carry: "));write (s, Carry);                  
                                writeline (output, s);
                                write(s, string'(" Expected ALU: "));write (s, outputALU);
                                writeline (output, s);
                                write(s, string'(" sel ALU: "));write (s, sel_ALU);
                                writeline (output, s);
                                sel_ALU <= sel_ALU + 1; --Change the Sel Alu value 
                                
                            end loop;
                            
                            wait for 100ms;
                            sel_ALU <= "000";
                            datab <= datab + 1;
                            
                        end loop;
                        
                        datab <= "0000";
                        dataa <= dataa + 1;
                        
                    end loop;
                    dataa <= "0000";
                        
                else
                    for count_dataa in 0 to 15 loop
                        for count_addb in 0 to 7 loop
                            wait for 100ms;
                              
                            RomA(add_a, outRomA);
                            RomB(add_b, outRomB);
                            MUX(dataa, outRomA, fa, upper);
                            Buffers(datab, outRomB, fb, lower);                            
                            FLIPFLOP(ena(0), upper, flipflop1); --First Flip-Flop
                            FLIPFLOP(ena(1), lower, flipflop2); --Second Flip-Flop
                            
                            for count_dataSel in 0 to 7 loop
                            
                                if count_dataSel = 0 then
                                    wait for 200ms;
                                else
                                    wait for 400ms;
                                end if;
                                
                                ALU(flipflop1, flipflop2, sel_ALU, outputALU, outCarry);
                                --Carry <= outCarry;
                                FLIPFLOP(ena(2), outputALU, flipflop3); --Third FLip-Flop
                                Decoder(flipflop3, output7); --Last operation
                                
                                write(s, string'("Address A: "));write (s, add_a);write(s, string'(" ROM A: "));write (s, outRomA);write(s, string'(" Data B: "));write (s, datab);write(s, string'(" FLIP FLOP A: "));write (s, flipflop1);write(s, string'(" FLIP FLOP B: "));write (s, flipflop2);write(s, string'(" FLIP FLOP C: "));write (s, flipflop3);
                                writeline(output, s);
                                write(s, string'(" Expected Out Decoder: "));write (s, output7);write(s, string'(" Actual Out Decoder: "));write (s, salida);write(s, string'(" Expected Out Carry: "));write (s, outCarry);write(s, string'(" Actual Out Carry: "));write (s, Carry);                  
                                writeline (output, s);
                                write(s, string'(" Expected ALU: "));write (s, outputALU);
                                writeline (output, s);
                                write(s, string'(" sel ALU: "));write (s, sel_ALU);
                                writeline (output, s);
                                sel_ALU <= sel_ALU + 1; --Change the Sel Alu value 
                                
                            end loop;
                            
                            wait for 100ms;
                            sel_ALU <= "000";
                            add_b <= add_b + 1;

                        end loop;
                        
                        add_b <= "000";
                        dataa <= dataa + 1;
                      
                    end loop;
                    dataa <= "0000";
                
                End if;
                
            end loop;
            
            --fb <= '0';
            auxb := 0;
        
        end loop;             
    
    end process;
    
end Behavioral;