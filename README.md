# Digital RTL Design and CMOS Circuit Characterization

Verilog design, synthesis, timing/power analysis, and transistor-level characterization coursework by Ang Chen for UCLA ECE 216A, Fall 2025.

## Overview

- Implemented a registered ALU with 8-bit operands, 16-bit results, and seven arithmetic/logic operations.
- Developed an overlapping `1101101` sequence detector and directed Verilog testbench.
- Performed ALU synthesis, static timing analysis, and activity-based power analysis.
- Characterized CMOS inverters, a 15-stage ring oscillator, and a transmission-gate latch.

## Tools

Verilog, ModelSim, Synopsys Design Compiler, PrimeTime, PrimePower, and Cadence Virtuoso.

## Repository Structure

| Directory | Contents |
| --- | --- |
| `rtl/` | ALU and sequence-detector implementations |
| `tb/` | Directed sequence-detector testbench |
| `synthesis/` | Analysis ALU and synthesis/timing/power Tcl scripts |
| `report/` | Coursework reports containing schematics, waveforms, and results |

## RTL Design

### Registered ALU

`rtl/alu.v` implements module `HW2_alu`, with registered operands, instruction, and output. Operations include addition, subtraction, multiplication, bitwise AND/XOR, absolute value, and a scaled difference.

### Sequence Detector

`rtl/sequence_detector.v` implements module `FSM`, an eight-state Moore machine that detects `1101101`, supports overlapping matches, and uses an active-low asynchronous reset.

The testbench supplies directed stimulus and prints state/output observations. It does not implement automated pass/fail checking.

## Synthesis, Timing, and Power

The synthesis exercise uses `synthesis/alu_analysis.v`, a separate course ALU with a different instruction mapping from the RTL implementation.

- `dc_synthesis.tcl`: synthesizes the analysis ALU and exports gate-level Verilog, SDF, SDC, and reports.
- `timing_power.tcl`: analyzes timing and estimates average power using gate-level VCD switching activity.

Operation-dependent power was evaluated using ModelSim gate-level simulations and PrimePower.

## CMOS Characterization

The reports document:

- Inverter voltage-transfer characteristics, switching threshold, and noise margins.
- FO1/FO4 propagation delays and ring-oscillator behavior.
- Transmission-gate latch propagation delay, setup/hold timing, and metastability.

Virtuoso design databases and device models are not included.

## Running the FSM Simulation

From the repository root, use ModelSim:

```tcl
vlib work
vlog rtl/sequence_detector.v tb/sequence_detector_tb.v
vsim work.FSM_tb
add wave -r /*
run -all
```

Inspect the waveforms and printed observations to evaluate the detector response.

## Synthesis and Power Requirements

The Synopsys scripts require a licensed installation and compatible technology libraries. Update the hardcoded library paths for your environment.

Run synthesis from `synthesis/`, create the `WORK` directory, and ensure the RTL input in `dc_synthesis.tcl` is specified as:

```tcl
analyze -format verilog {alu_analysis.v}
```

Power analysis additionally requires:

- Generated `alu.vg` and `alu.sdf`.
- A compatible ALU testbench and standard-cell simulation models.
- An `alu.vcd` activity file matching the configured hierarchy `alu_tb/alu_0`.

The supplied ALU testbench and technology libraries are not bundled. The complete synthesis and power-analysis flow requires these external dependencies. The commands above have not been rerun during repository preparation.

## Attribution

Student coursework based on UCLA ECE 216A assignments. The HW3 analysis ALU and tool scripts use supplied course materials; original attribution and applicable terms remain in effect.
