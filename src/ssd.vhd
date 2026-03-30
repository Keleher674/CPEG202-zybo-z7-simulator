----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2023 12:11:55 PM
-- Design Name: 
-- Module Name: KeleherChristian_ssd - Behavioral
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

entity KeleherChristian_ssd is
    Port ( sw : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(0 to 6) ;
           cat : out STD_LOGIC);
end KeleherChristian_ssd;

architecture Behavioral of KeleherChristian_ssd is

begin

cat <= '0';
with sw select seg <=
"1111110" when "0000", --0
"0110000" when "0001", --1
"1101101" when "0010", --2
"1111001" when "0011", --3
"0110011" when "0100", --4
"1011011" when "0101", --5
"1011111" when "0110", --6
"1110000" when "0111", --7
"1111111" when "1000", --8
"1111011" when "1001", --9
"1100111" when "1010", --p
--"1110111" when "1010", --A or 10
--"0011111" when "1011", --b or 11
--"1001110" when "1100", --C or 12
--"0111101" when "1101", --d or 13
--"1001111" when "1110", --E or 14
--"1000111" when "1111", --F or 15
"0000000" when others;

end Behavioral;
