----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 08:04:07 PM
-- Design Name: 
-- Module Name: KeleherChristian_ScoreCounter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KeleherChristian_ScoreCounter is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           state : in std_logic_vector (3 downto 0) := "0000";
           score1 : out STD_LOGIC_vector (3 downto 0) := "0000";
           score2 : out STD_LOGIC_vector (3 downto 0) := "0000";
           win_con : out std_logic_vector (1 downto 0) := "00");
end KeleherChristian_ScoreCounter;

architecture Behavioral of KeleherChristian_ScoreCounter is

signal p1score : std_logic_vector (3 downto 0);
signal p2score : std_logic_vector (3 downto 0);

begin
count: process (clk,btn0,state)
    begin
        if(btn0 = '1') then
            win_con <= "00";
            p1score <= "0000";
            p2score <= "0000";
        elsif(rising_edge(clk)) then
                if(state = "0101") then
                    p1score <= std_logic_vector(UNSIGNED(p1score) + 1);
                    if (p1score = "1001") then
                        win_con <= "10";
                    end if;
                elsif (state = "0110" ) then 
                    p2score <= std_logic_vector(UNSIGNED(p2score) + 1);
                    if (p2score = "1001") then
                        win_con <= "01";
                    end if;
                elsif (state = "0111" or state = "1000") then --player 1 win
                    p1score <= "1010";
                    p2score <= "0001";
                elsif (state = "1001" or state = "1010") then --player 2 win
                    p1score <= "1010";
                    p2score <= "0010";
                end if;
        end if;
    end process;

score1 <= p1score;
score2 <= p2score;

end Behavioral;

