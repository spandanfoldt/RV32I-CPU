`timescale 1ns / 1ps

module Top(
    input  logic CLK,
    input  logic Reset,
    output logic [7:0] LED
);

logic [31:0] PC;

MainDatapath cpu(
    .CLK(CLK),
    .EN(1'b1),
    .Reset(Reset),
    .PC_out(PC)
);

assign LED = PC[9:2];

endmodule