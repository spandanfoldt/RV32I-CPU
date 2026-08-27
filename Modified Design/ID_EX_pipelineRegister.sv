`timescale 1ns / 1ps

module ID_EX_pipelineRegister (
    input  logic CLK,
    input  logic Reset,
    input  logic Flush,

    // ID STAGE DATA
    input  logic [31:0] ID_PC,
    input  logic [31:0] ID_ReadData1,
    input  logic [31:0] ID_ReadData2,
    input  logic [31:0] ID_Immediate,
    input  logic [31:0] ID_Instruction,

    input  logic [4:0] ID_rs1,
    input  logic [4:0] ID_rs2,
    input  logic [4:0] ID_rd,

    input  logic [2:0] ID_funct3,
    input  logic [6:0] ID_funct7,

    // CONTROL SIGNALS
    input  logic [2:0] ID_ALUOp,
    input  logic ID_RegWrite,
    input  logic ID_MemWrite,
    input  logic ID_MemRead,
    input  logic ID_MemToReg,
    input  logic ID_ALUSrc,
    input  logic ID_Branch,
    input  logic ID_Jump,
    input  logic ID_JALR,
    input  logic ID_LUI,
    input  logic ID_AUIPC,
    input  logic ID_Link,
    

    // EX STAGE OUTPUTS
    output logic [31:0] EX_PC,
    output logic [31:0] EX_ReadData1,
    output logic [31:0] EX_ReadData2,
    output logic [31:0] EX_Immediate,
    output logic [31:0] EX_Instruction,

    output logic [4:0] EX_rs1,
    output logic [4:0] EX_rs2,
    output logic [4:0] EX_rd,

    output logic [2:0] EX_funct3,
    output logic [6:0] EX_funct7,

    output logic [2:0] EX_ALUOp,
    output logic EX_RegWrite,
    output logic EX_MemWrite,
    output logic EX_MemRead,
    output logic EX_MemToReg,
    output logic EX_ALUSrc,
    output logic EX_Branch,
    output logic EX_Jump,
    output logic EX_JALR,
    output logic EX_LUI,
    output logic EX_AUIPC,
    output logic EX_Link
    
);


    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset || Flush) begin
            EX_PC <= 0;
            EX_ReadData1 <= 0;
            EX_ReadData2 <= 0;
            EX_Immediate <= 0;
            
            EX_rs1 <= 0;
            EX_rs2 <= 0;
            EX_rd <= 0;
            
            EX_funct3 <= 0;
            EX_funct7 <= 0;
            
            EX_ALUOp <= 0;
            EX_RegWrite <= 0;
            EX_MemWrite <= 0;
            EX_MemRead <= 0;
            EX_MemToReg <= 0;
            EX_ALUSrc <= 0;
            EX_Branch <= 0;
            EX_Jump <= 0;
            EX_JALR <= 0;
            EX_LUI <= 0;
            EX_AUIPC <= 0;
            EX_Instruction <= 0;
            EX_Link <= 0;
        end
        
        else begin
            EX_PC <= ID_PC;
            EX_ReadData1 <= ID_ReadData1;
            EX_ReadData2 <= ID_ReadData2;
            EX_Immediate <= ID_Immediate;
            
            EX_rs1 <= ID_rs1;
            EX_rs2 <= ID_rs2;
            EX_rd <= ID_rd;
            
            EX_funct3 <= ID_funct3;
            EX_funct7 <= ID_funct7;
            
            EX_ALUOp <= ID_ALUOp;
            EX_RegWrite <= ID_RegWrite;
            EX_MemWrite <= ID_MemWrite;
            EX_MemRead <= ID_MemRead;
            EX_MemToReg <= ID_MemToReg;
            EX_ALUSrc <= ID_ALUSrc;
            EX_Branch <= ID_Branch;
            EX_Jump <= ID_Jump;
            EX_JALR <= ID_JALR;
            EX_LUI <= ID_LUI;
            EX_AUIPC <= ID_AUIPC;
            EX_Instruction <= ID_Instruction;
            EX_Link <= ID_Link;
        end
    end

endmodule