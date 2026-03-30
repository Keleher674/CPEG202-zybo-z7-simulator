----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 11:46:01 AM
-- Design Name: 
-- Module Name: KeleherChristian_PONG_main - Behavioral
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

entity top_level is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           btn1 : in STD_LOGIC;
           btn2 : in std_logic;
           led : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (0 to 6);
           cat : out STD_LOGIC);
end top_level;


architecture Structural of top_level is

component KeleherChristian_1hz_2hz_clock_divider is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           Y : out STD_LOGIC);
end component;

component KeleherChristian_60hz is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

component KeleherChristian_PONG_statemachine is
    Port ( clk, btn0, btn1, btn2 : in STD_LOGIC;
           win_con : in std_logic_vector(1 downto 0);
           led_array : out STD_LOGIC_vector(3 downto 0) ;
           state : out STD_LOGIC_vector(3 downto 0));
end component;

component KeleherChristian_2to1mux_PONG is
    Port ( I1 : in STD_LOGIC_VECTOR (3 downto 0);
           I0 : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           Y : out std_logic_vector (3 downto 0));
end component;

component KeleherChristian_ssd is
    Port ( sw : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0) ;
           cat : out STD_LOGIC);
end component;

component KeleherChristian_LEDs is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component KeleherChristian_ScoreCounter is
    Port ( clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           state : in std_logic_vector (3 downto 0) := "0000";
           score1 : out STD_LOGIC_vector (3 downto 0) := "0000";
           score2 : out STD_LOGIC_vector (3 downto 0) := "0000";
           win_con : out std_logic_vector (1 downto 0) := "00");
end component;

component KeleherChristian_buffer is
    Port ( btn1 : in STD_LOGIC;
           btn2 : in STD_LOGIC;
           clk : in STD_LOGIC;
           game_clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           p1buff : out STD_LOGIC;
           p2buff : out STD_LOGIC;
           resetout : out STD_LOGIC);
end component;

signal mux_out : std_logic; 
signal sixty_hz_out : std_logic;
signal led_array : std_logic_vector (3 downto 0);
signal state : std_logic_vector (3 downto 0);
signal score_out : std_logic_vector (3 downto 0) := "0000";
signal p1b : std_logic;
signal p2b: std_logic;
signal resetb : std_logic;
signal p1score : std_logic_vector (3 downto 0);
signal p2score : std_logic_vector (3 downto 0);
signal win_con : std_logic_vector (1 downto 0);

begin
-- divider for 1hz or 2hz 
hz_divider: KeleherChristian_1hz_2hz_clock_divider port map(
    clk => clk,
    btn0 => btn0,
    sw0 => sw0,
    Y => mux_out);

--60hz clock divider
sixty_hz: KeleherChristian_60hz port map(
    clk => clk,
    btn0 => btn0,
    clk_out => sixty_hz_out);

--buffer
buff: KeleherChristian_buffer port map(
    clk => clk,
    btn1 => btn1,
    btn2 => btn2,
    btn0 => btn0,
    game_clk => mux_out,
    p1buff => p1b,
    p2buff => p2b,
    resetout => resetb);
    
--state machine 
sm: KeleherChristian_PONG_statemachine port map (
    clk => mux_out,
    btn0 => resetb,
    btn1 => p1b,
    btn2 => p2b,
    led_array => led_array,
    state => state,
    win_con => win_con);
    
--score counter
score_counter: KeleherChristian_ScoreCounter port map(
    clk => mux_out,
    btn0 => btn0,
    state => state,
    score1 => p1score,
    score2 => p2score,
    win_con => win_con);
    
--2:1 mux 
score_mux: KeleherChristian_2to1mux_PONG port map(
    I0 => p2score,
    I1 => p1score,
    sel => sixty_hz_out,
    y => score_out);
    
--ssd 
ssd_final: KeleherChristian_ssd port map(
    sw => score_out,
    seg => seg);


--leds
led_final: KeleherChristian_LEDs port map(
    input => led_array,
    led => led); 

cat <= sixty_hz_out;

end Structural;

