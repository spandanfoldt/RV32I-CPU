import RISCV_PKG::*;

`timescale 1ns / 1ps

module DataMemory(
    input  logic CLK,
    input  logic MemWrite,
    input  logic MemRead,
    input  logic [31:0] Address,
    input  logic [31:0] WriteData,

    output logic [31:0] ReadData,
    output logic [3:0]  mask_bits
);

    // --- 32-bit wide memory, 4 KB, block RAM
    (* ram_style = "block" *) logic [31:0] mem [0:1023];

    // --- Write process
    always_ff @(posedge CLK) begin
        if (MemWrite)
            mem[Address[11:2]] <= WriteData; // Word address
    end

    // --- Read process
    always_comb begin
        ReadData = MemRead ? mem[Address[11:2]] : 32'b0;
    end

    // --- Mask bits
    assign mask_bits = MemWrite ? 4'b1111 : 4'b0000;

endmodule