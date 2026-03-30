# Zybo Z7 Virtual FPGA Simulator

This is a local, software-based simulator for the Digilent Zybo Z7-10 FPGA board. It allows you to write, compile, and visually test VHDL designs using a Python/Pygame interface, completely replacing the need for physical hardware during the verification phase.

## Windows + VSCode Setup (WSL)

Because the VHDL compiler (GHDL) and the Python testbench framework (Cocotb) operate best in a Linux environment, Windows users must run this simulator using the Windows Subsystem for Linux (WSL). Windows 11 natively supports Linux GUI applications (WSLg), allowing the simulator's graphical window to open seamlessly on your desktop.

### Prerequisites
Before starting, ensure you have the following installed on your Windows machine:
1. **WSL (Ubuntu):** Open PowerShell as Administrator and run `wsl --install`. Restart your computer if prompted.
2. **Visual Studio Code (VSCode):** Installed normally on Windows.
3. **WSL Extension for VSCode:** Open VSCode, go to the Extensions tab, and install the official Microsoft "WSL" extension.

### Installation & Setup Steps

**1. Download the Repository**
Download the project files to your computer (either via `git clone` or by downloading and extracting the ZIP file). You need the entire folder structure, including `src/` and the Python scripts.

**2. Open the Project in WSL**
1. Open your **Ubuntu** terminal app from the Windows Start menu.
2. Navigate to the directory where you saved the simulator folder. (Note: Your Windows `C:` drive is located at `/mnt/c/` in WSL. For example: `cd /mnt/c/Users/YourName/Downloads/Zybo-Simulator`).
3. Once inside the project folder, type the following command to open the folder in VSCode bridged to your Linux environment:

~~~bash
code .
~~~

**3. Install Dependencies**
In VSCode, open the integrated terminal (`Terminal` -> `New Terminal`). Verify the terminal prompt shows a Linux bash environment, not Windows PowerShell. Run the following commands to install the required compiler and Python libraries:

~~~bash
# Update package lists and install the GHDL compiler and Python
sudo apt update
sudo apt install ghdl python3 python3-pip -y

# Install the required Python simulation libraries
pip3 install cocotb pygame cocotb-tools
~~~
*(Note: Depending on your Ubuntu version, if pip restricts global installs, you may need to append `--break-system-packages` to the pip command, or set up a python virtual environment).*

**4. Run the Basic Simulation**
To verify your environment is set up correctly, ensure your VHDL files are located inside the `src/` folder, then run the executable script:

~~~bash
python3 run_sim.py
~~~

If successful, the graphical Zybo board interface will launch, allowing you to interact with the switches and buttons to test the default mapping.

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