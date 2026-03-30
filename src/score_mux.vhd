----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 11:38:30 AM
-- Design Name: 
-- Module Name: KeleherChristian_2to1mux_PONG - Behavioral
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

entity KeleherChristian_2to1mux_PONG is
    Port ( I1 : in STD_LOGIC_VECTOR (3 downto 0);
           I0 : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           Y : out std_logic_vector (3 downto 0));
end KeleherChristian_2to1mux_PONG;

architecture Behavioral of KeleherChristian_2to1mux_PONG is

begin
    with sel select
    Y <= I0 when '1',
         I1 when '0',
         "0000" when others;
end Behavioral;
