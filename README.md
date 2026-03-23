# Zybo Z7 Virtual FPGA Board Simulator

This project is a virtual hardware simulator for the Digilent Zybo Z7-10 FPGA board. It allows you to write, compile, and visually test your VHDL designs using a Python/Pygame frontend powered by Cocotb and GHDL. This fully replaces the need for physical hardware during the development and verification phases.

## Project Structure

* `src/`: **All of your VHDL code goes here.** The simulator will *only* read files placed inside this directory. You can have as many `.vhd` files as you need.
* `run_sim.py`: The executable script that builds and runs the simulation.
* `board_sim.py`: The backend Python code that handles the Pygame GUI and port mapping. You do not need to edit this file.
* `board_bg.png`: The graphical overlay for the Pygame window.
* `.gitignore`: Prevents temporary cache files from being uploaded to version control.

## Structural VHDL & Component Naming

In VHDL, **file names do not strictly matter**. The compiler cares about the `entity` names declared inside the text of the files. As long as all your `.vhd` files are inside the `src/` folder, the GHDL compiler will read them all in bulk, figure out the structural hierarchy, and link your instantiated components together. 

However, any `component` you instantiate in your code **must** correspond to an actual `entity` defined in one of the `.vhd` files inside the `src/` folder. The simulator will not look for or read any files outside of this specific directory.

### ⚠️ The Top-Level Entity Rule
While your sub-components can be named whatever you like, **your absolute top-level entity must be named exactly `top_level`.** If you use a different name, the simulation runner will not be able to find it and the build will fail.

```vhdl
entity top_level is
    port (
        -- Your port mappings go here
    );
end entity;
```

## Hardware Port Mappings

The simulator dynamically reads your VHDL ports based on their names. You can write your ports as **single scalar bits** (e.g., `sw0`) or as **logic vectors** (e.g., `sw(7 downto 0)`). 

If you use vectors, the simulator natively respects standard VHDL binary weighting. Using `downto` vs. `to` will map to the physical hardware exactly as it would on the real FPGA.

| Component | Scalar Name (1-bit) | Vector Name | Description |
| :--- | :--- | :--- | :--- |
| **Clock** | `clk` | N/A | 125 MHz system clock. Automatically generated if included in your entity. |
| **Switches** | `sw0` to `sw7` | `sw` | Slide switches. `sw0`-`sw3` are onboard, `sw4`-`sw7` are Pmod inputs. |
| **Buttons** | `btn0` to `btn3` | `btn` | Momentary push buttons. |
| **Green LEDs** | `led0` to `led3` | `led` | LEDs located directly above the buttons. |
| **Red LEDs** | `led4` to `led7` | `led` | LEDs located near the Pmod switches. |
| **7-Segment** | `seg0` to `seg7` | `seg` | Individual segments of the display. `seg7` is the decimal point. |
| **Digit Select** | `cat` | N/A | Multiplexer bit. `0` activates Left digit, `1` activates Right digit. |


*Note: If a component is not declared in your VHDL entity, the simulator simply ignores it. You only need to declare the ports you are actively using for a given lab.*

## Timing, Clocks, and Simulation Scaling

The Zybo Z7 board features a **125 MHz** reference clock. 
* **125 MHz** means the clock pulses exactly 125,000,000 times per second.
* To create a **1-second delay** or a 1 Hz pulse in hardware, your VHDL counter must count up to **125,000,000** before triggering an action and resetting.

### The Simulation Trap
While 125 million counts takes exactly 1 second on physical silicon, the software simulator has to perform complex calculations for every single one of those clock edges. Simulating a full second of hardware time will take several minutes of real-world time on your computer.

**You must use VHDL Generics to scale your timers for simulation.** When testing your code in the simulator, scale your maximum count down significantly (e.g., to `50000`) so you can verify your logic works without waiting hours. When you are ready to push the code to the physical board, change the generic back to `125000000`.

```vhdl
entity top_level is
    generic (
        -- Use 125,000,000 for hardware, but lower it (e.g., 50000) for the simulator
        MAX_COUNT : integer := 125000000 
    );
    port (
        clk : in std_logic;
        led0 : out std_logic
    );
end entity;
```

### Persistence of Vision & Multiplexing
If you are building a multiplexer for the 7-segment display, be aware of a limitation in software simulation. On real hardware, switching the `cat` bit faster than 60Hz creates an optical illusion (persistence of vision) making both digits appear solid simultaneously. 

The Pygame simulator draws at a discrete 60 frames per second. It does not have human retinas and cannot blur high-speed switching together. If you simulate a >60Hz multiplexer, the display will look like it is randomly flickering or broken. 

**Test Strategy:** Test your multiplexer logic at a highly scaled-down speed in the simulator (e.g., flipping `cat` every 0.5 seconds). You will clearly see the display alternate: Left... Right... Left... Right. Once visually verified, change the timer generic to the >60Hz value and push it to the real FPGA.