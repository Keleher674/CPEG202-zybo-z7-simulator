# Zybo Z7 Virtual FPGA Board Simulator

This project is a virtual hardware simulator for the Digilent Zybo Z7-10 FPGA board. It allows you to write, compile, and visually test your VHDL designs using a Python/Pygame frontend powered by Cocotb and GHDL, entirely replacing the need for physical hardware during the development phase.

## Project Structure and Structural VHDL

* `src/`: **All of your VHDL code goes here.** You can have as many `.vhd` files as you want. 
* `run_sim.py`: The executable script that builds and runs the simulation.
* `board_sim.py`: The backend Python code that handles the Pygame GUI and port mapping. You do not need to edit this file.
* `board_bg.png`: The graphical overlay for the Pygame window.
* `.gitignore`: Prevents temporary cache files from being uploaded to version control.

### File Naming vs. Entity Naming
In VHDL, **file names do not matter**. The compiler only cares about the `entity` name declared inside the text of the file. As long as all your `.vhd` files are inside the `src/` folder, the GHDL compiler will automatically read them all, figure out the structural hierarchy, and link your instantiated components together. 

### ⚠️ The Top-Level Entity Rule
While you can name your `.vhd` files and sub-components whatever you like, **your absolute top-level entity must be named exactly `main`.** If you use a different name for your top-level entity, the simulation runner will not be able to find it and the build will fail.

```vhdl
entity main is
    port (
        -- Your port mappings go here
    );
end entity;