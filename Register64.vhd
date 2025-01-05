library ieee;
use ieee.std_logic_1164.all;

entity Register64 is port (
    clock, reset, enable: in std_logic;
    D: in std_logic_vector(63 downto 0);
    Q: out std_logic_vector(63 downto 0)
);
end Register64;


architecture arch_reg64 of Register64 is
begin
    process (clock, reset, enable, D)
    begin
        if reset = '1' then
            Q <= x"0000_0000_0000_0000";
        elsif clock'event and clock = '1' then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end arch_reg64;