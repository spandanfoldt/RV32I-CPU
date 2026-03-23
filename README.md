# RV32I-CPU
A custom 16-bit RISC processor implemented in Verilog, featuring a pipelined architecture, ALU, register file, control unit, instruction memory, and data memory. Supports a minimal but efficient instruction set for educational CPU design and FPGA deployment.
Features
Implements RV32I base instruction set
Modular design (easy to debug and extend)
Separate units for:
Instruction Fetch
Instruction Decode
Execute (ALU)
Memory Access
Write Back
Functional units:
ALU with arithmetic, logical, shift, and comparison operations
Control Unit for instruction decoding
Immediate Generator for all instruction formats
Register File (32 × 32-bit)
Data Memory and Instruction Memory
Includes:
Forwarding Unit (for hazard resolution – partially integrated)
Hazard Detection Unit (for pipeline safety – extendable)
Tracer module for instruction-level debugging (RVFI-style)
