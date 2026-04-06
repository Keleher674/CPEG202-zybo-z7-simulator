library ieee;
use ieee.std_logic_1164.all;

entity basic_mapping_tb is
-- A testbench has no ports because it is the absolute top of the hierarchy.
end entity;

architecture behavior of basic_mapping_tb is

    -- 1. Declare the component we want to test
    component top_level is
        port (
            btn0 : in std_logic;
            btn1 : in std_logic;
            btn2 : in std_logic;
            btn3 : in std_logic;
            
            led0 : out std_logic;
            led1 : out std_logic;
            led2 : out std_logic;
            led3 : out std_logic
        );
    end component;

    -- 2. Declare internal signals to drive the inputs and read the outputs
    signal btn0_tb : std_logic := '0';
    signal btn1_tb : std_logic := '0';
    signal btn2_tb : std_logic := '0';
    signal btn3_tb : std_logic := '0';
    
    signal led0_tb : std_logic;
    signal led1_tb : std_logic;
    signal led2_tb : std_logic;
    signal led3_tb : std_logic;

begin

    -- 3. Instantiate the Unit Under Test (UUT)
    UUT: top_level port map (
        btn0 => btn0_tb,
        btn1 => btn1_tb,
        btn2 => btn2_tb,
        btn3 => btn3_tb,
        led0 => led0_tb,
        led1 => led1_tb,
        led2 => led2_tb,
        led3 => led3_tb
    );

    -- 4. Stimulus Process (No clock needed for combinational logic)
    stim_proc: process
    begin
        -- Initial State: All buttons off
        wait for 20 ns;
        
        -- Test Case 1: Press Button 0
        btn0_tb <= '1';
        wait for 20 ns;
        btn0_tb <= '0';
        
        -- Test Case 2: Press Button 1
        btn1_tb <= '1';
        wait for 20 ns;
        
        -- Test Case 3: Press Button 2 while Button 1 is still held
        btn2_tb <= '1';
        wait for 20 ns;
        
        -- Test Case 4: Release all, then press Button 3
        btn1_tb <= '0';
        btn2_tb <= '0';
        btn3_tb <= '1';
        wait for 20 ns;
        
        -- Turn the button OFF to create a final falling edge event
        btn3_tb <= '0';
        
        -- Add a buffer so the final state is clearly visible in GTKWave
        wait for 50 ns;
        
        -- End the simulation cleanly to generate the VCD file
        assert false report "Simulation Finished Successfully." severity failure;
    end process;

end architecture;