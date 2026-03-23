library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The entity name is what matters, not the file name!
entity my_blinker is
    port (
        clk_in  : in  std_logic;
        led_out : out std_logic
    );
end entity;

architecture behavior of my_blinker is
    signal counter : unsigned(26 downto 0) := (others => '0');
    signal state   : std_logic := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if counter = 37500 then
                counter <= (others => '0');
                state <= not state;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    led_out <= state;
end architecture;