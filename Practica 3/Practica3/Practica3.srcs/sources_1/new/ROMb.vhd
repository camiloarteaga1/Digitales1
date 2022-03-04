library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ROMb is 
    Port ( 
        addB : in std_logic_vector(2 downto 0);
        outB : out STD_LOGIC_VECTOR (3 downto 0));
end ROMb;

architecture Behavioral of ROMb is
    type rom_type is array (0 to 7) of std_logic_vector (3 downto 0);
    constant ROM : rom_type :=(x"5",x"7",x"3",x"8",x"2",x"9",x"1",x"A");
    
    -- inicio de la arquitectura
    Begin
        outB <= ROM(conv_integer(addB));
end Behavioral;
