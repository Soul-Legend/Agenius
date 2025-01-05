library ieee;
use ieee.std_logic_1164.all;

entity Mux2_1 is
port (
    A, B: in std_logic_vector(6 downto 0);
    sel: in std_logic;
    output: out std_logic_vector(6 downto 0)
);
end Mux2_1;


architecture arch_mux of Mux2_1 is begin
    with sel select output <= A when '0', B when others;
end arch_mux;