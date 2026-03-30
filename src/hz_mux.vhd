----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2023 11:40:55 AM
-- Design Name: 
-- Module Name: KeleherChristian_2to1mux - Behavioral
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

entity KeleherChristian_1hz_2hz_mux is
    Port ( I : in std_logic_vector(1 downto 0);
           sw0 : in STD_LOGIC;
           Y : out STD_LOGIC);
end KeleherChristian_1hz_2hz_mux;

architecture Behavioral of KeleherChristian_1hz_2hz_mux is

begin
with sw0 select
    Y <= I(0) when '0',
         I(1) when '1',
         '0' when others;

end Behavioral;
