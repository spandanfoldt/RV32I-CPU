`timescale 1ns / 1ps
import RISCV_PKG::*;

module MainMemory(
    input  logic        clk,
    input  logic        MemWrite,       // keep port (won't actually write instructions)
    input  logic        MemRead,
    input  logic [31:0] InstructionAddress,
    input  logic [31:0] DataAddress,    // keep port
    input  logic [31:0] WriteData,      // keep port
    input  logic [2:0]  Funct3,         // keep port
    output logic [31:0] ReadInstruction,
    output logic [31:0] ReadData        // keep port
);

    // Tell Vivado this is Block RAM style
    (* ram_style = "block" *) logic [31:0] InstructionMem [0:1023];
    logic [31:0] tempRead;

    initial begin
        // Load instructions from your file
        $readmemh("Instructions.mem", InstructionMem);
    end

    always_ff @(posedge clk) begin
        if (MemRead)
            tempRead <= InstructionMem[InstructionAddress[11:2]]; // word-aligned
    end

    assign ReadInstruction = tempRead;
    assign ReadData = 32'b0; // keep port to maintain interface

endmodule