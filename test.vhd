library ieee;
use ieee.std_logic_1164.all;

entity usertest is
end usertest;

architecture tb of usertest is

    -- Signal declarations:
    signal A,B : std_logic;
    signal C: std_logic_vector(2 downto 0);
    
    -- Component declarations:
    component mycomponent is port ( 
      PortA,PortB: in std_logic;
      PortC: out std_logic_vector(2 downto 0) );
    end component;

begin

    -- Component instantiation and port map:
    DUT : mycomponent port map (PortA => A, PortB => B, PortC => C);
    
    -- Stimuli:
    A <= '0', '1' after 20 ns, '0' after 40 ns;
    B <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns;
    
end tb;