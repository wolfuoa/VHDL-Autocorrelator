# VHDL-Autocorrelator
Repository to document the development process of a hardware accelerator autocorrelator

Autocorrelation is a mathematical quantification of a time series' similarity to its lagged self. Evaluating the autocorrelation of a time series allows analysts to determine the degree of relation between data points and the predecessors in their vicinity. Autocorrelation is a powerful tool in signal processing applications and is predominantly used in the field of statistical analysis to analyze trends in specialized data. Additionally, autocorrelation may be employed in embedded audio processing applications to serve as an arbiter for the relativity of a continuous signal. However, in high bandwidth computing environments, an unadorned CPU may not provide the processing ability to effectively use time while inferring the autocorrelation of a continuous signal. For that reason it is of interest to apply hardware accelerators as a relief to the bottleneck caused by autocorrelation within embedded real-time systems.

This repository contains the VHDL source code for a autocorrelation processor in hardware.

## Getting Started

Take a look at the `/src` folder. The `/src` folder contains the majority of the work regarding programming. The `/processor` subfolder contains the most important parts of the processor.

The `/test` folder contains all of the modelsim testbenches used to evaluate the processor.

The `/docs` folder contains all research material, project resources, writing, and conceptual design work.

The `/quartus` folder contains all required resources for compiling and synthesizing the processor onto an FPGA.

## Description of the System
The COR-ASP takes an input signal from the NoC and outputs a correlation packet to a peak detector ASP. The autocorrelation of a time series provides insight by magnifying features and patterns and avoiding effects of noise. This is vital for an audio analysis system, as the next processor peak detector needs a clean signal to analyze the period of signals from.

## Testing with Modelsim

### Compiling all files

1. Open Modelsim and change directory to the `/test` folder. Within this folder is a script that will compile files in the correct order.
2. Run the command `do compile.do`.

This will compile all required files in the correct order and populate your work library with the testbench files.

### Available testbench files

- `testbench_corasp` testbench the Autocorrelation ASP.

> [!NOTE]
> All scripts have the intended configuration automated, feel free to tinker with the waves and runtime
