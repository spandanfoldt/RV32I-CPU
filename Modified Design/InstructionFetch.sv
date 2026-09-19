`timescale 1ns / 1ps

module InstructionFetch(
    input  logic CLK,
    input  logic EN,
    input  logic Reset,
    input  logic PCWrite,
    
    input  logic [31:0] NextPC,

    output logic [31:0] IF_Instruction,
    output logic [31:0] IF_PC
);
    
    logic [31:0] PC_reg;
    
    PC PCUnit(
        .CLK(CLK),
        .Reset(Reset),
        .PCWrite(PCWrite),
        .NextPC(NextPC),
        .PC_out(PC_reg)
    );
    
    InstructionMemory IM(
        .EN(EN),
        .InstructionAddress(PC_reg),
        .ReadInstruction(IF_Instruction)
    );
    
    assign IF_PC = PC_reg;



endmodule
