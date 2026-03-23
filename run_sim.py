import os
from pathlib import Path
from cocotb_tools.runner import get_runner

def main():
    sim = os.getenv("SIM", "ghdl")
    runner = get_runner(sim)
    
    # 1. Find all .vhd files in the 'src' directory
    src_dir = Path("src")
    sources = list(src_dir.glob("*.vhd"))
    
    if not sources:
        print("Error: No .vhd files found in the 'src' directory.")
        return

    # 2. Define the exact name of the top-level entity
    top_level_entity = "main" 

    # 3. Build the simulation (Compiles all files together)
    runner.build(
        sources=sources,
        hdl_toplevel=top_level_entity,
        always=True,
        clean=True,  # Automatically deletes and recreates sim_build
    )
    
    # 4. Run the simulation and link it to your Pygame visualizer
    runner.test(
        hdl_toplevel=top_level_entity,
        test_module="board_sim", 
    )

if __name__ == "__main__":
    main()