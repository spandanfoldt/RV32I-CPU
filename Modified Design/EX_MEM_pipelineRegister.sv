`timescale 1ns / 1ps

module EX_MEM_pipelineRegister (
    input  logic CLK,
    input  logic Reset,
    input  logic Flush,

    // EX STAGE DATA
    input  logic [31:0] EX_PC,
    input  logic [31:0] EX_ALUResult,
    input  logic [31:0] EX_WriteData,
    input  logic [31:0] EX_AUIPCResult,
    input logic [31:0] EX_Instruction,
    input logic [31:0] EX_LUIResult,

    input  logic [4:0] EX_rd,

    // CONTROL SIGNALS
    input  logic EX_RegWrite,
    input  logic EX_MemWrite,
    input  logic EX_MemRead,
    input  logic EX_MemToReg,
    input  logic EX_LUI,
    input  logic EX_AUIPC,
    input  logic EX_Link,

    // MEM STAGE OUTPUTS
    output logic [31:0] MEM_PC,
    output logic [31:0] MEM_ALUResult,
    output logic [31:0] MEM_WriteData,
    output logic [31:0] MEM_AUIPCResult,
    output logic [31:0] MEM_Instruction,
    output logic [31:0] MEM_LUIResult,

    output logic [4:0] MEM_rd,

    output logic MEM_RegWrite,
    output logic MEM_MemWrite,
    output logic MEM_MemRead,
    output logic MEM_MemToReg,
    output logic MEM_LUI,
    output logic MEM_AUIPC,
    output logic MEM_Link
    
);

    always_ff @(posedge CLK or posedge Reset) begin

        if (Reset || Flush) begin

            MEM_PC          <= 0;
            MEM_ALUResult   <= 0;
            MEM_WriteData   <= 0;
            MEM_AUIPCResult <= 0;
            MEM_rd          <= 0;
            

            MEM_RegWrite    <= 0;
            MEM_MemWrite    <= 0;
            MEM_MemRead     <= 0;
            MEM_MemToReg    <= 0;
            MEM_LUI         <= 0;
            MEM_AUIPC       <= 0;
            MEM_Instruction <= 0;
            MEM_Link        <= 0;
            MEM_LUIResult   <= 0;

        end
        else begin

            MEM_PC          <= EX_PC;
            MEM_ALUResult   <= EX_ALUResult;
            MEM_WriteData   <= EX_WriteData;
            MEM_AUIPCResult <= EX_AUIPCResult;
            MEM_rd          <= EX_rd;

            MEM_RegWrite    <= EX_RegWrite;
            MEM_MemWrite    <= EX_MemWrite;
            MEM_MemRead     <= EX_MemRead;
            MEM_MemToReg    <= EX_MemToReg;
            MEM_LUI         <= EX_LUI;
            MEM_AUIPC       <= EX_AUIPC;
            MEM_Instruction <= EX_Instruction;
            MEM_Link        <= EX_Link;
            MEM_LUIResult <= EX_LUIResult;

        end

    end

endmodule