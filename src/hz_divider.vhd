----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 11:24:02 AM
-- Design Name: 
-- Module Name: KeleherChristian_1hz_2hz_clock_divider - Behavioral
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

entity KeleherChristian_1hz_2hz_clock_divider is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           Y : out STD_LOGIC);
end KeleherChristian_1hz_2hz_clock_divider;

architecture Structural of KeleherChristian_1hz_2hz_clock_divider is

component KeleherChristian_2hz_clock is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

component KeleherChristian_1hz_clock is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

component KeleherChristian_1hz_2hz_mux is
    Port ( I : in std_logic_vector(1 downto 0);
           sw0 : in STD_LOGIC;
           Y : out STD_LOGIC);
end component;

signal onehz_out : std_logic;
signal twohz_out : std_logic;

begin
--1hz 
one_hz: KeleherChristian_1hz_clock port map(
    clk => clk,
    btn0 => btn0,
    clk_out => onehz_out);
    
--2hz 
two_hz: KeleherChristian_2hz_clock port map(
    clk => clk,
    btn0 => btn0,
    clk_out => twohz_out);
    
--mux 
mux: KeleherChristian_1hz_2hz_mux port map(
    I(0) => onehz_out,
    I(1) => twohz_out,
    sw0 => sw0,
    Y => Y);
    
end Structural;
