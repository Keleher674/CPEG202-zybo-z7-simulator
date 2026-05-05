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

```bash
code .
```

**3. Install Dependencies**
In VSCode, open the integrated terminal (`Terminal` -> `New Terminal`). Verify the terminal prompt shows a Linux bash environment, not Windows PowerShell. Run the following commands to install the required compiler and Python libraries:

```bash
# Update package lists and install the GHDL compiler and Python
sudo apt update
sudo apt install ghdl python3 python3-pip gtkwave -y

# Install the required Python simulation libraries
pip3 install cocotb pygame
```

_(Note: Depending on your Ubuntu version, if pip restricts global installs, you may need to append `--break-system-packages` to the pip command, or set up a python virtual environment)._

**4. Run the Basic Simulation**
To verify your environment is set up correctly, ensure your VHDL files are located inside the `src/` folder, then run the executable script:

```bash
python3 run.py
```

If successful, the graphical Zybo board interface will launch, allowing you to interact with the switches and buttons to test the default mapping.

## VHDL Structure & Naming Rules

- **File Names:** You can name your `.vhd` files whatever you want. The compiler reads everything inside the `src/` folder and links it automatically.
- **Top-Level Entity:** Your absolute top-level entity **must be named exactly `top_level`**. If it is named anything else, the simulation will fail to build _(by default)_.

```vhdl
entity top_level is
    port (
        -- Your port mappings go here
    );
end entity;
```

## Hardware Port Mappings

The simulator reads your VHDL ports based on their names. You can write them as **single bits** (e.g., `sw0`) or as **vectors** (e.g., `sw(7 downto 0)`).

| Component        | Scalar Name (1-bit) | Vector Name | Description                                           |
| :--------------- | :------------------ | :---------- | :---------------------------------------------------- |
| **Clock**        | `clk`               | N/A         | 125 MHz system clock.                                 |
| **Switches**     | `sw0` to `sw7`      | `sw`        | Slide switches.                                       |
| **Buttons**      | `btn0` to `btn3`    | `btn`       | Momentary push buttons.                               |
| **Green LEDs**   | `led0` to `led3`    | `led`       | LEDs near onboard switches.                           |
| **Red LEDs**     | `led4` to `led7`    | `led`       | LEDs to the right of the SSD.                         |
| **7-Segment**    | `seg0` to `seg7`    | `seg`       | Individual segments (`seg7` is the decimal point).    |
| **Digit Select** | `cat`               | N/A         | Multiplexer bit. `0` = Left digit, `1` = Right digit. |

_Note: Only declare the ports you are actively using. The simulator will ignore the rest._

## Simulation Quirks & Hardware Realism

### 1. Generating a 1 Hz Clock (1-Second Timer)

The simulator provides a 125 MHz clock (`clk`), exactly like the physical Zybo board. However, simulating 125,000,000 clock cycles takes massive computational power. If your VHDL tries to count to 125 million, the simulation will appear frozen because it takes minutes of real-world time to process one simulated second.

**The Fix:** Use VHDL `generic` parameters for your counters. To create a 1 Hz (1-second) pulse in the simulator, scale your maximum count down to `50000`. This allows the visualizer to update in real-time. When you are ready to push your code to the real FPGA, simply change that generic back to `125000000`.

### 2. 7-Segment Multiplexing (Persistence of Vision)

On real hardware, multiplexing (switching between the left and right digits) faster than 60Hz creates an optical illusion that makes both digits appear solid simultaneously. **This simulator natively replicates that illusion.**

- **Slow Switching (Debugging):** If your VHDL switches the `cat` bit slowly (e.g., every 0.5 seconds), the Pygame window will show only one digit at a time. This is highly recommended for initially verifying your routing logic!
- **Fast Switching (Hardware Speed):** Once you know your logic works, increase your multiplexer speed. If the Python backend detects the `cat` bit flipping faster than ~20Hz in real-world time, it will automatically engage "POV Mode" and render both digits simultaneously, perfectly mimicking the physical board.

### 3. Segment Mapping (`to` vs `downto`)

The simulator enforces strict hardware pin mapping for the 7-segment display.

- Index `0` is physically wired to Segment A (Top).
- Index `6` is physically wired to Segment G (Middle).

If you declare your output vector as `seg : out std_logic_vector(0 to 6)`, assigning `"1111110"` will map the leftmost '1' to index `0` (Top), resulting in a perfect '0' on the display.

**Warning:** If you declare your vector as `6 downto 0`, the leftmost bit of `"1111110"` now corresponds to index `6` (Middle). This will draw your numbers completely inside out and backwards! Pay close attention to your vector direction, as the simulator will mangle your display exactly the same way the physical FPGA would.

## Running Testbenches & Viewing Waveforms

If you are writing a standard VHDL testbench (a file that generates its own simulated inputs without the Pygame GUI), you can compile it and view the timing waveforms using GTKWave.

1. Ensure your testbench file is in the `src/` folder and ends with `_tb.vhd` (e.g., `counter_tb.vhd`).
   - **Crucial Rule:** The entity name _inside_ your testbench file must exactly match the filename. If your file is `counter_tb.vhd`, your code must declare `entity counter_tb is`.
2. Open your terminal in the main project folder and run:

   ```bash
   python3 run.py -tb
   ```

3. Type the number corresponding to the testbench you want to run and press Enter.
4. The script will compile your code and generate a `waveforms.vcd` file.
5. To view the results, the simulator automatically opens the industry-standard GTKWave viewer by running:

   ```bash
   gtkwave waveforms.vcd &
   ```

**Using GTKWave:**
When GTKWave opens, your signals will not be visible immediately.

1. In the top-left **SST** window, click on your testbench name (e.g., `top_level_tb`).
2. In the bottom-left window, highlight the signals you want to see.
3. Click the **Append** button at the bottom to add them to the main waveform viewer.
4. Use the magnifying glass icons at the top to zoom in and out of your time scale.

<details>
<summary><h2>Advanced Features</h2> (Click to expand)</summary>

## Command Line Arguements

You can customize the simulation run using various command-line flags.

**Basic Usage:**

```bash
python3 run.py [arguments]
```

**Available Arguments:**

| Short | Long Flag       | Default         | Description                                                        |
| :---: | :-------------- | :-------------- | :----------------------------------------------------------------- |
| `-p`  | `--path`        | `src`           | Path to a specific directory containing `.vhd` files.              |
| `-e`  | `--entity`      | `top_level`     | Name of the top-level entity to simulate. (not for testbench)      |
| `-tb` | `--test-bench`  | `false`         | Run the testbench instead of the normal simulation.                |
| `-ns` | `--no-sim`      | `false`         | Compile testbench and generate VCD file, do not run the simulation |
| `-o`  | `--output-dir`  | `waveforms`     | Directory to store .vcd waveform files.                            |
| `-f`  | `--output-file` | `waveforms.vcd` | Name of the top-level entity to simulate.                          |
| `-h`  | `--help`        | `N/A`           | Shows the help menu and exits.                                     |

**Examples:**

Run the simulation on the default directory:

```bash
python3 run.py
```

Target a specific test directory:

```bash
python3 run.py --path="src1"
```

Use a differently named top-level entity:

```bash
python3 run.py -e 'top_level2'
```

</details>
```
