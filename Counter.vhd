library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter is
port (
    data: in std_logic_vector(3 downto 0);
    clock, reset, enable: in std_logic;
    tc: out std_logic;
    contagem: out std_logic_vector(3 downto 0)
);
end Counter;


architecture arch_cnt of Counter is
    signal cnt: std_logic_vector (3 downto 0) := "0000";

begin
    process (clock, reset, enable, cnt)
    begin
        if reset = '1' then
            cnt <= "0000";
            tc <= '0';
        elsif clock'event and clock = '1' then
            if enable = '1' then
                cnt <= cnt + 1;
                if cnt = data then
                    tc <= '1';
                else
                    tc <= '0';
                end if;
            end if;
        end if;
    end process;

    contagem <= cnt;
end arch_cnt;