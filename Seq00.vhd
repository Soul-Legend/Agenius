library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Seq00 is
port (
    address: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end Seq00;


architecture arch_seq00 of Seq00 is
begin
    output <=   "0001" when address = "0000" else
                "0010" when address = "0001" else
                "1000" when address = "0010" else
                "0100" when address = "0011" else
                "0010" when address = "0100" else
                "0100" when address = "0101" else
                "1000" when address = "0110" else
                "0001" when address = "0111" else
                "1000" when address = "1000" else
                "0100" when address = "1001" else
                "0001" when address = "1010" else
                "0100" when address = "1011" else
                "0010" when address = "1100" else
                "0001" when address = "1101" else
                "0100" when address = "1110" else
                "0010" when address = "1111";
end arch_seq00;