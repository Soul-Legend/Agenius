library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Comp is
port (
    out_fpga, out_user: in std_logic_vector(63 downto 0);
    eq: out std_logic
);
end Comp;


architecture arch_comp of Comp is
begin
    process (out_fpga, out_user)
    begin
        if out_fpga = out_user then
            eq <= '1';
        else
            eq <= '0';
        end if;
    end process;
end arch_comp;