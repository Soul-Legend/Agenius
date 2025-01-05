library ieee;
use ieee.std_logic_1164.all;

entity Register8 is port (
    clock, reset, enable: in std_logic;
    D: in std_logic_vector(7 downto 0);
    Q: out std_logic_vector(7 downto 0)
);
end Register8;


architecture arch_reg8 of Register8 is
begin
    process (clock, enable, reset, D)
    begin
        if reset = '1' then
            Q <= "00000000";
        elsif clock'event and clock = '1' then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end arch_reg8;