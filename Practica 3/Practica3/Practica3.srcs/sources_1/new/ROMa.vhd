library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ROMa is 
    Port (
        addA : in std_logic_vector(2 downto 0);
        outA : out STD_LOGIC_VECTOR (3 downto 0)
    );
end ROMa;

architecture Behavioral of ROMa is
    type rom_type is array (0 to 7) of std_logic_vector (3 downto 0);
    constant ROM : rom_type :=(x"7",x"6",x"5",x"3",x"1",x"F",x"D",x"A");
    
    -- inicio de la arquitectura
    Begin
        outA <= ROM(conv_integer(addA));
end Behavioral;