# Zybo Z7 Virtual FPGA Simulator

This is a local, software-based simulator for the Digilent Zybo Z7-10 FPGA board. It allows you to write, compile, and visually test VHDL designs using a Python/Pygame interface without needing physical hardware.

## Prerequisites

To run this on your local machine (Windows, macOS, or Linux), you must have the following installed:
1. **Python 3** and **pip**
2. **GHDL** (The VHDL compiler)
3. Python packages: Run `pip install cocotb pygame cocotb-tools` in your terminal.

*(Note for Windows users: It is highly recommended to run this inside WSL (Windows Subsystem for Linux) for compatibility with GHDL).*

## How to Run

1. Download or clone this entire repository to your computer.
2. Place all of your `.vhd` files inside the `src/` folder.
3. Open your terminal, navigate to the main project folder (where `run_sim.py` is located), and run:
   ```bash
   python3 run_sim.py
   ```

## VHDL Structure & Naming Rules

* **File Names:** You can name your `.vhd` files whatever you want. The compiler reads everything inside the `src/` folder and links it automatically.
* **Top-Level Entity:** Your absolute top-level entity **must be named exactly `top_level`**. If it is named anything else, the simulation will fail to build.

```vhdl
entity top_level is
    port (
        -- Your port mappings go here
    );
end entity;
```

## Hardware Port Mappings

The simulator reads your VHDL ports based on their names. You can write them as **single bits** (e.g., `sw0`) or as **vectors** (e.g., `sw(7 downto 0)`). 

| Component | Scalar Name (1-bit) | Vector Name | Description |
| :--- | :--- | :--- | :--- |
| **Clock** | `clk` | N/A | 125 MHz system clock. |
| **Switches** | `sw0` to `sw7` | `sw` | Slide switches. |
| **Buttons** | `btn0` to `btn3` | `btn` | Momentary push buttons. |
| **Green LEDs** | `led0` to `led3` | `led` | LEDs near onboard switches. |
| **Red LEDs** | `led4` to `led7` | `led` | LEDs to the right of the SSD. |
| **7-Segment** | `seg0` to `seg7` | `seg` | Individual segments (`seg7` is the decimal point). |
| **Digit Select** | `cat` | N/A | Multiplexer bit. `0` = Left digit, `1` = Right digit. |


*Note: Only declare the ports you are actively using. The simulator will ignore the rest.*

## Simulation Quirks & Timing

### 1. Generating a 1 Hz Clock (1-Second Timer)
The simulator provides a 125 MHz clock (`clk`), just like the real board. However, simulating 125,000,000 clock cycles takes your computer a massive amount of processing time. 

If you try to count to 125,000,000 in your VHDL, the simulation will appear frozen because it takes minutes of real-world time to process one simulated second. 

**To create a 1 Hz (1-second) pulse in this simulator, your counter should only count to `50000`.** This scales the math down so the visualizer updates in real-time on your screen. 

### 2. 7-Segment Multiplexing (Flickering)
When building a multiplexer for the 7-segment display, do not try to switch the digits back and forth at 60 Hz. The Pygame window updates at 60 frames per second and cannot blur high-speed switching together like a human eye does (persistence of vision). 

If you switch digits too fast, the display will look broken or flicker randomly. Instead, test your multiplexer by switching the `cat` bit slowly (e.g., every 0.5 seconds) so you can visually verify that the correct numbers are being routed to the Left and Right digits.