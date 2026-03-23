library ieee;
use ieee.std_logic_1164.all;

-- This MUST match the top_level_entity in run_sim.py
entity switch_led is
    port (
        clk : in  std_logic;
        sw  : in  std_logic_vector(7 downto 0);
        btn : in  std_logic_vector(3 downto 0);
        led : out std_logic_vector(7 downto 0);
        seg : out std_logic_vector(7 downto 0);
        cat : out std_logic
    );
end entity;

architecture structural of switch_led is

    -- 1. Declare the component we want to use
    component my_blinker is
        port (
            clk_in  : in  std_logic;
            led_out : out std_logic
        );
    end component;

begin

    -- 2. Instantiate and wire the component
    U1: my_blinker port map (
        clk_in  => clk,
        led_out => led(0)
    );

    -- 3. Wire up the rest of the board directly
    led(3 downto 1) <= btn(3 downto 1);
    led(7 downto 4) <= sw(7 downto 4);
    seg <= sw;
    cat <= btn(3);

end architecture;