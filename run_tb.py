import os
import subprocess
import sys
from pathlib import Path

def run_command(cmd, cwd=None, ignore_error=False):
    """Helper function to run terminal commands and print output."""
    result = subprocess.run(cmd, shell=True, text=True, cwd=cwd)
    if result.returncode != 0 and not ignore_error:
        print(f"Error executing command: {cmd}")
        sys.exit(1)

def main():
    # 1. Ask the student which testbench to run
    print("Available Testbenches in src/:")
    src_dir = Path("src")
    tb_files = list(src_dir.glob("*_tb.vhd"))
    
    if not tb_files:
        print("No testbenches found (looking for files ending in '_tb.vhd').")
        return

    for i, file in enumerate(tb_files):
        print(f"[{i}] {file.stem}")

    choice = input("\nEnter the number of the testbench to run: ")
    
    try:
        tb_name = tb_files[int(choice)].stem
    except (ValueError, IndexError):
        print("Invalid selection.")
        return

    print(f"\n--- Compiling and Running {tb_name} ---")

    # 2. Analyze all VHDL files
    os.makedirs("build", exist_ok=True)
    run_command("ghdl -a --workdir=build src/*.vhd")

    # 3. Elaborate the selected testbench
    run_command(f"ghdl -e --workdir=build {tb_name}")

    # 4. Run simulation and output VCD
    vcd_file = "waveforms.vcd"
    print(f"\nGenerating {vcd_file}...")
    
    # We ignore the error here because VHDL 'severity failure' throws a non-zero exit code
    run_command(f"ghdl -r --workdir=build {tb_name} --vcd={vcd_file}", ignore_error=True)

    print(f"\nSuccess! To view your waveforms, run this command in your terminal:")
    print(f"gtkwave {vcd_file} &")

if __name__ == "__main__":
    main()