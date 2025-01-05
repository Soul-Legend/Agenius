library ieee;
use ieee.std_logic_1164.all;

entity Mux4_1_4 is
port (
    W, X, Y, Z: in std_logic_vector(3 downto 0);
    sel: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end Mux4_1_4;


architecture arch_mux of Mux4_1_4 is
begin
    with sel select output <=   W when "00",
                                X when "01",
                                Y when "10",
                                Z when others;
end arch_mux;