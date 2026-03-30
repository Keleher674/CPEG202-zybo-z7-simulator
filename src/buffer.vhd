----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 07:38:40 PM
-- Design Name: 
-- Module Name: KeleherChristian_buffer - Behavioral
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

entity KeleherChristian_buffer is
    Port ( btn1 : in STD_LOGIC;
           btn2 : in STD_LOGIC;
           clk : in STD_LOGIC;
           game_clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           p1buff : out STD_LOGIC;
           p2buff : out STD_LOGIC;
           resetout : out STD_LOGIC);
end KeleherChristian_buffer;

architecture Behavioral of KeleherChristian_buffer is

signal game_clk_d:std_logic;

begin

    process(clk,btn1,btn2,game_clk,btn0)
    begin
    if(rising_edge(clk))then
        game_clk_d<=game_clk;
        if((game_clk_d/=game_clk)and game_clk='1') then
            P1buff<='0';
            P2buff<='0';
            resetout<='0';
        elsif(btn1='1')then
            P1buff<='1';
        elsif(btn2='1')then
            P2buff<='1';
        elsif(btn0='1')then
            resetout<='1';
        end if;
    end if;
end process;
end Behavioral;
