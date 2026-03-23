`timescale 1ns / 1ps

module Memory(
    input  logic        CLK,
    input  logic        MemWrite,
    input  logic        MemRead,
    input  logic [31:0] Address,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData
);

    DataMemory DM (
        .CLK(CLK),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(Address),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

endmodule