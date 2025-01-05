library ieee;
use ieee.std_logic_1164.all;

entity Mux16_1 is
port (
    E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15: std_logic;
    sel: in std_logic_vector(3 downto 0);
    output: out std_logic
);
end Mux16_1;


architecture arch_mux of Mux16_1 is begin
    with sel select output <=   E0 when "0000",
                                E1 when "0001",
                                E2 when "0010",
                                E3 when "0011",
                                E4 when "0100",
                                E5 when "0101",
                                E6 when "0110",
                                E7 when "0111",
                                E8 when "1000",
                                E9 when "1001",
                                E10 when "1010",
                                E11 when "1011",
                                E12 when "1100",
                                E13 when "1101",
                                E14 when "1110",
                                E15 when others;
end arch_mux;