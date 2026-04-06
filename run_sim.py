import os, argparse

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
    return parser.parse_args()


def main():
    sim = os.getenv("SIM", "ghdl")
    runner = get_runner(sim)

    args = parse_arguments()
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


if __name__ == "__main__":
    main()
