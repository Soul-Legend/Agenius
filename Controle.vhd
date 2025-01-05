library ieee;
use ieee.std_logic_1164.all;

entity Controle is
port (
    -- Entradas de controle.
    clock: in std_logic;
    enter: in std_logic;
    reset: in std_logic;

    -- Entradas de status.
    end_fpga, end_user, end_time, win, match: in std_logic;

    -- Saídas de comandos.
    R1, R2, E1, E2, E3, E4: out std_logic;
    

    debug: out std_logic_vector(2 downto 0);
    -- Saída de controle.
    sel: out std_logic
);
end Controle;

architecture arch_ctrl of Controle is
    type states is (start, setup, play_fpga, play_user, check, next_round, result);
    signal EA, PE: states;
begin
    process (clock, reset)
    begin
        if reset = '1' then
            EA <= start;
        elsif clock'event and clock = '1' then
            EA <= PE;
        end if;
    end process;

    process (EA, enter, end_fpga, end_user, end_time, win, match)
    begin
        case EA is
        when start =>
            debug <= "000";

            R1 <= '1';
            R2 <= '1';

            sel <= '0';

            E1 <= '0';
            E2 <= '0';
            E3 <= '0';
            E4 <= '0';

            PE <= setup;
        when setup =>
            debug <= "001";

            R1 <= '0';
            R2 <= '0';

            sel <= '0';

            E1 <= '1';
            E2 <= '0';
            E3 <= '0';
            E4 <= '0';

            if enter = '1' then
                PE <= play_fpga;
            else
                PE <= setup;
            end if;
        when play_fpga =>
            debug <= "010";

            R1 <= '0';
            R2 <= '0';

            sel <= '0';

            E1 <= '0';
            E2 <= '0';
            E3 <= '1';
            E4 <= '0';

            if end_fpga = '1' then
                PE <= play_user;
            else
                PE <= play_fpga;
            end if;
        when play_user =>
            debug <= "011";

            R1 <= '0';
            R2 <= '0';

            sel <= '0';

            E1 <= '0';
            E2 <= '1';
            E3 <= '0';
            E4 <= '0';

            if end_time = '1' then
                PE <= result;
            else
                if end_user = '1' then
                    PE <= check;
                else
                    PE <= play_user;
                end if;
            end if;
        when check =>
            debug <= "100";

            R1 <= '0';
            R2 <= '0';

            sel <= '0';

            E1 <= '0';
            E2 <= '0';
            E3 <= '0';
            E4 <= '1';

            if match = '1' then
                PE <= next_round;
            else
                PE <= result;
            end if;
        when next_round =>
            debug <= "101";

            R1 <= '0';
            R2 <= '1';

            sel <= '0';

            E1 <= '0';
            E2 <= '0';
            E3 <= '0';
            E4 <= '0';

            if win = '1' then
                PE <= result;
            else
                PE <= play_fpga;
            end if;
        when result =>
            debug <= "110";

            R1 <= '0';
            R2 <= '0';

            sel <= '1';

            E1 <= '0';
            E2 <= '0';
            E3 <= '0';
            E4 <= '0';

            PE <= result;
        end case;
    end process;
end arch_ctrl;