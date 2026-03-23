library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        -- Individual button inputs
        btn0 : in std_logic;
        btn1 : in std_logic;
        btn2 : in std_logic;
        btn3 : in std_logic;

        -- Individual LED outputs
        led0 : out std_logic;
        led1 : out std_logic;
        led2 : out std_logic;
        led3 : out std_logic
    );
end entity;

architecture behavior of top_level is
begin

    -- Directly map each button to its corresponding green LED
    led0 <= btn0;
    led1 <= btn1;
    led2 <= btn2;
    led3 <= btn3;

end architecture;