# Gaussian Random Number Generator

<br/>

## Description

A hardware-based Gaussian Random Number Generator implemented in Verilog with Python tools for LUT generation and visualization

<br/><hr/><br/>

## Features

- Python-based LUT generation from Gaussian distribution using the Ziggurat algorithm
- Export of LUTs and Ziggurat configuration in '.hex' format
- Visualization and quality evaluation of T-URNG and GRNG outputs using matplotlib
- Verilog-vased hardware implementation of a Gaussian Random Number Generator (GRNG)
- Develoment of individual testbenches for each hardware module to verify correctness

<br/><hr/><br/>

## Requirements

- Python 3.12.4
- Matplotlib 3.8.4
- NumPy 1.26.4

<br/><hr/><br/>

## Directory Structure

```text
├── source/
│   ├── preprocessing/
│   │   ├── LUTs.py
│   │   ├── LUT_coef_exp.py
│   │   └── LUT_coef_ln.py
│   ├── grng core/
│   │   ├── module/
│   │   │   ├── ABS.v
│   │   │   ├── Buffer.v
│   │   │   ├── Compare.v
│   │   │   ├── exp.v
│   │   │   ├── ln.v
│   │   │   ├── LUTs.v
│   │   │   ├── Multiply.v
│   │   │   ├── OpUnit.v
│   │   │   ├── T_URNG.v
│   │   │   ├── Truncate.v
│   │   │   ├── UBuffer.v
│   │   │   ├── Stage1.v
│   │   │   ├── Stage2.v
│   │   │   ├── Stage3.v
│   │   │   ├── Stage4.v
│   │   │   ├── Stage5.v
│   │   │   └── GRNG.v
│   │   └── testbench/
│   │       ├── ABS_tb.v
│   │       ├── Buffer_tb.v
│   │       ├── Compare_tb.v
│   │       ├── exp_tb.v
│   │       ├── ln_tb.v
│   │       ├── LUTs_tb.v
│   │       ├── Multiply_tb.v
│   │       ├── OpUnit_tb.v
│   │       ├── T_URNG_tb.v
│   │       ├── Truncate_tb.v
│   │       └── UBuffer_tb.v
│   └── validation/
│       ├── T_URNG.py
│       └── GRNG.py
├── exported files/
│   ├── preprocessing/
│   │   ├── ziggurat_config.vh
│   │   ├── r.hex
│   │   ├── rmost_coord.hex
│   │   ├── fn.hex
│   │   ├── wedge_bound_ratio.hex
│   │   ├── const.hex
│   │   ├── seed.hex
│   │   ├── coef_exp.hex
│   │   └── coef_ln.hex
│   └── grng core/
│       ├── Gaussian random numbers.txt
│       └── Count.txt
├── visualization/
│   ├── ziggurat layer/
│   │   ├── Ziggurat Layer (N=8).png
│   │   ├── Ziggurat Layer (N=16).png
│   │   ├── Ziggurat Layer (N=32).png
│   │   ├── Ziggurat Layer (N=64).png
│   │   ├── Ziggurat Layer (N=128).png
│   │   ├── Ziggurat Layer (N=256).png
│   │   └── Ziggurat Layer (N=512).png
│   ├── t-urng histogram/
│   │   ├── T-URNG Histogram with 1E+6 Sim.png
│   │   └── T-URNG Histogram with 1E+8 Sim.png
│   └── grng histogram/
│       ├── GRNG Histogram with 1E+6 Sim.png
│       └── GRNG Histogram with 1E+8 Sim.png
├── README.md
├── LICENSE
├── .gitignore
└── .gitattributes
```

<br/><hr/><br/>

## Visualization

### Ziggurat Layer

<table align="center">
  <tr>
    <td align="center"><img src="visualization/ziggurat layer/Ziggurat Layer (N=8).png" width="100%"/></td>
    <td align="center"><img src="visualization/ziggurat layer/Ziggurat Layer (N=256).png" width="100%"/></td>
  </tr>
  <tr>
    <td align="center">N = 8</td>
    <td align="center">N = 256</td>
  </tr>
</table>

<br/>

### T-URNG Histogram

<table align="center">
  <tr>
    <td align="center"><img src="visualization/t-urng histogram/T-URNG Histogram with 1E+6 Sim.png" width="100%"/></td>
    <td align="center"><img src="visualization/t-urng histogram/T-URNG Histogram with 1E+8 Sim.png" width="100%"/></td>
  </tr>
  <tr>
    <td align="center">1E+6 Simulations</td>
    <td align="center">1E+8 Simulations</td>
  </tr>
</table>

<br/>

### GRNG Histogram

<table align="center">
  <tr>
    <td align="center"><img src="visualization/grng histogram/GRNG Histogram with 1E+6 Sim.png" width="100%"/></td>
    <td align="center"><img src="visualization/grng histogram/GRNG Histogram with 1E+8 Sim.png" width="100%"/></td>
  </tr>
  <tr>
    <td align="center">1E+6 Simulations</td>
    <td align="center">1E+8 Simulations</td>
  </tr>
</table>

<br/><hr/><br/>

## Exported Files

### Gaussian random numbers.txt
```text
1.182616129517555200000000000000
-0.859748002141714100000000000000
0.776774756610393520000000000000
0.679252501577138900000000000000
1.153344508260488500000000000000
...
```

<br/>

### Count.txt
```text
100000
5308
```

<br/><hr/><br/>

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

<br/><br/><br/>
