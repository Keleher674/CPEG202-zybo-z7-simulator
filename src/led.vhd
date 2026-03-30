----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 10:49:40 AM
-- Design Name: 
-- Module Name: KeleherChristian_LEDs - Behavioral
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

entity KeleherChristian_LEDs is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0));
end KeleherChristian_LEDs;

architecture Behavioral of KeleherChristian_LEDs is
begin
    With input select led <=
    "00000001" when "0000",
    "00000010" when "0001",
    "00000100" when "0010",
    "00001000" when "0011",
    "00010000" when "0100",
    "00100000" when "0101",
    "01000000" when "0110",
    "10000000" when "0111",
    "00001111" when "1110",
    "11110000" when "1101",
    "00000000" when "1111",
    "00000000" when others;
end Behavioral;


