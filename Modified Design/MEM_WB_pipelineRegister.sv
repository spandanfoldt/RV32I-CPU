`timescale 1ns / 1ps

module MEM_WB_PipelineRegister (
    input  logic CLK,
    input  logic Reset,

    // MEM STAGE INPUTS
    input logic [31:0] MEM_ALUResult,
    input logic [31:0] MEM_ReadData,
    input logic [31:0] MEM_AUIPCResult,
    input logic [31:0] MEM_LUIResult,
    input logic [31:0] MEM_Instruction,
    input logic [31:0] MEM_PC,

    input logic [4:0] MEM_rd,
    
    input logic MEM_Link,
    // CONTROL
    input logic MEM_RegWrite,
    input logic MEM_MemToReg,
    input logic MEM_LUI,
    input logic MEM_AUIPC,

    // WB STAGE OUTPUTS
    output logic [31:0] WB_ALUResult,
    output logic [31:0] WB_ReadData,
    output logic [31:0] WB_AUIPCResult,
    output logic [31:0] WB_LUIResult,
    output logic [31:0] WB_Instruction,
    output logic [31:0] WB_PC,

    output logic [4:0] WB_rd,

    output logic WB_RegWrite,
    output logic WB_MemToReg,
    output logic WB_LUI,
    output logic WB_AUIPC,
    output logic WB_Link
);

    always_ff @(posedge CLK or posedge Reset) begin

        if (Reset) begin

            WB_ALUResult   <= 0;
            WB_ReadData    <= 0;
            WB_AUIPCResult <= 0;
            WB_LUIResult   <= 0;
            WB_rd          <= 0;

            WB_RegWrite    <= 0;
            WB_MemToReg    <= 0;
            WB_LUI         <= 0;
            WB_AUIPC       <= 0;
            WB_Instruction <= 0;
            WB_PC          <= 0;
            WB_Link        <= 0;

        end
        else begin

            WB_ALUResult    <= MEM_ALUResult;
            WB_ReadData     <= MEM_ReadData;
            WB_AUIPCResult  <= MEM_AUIPCResult;
            WB_LUIResult    <= MEM_LUIResult;
            WB_rd           <= MEM_rd;

            WB_RegWrite     <= MEM_RegWrite;
            WB_MemToReg     <= MEM_MemToReg;
            WB_LUI          <= MEM_LUI;
            WB_AUIPC        <= MEM_AUIPC;
            WB_Instruction  <= MEM_Instruction;
            WB_PC           <= MEM_PC;
            WB_Link         <= MEM_Link;
        end

    end

endmodule