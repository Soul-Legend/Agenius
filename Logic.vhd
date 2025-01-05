library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Logic is
port (
    setup_level, setup_seq: in std_logic_vector(1 downto 0);
    rodada: in std_logic_vector(3 downto 0);
    points: out std_logic_vector(7 downto 0)
);
end Logic;


architecture arch_logic of Logic is
begin
    points <= setup_level & rodada & setup_seq;
end arch_logic;