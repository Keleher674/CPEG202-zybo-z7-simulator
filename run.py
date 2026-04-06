import os, argparse, subprocess, sys

os.environ["PYGAME_HIDE_SUPPORT_PROMPT"] = "hide"

from pathlib import Path
from cocotb_tools.runner import get_runner

# Suppress INFO and WARNING messages in the terminal
os.environ["COCOTB_LOG_LEVEL"] = "ERROR"


def parse_arguments():
    """
    Parse command-line arguments.
    Returns:
        argparse.Namespace: Parsed command-line arguments.
    """
    parser = argparse.ArgumentParser(description="Run VHDL simulations with Cocotb.")
    parser.add_argument(
        "-p",
        "--path",
        type=str,
        default="src",
        help="Path to a specific directory containing .vhd files (default: 'src')",
    )
    parser.add_argument(
        "-e",
        "--entity",
        type=str,
        default="top_level",
        help="Name of the top-level entity to simulate (default: 'top_level')",
    )
    parser.add_argument(
        "-t",
        "--test",
        action="store_true",
        help="Run the testbench instead of the normal simulation",
    )
    parser.add_argument(
        "-ns",
        "--no-sim",
        action="store_true",
        help="Only compile the testbench and generate the VCD file, but do not run the simulation (useful for debugging testbenches)",
    )
    parser.add_argument(
        "-o",
        "--output-dir",
        type=str,
        default=None,
        help="Directory to store .vcd waveform files (default: 'waveforms')",
    )
    parser.add_argument(
        "-f",
        "--output-file",
        type=str,
        default="waveforms.vcd",
        help="Name of the output VCD file (default: 'waveforms.vcd')",
    )
    return parser.parse_args()


def sim(args: argparse.Namespace):
    sim = os.getenv("SIM", "ghdl")
    runner = get_runner(sim)

    # 1. Find all .vhd files in the 'src' directory
    # Load if a specific file arguement is given, otherwise load all .vhd files in the src directory
    src_dir = Path(args.path)
    sources = list(src_dir.rglob("*.vhd"))

    if not sources:
        print(
            f"Error: No .vhd files found in the '{src_dir.resolve().absolute()}' directory."
        )
        return

    # 2. Define the exact name of the top-level entity
    top_level_entity = args.entity

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
        extra_env={"COCOTB_LOG_LEVEL": "ERROR"},
    )


def run_command(cmd, cwd=None, ignore_error=False):
    """Helper function to run terminal commands and print output."""
    result = subprocess.run(cmd, shell=True, text=True, cwd=cwd)
    if result.returncode != 0 and not ignore_error:
        print(f"Error executing command: {cmd}")
        sys.exit(1)


def tb(args: argparse.Namespace):
    # 1. Ask the student which testbench to run
    print("Available Testbenches in src/:")
    src_dir = Path(args.path)
    tb_files = list(src_dir.rglob("*_tb.vhd"))

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
    vcd_file = args.output_file
    if not vcd_file.endswith(".vcd"):
        vcd_file += ".vcd"
    print(f"\nGenerating {vcd_file}...")

    # Check if an arguement is given for the output directory, if not save into the root directory to keep it simple
    if args.output_dir:
        # Create the output directory if it doesn't exist and set the full path for the VCD file
        vcd_path = Path(args.output_dir) / vcd_file
        os.makedirs(args.output_dir, exist_ok=True)
    else:
        vcd_path = Path(vcd_file)

    # We ignore the error here because VHDL 'severity failure' throws a non-zero exit code
    run_command(
        f"ghdl -r --workdir=build {tb_name} --vcd={vcd_path}", ignore_error=True
    )

    if not args.no_sim:
        print(f"\nSuccess! Opening gtkwave to view your waveforms...")
        os.execlp("gtkwave", "gtkwave", f"{vcd_path}")
    else:
        print(f"\nSuccess! To view your waveforms, run this command in your terminal:")
        print(f"gtkwave {vcd_path} &")


if __name__ == "__main__":
    args = parse_arguments()
    # If user runs with --test, run the testbench flow, otherwise run the normal sim flow
    if args.test:
        tb(args)
    else:
        sim(args)
