----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 11:45:47 AM
-- Design Name: 
-- Module Name: KeleherChristian_PONG_statemachine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KeleherChristian_PONG_statemachine is
    Port ( clk, btn0, btn1, btn2 : in STD_LOGIC;
           win_con : in std_logic_vector (1 downto 0);
           led_array : out STD_LOGIC_vector(3 downto 0) ;
           state : out STD_LOGIC_vector(3 downto 0));
end KeleherChristian_PONG_statemachine;

architecture Behavioral of KeleherChristian_PONG_statemachine is

signal current_state, next_state: std_logic_vector(3 downto 0);
signal current_led, next_led: std_logic_vector(3 downto 0);

begin
state <= current_state;
led_array <= current_led;
state_machine: process(clk,btn0)
begin
if (rising_edge(clk)) then
    if (btn0='1') then 
        current_state<="0000";
        current_led<="0000";
    else
        current_state <= next_state;
        current_led <= next_led;
    end if;
end if;
end process;

outputs: process(current_state, current_led)
begin
if (win_con = "00") then    
    if (current_state = "0000") then --initial state. Leftmost LED is on
        next_state <= "0001";
        next_led <= "0000";

    elsif (current_state = "0001") then --LEDs scroll from left to right
        if (current_led = "0110") then
            next_state <= "0010";
            next_led <= "0111";
        else
            next_state <= "0001";
            next_led <= std_logic_vector(unsigned(current_led) + 1);
        end if;

    elsif (current_state = "0010") then
        if (btn2 = '1') then
            next_led <= "0110";
            next_state <= "0011";
        else
            next_state <= "0101";
            next_led <= "0000";
        end if;

    elsif (current_state = "0011") then
        if (current_led = "0001") then
            next_state <= "0100";
            next_led <= "0000";
        else
            next_state <= "0011";
            next_led <= std_logic_vector(unsigned(current_led) - 1);
        end if;

    elsif (current_state = "0100") then
        if (btn1 = '1') then
            next_led <= "0001";
            next_state <= "0001";
        else
            next_state <= "0110";
            next_led <= "0111";
        end if;
        
    elsif (current_state="0101") then
        next_state<="0001";
        next_led<="0000";
    
    elsif (current_state="0110") then
        next_state<="0011";
        next_led<="0111";

    else
        next_state <= current_state;
        next_led <= current_led;

    end if;
elsif (win_con = "10") then
    next_state <= "0111";
    next_led <= "1110";
    
    if (current_state = "0111") then --led on, set off
        next_state <= "1000";
        next_led <= "1111";

    elsif (current_state = "1000") then --led off, set on
        next_state <= "0111";
        next_led <= "1110";
    end if;
   
elsif (win_con = "01") then
    next_state <= "1001";
    next_led <= "1101";
    
    if (current_state = "1001") then --led on, set off
        next_state <= "1010";
        next_led <= "1111";

    elsif (current_state = "1010") then --led off, set on
        next_state <= "1001";
        next_led <= "1101";
    end if;
end if;
end process;

end Behavioral;