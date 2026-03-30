----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2023 11:36:47 AM
-- Design Name: 
-- Module Name: KeleherChristian_2hz_clock - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KeleherChristian_2hz_clock is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end KeleherChristian_2hz_clock;

architecture Behavioral of KeleherChristian_2hz_clock is
    signal temporal: STD_LOGIC;
    signal counter : integer range 0 to 25000 := 0;
begin
    frequency_divider: process (btn0, clk) begin
        if (btn0 = '1') then
            temporal <= '0';
            counter <= 0;
        elsif rising_edge(clk) then
            if (counter = 25000) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
end process;
    clk_out <= temporal;
end Behavioral;
