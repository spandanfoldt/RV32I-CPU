`timescale 1ns / 1ps
import RISCV_PKG::*;

module Execute(
    input  logic [31:0] ReadData1,
    input  logic [31:0] ReadData2,
    input  logic [31:0] ImmExt,
    input  logic [31:0] PC,

    input  logic [3:0] ALUControl,
    input  logic ALUSrc,

    // Forwarding signals
    input  logic [1:0] ForwardA,
    input  logic [1:0] ForwardB,

    input  logic [31:0] EX_MEM_ALUResult,
    input  logic [31:0] MEM_WB_WriteData,

    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    output logic [31:0] AUIPC_result
);

    logic [31:0] SrcA, SrcB;
    logic [31:0] ALU_in1, ALU_in2;

    // =========================
    // FORWARDING MUX
    // =========================
    always_comb begin
        case (ForwardA)
            2'b00: SrcA = ReadData1;
            2'b10: SrcA = EX_MEM_ALUResult;
            2'b01: SrcA = MEM_WB_WriteData;
            default: SrcA = ReadData1;
        endcase

        case (ForwardB)
            2'b00: SrcB = ReadData2;
            2'b10: SrcB = EX_MEM_ALUResult;
            2'b01: SrcB = MEM_WB_WriteData;
            default: SrcB = ReadData2;
        endcase
    end

    // =========================
    // ALU INPUT SELECTION
    // =========================
    assign ALU_in1 = SrcA;
    assign ALU_in2 = (ALUSrc) ? ImmExt : SrcB;

    // WriteData for store
    assign WriteData = SrcB;

    // =========================
    // ALU
    // =========================
    always_comb begin
        case (ALUControl)
            4'b0000: ALUResult = ALU_in1 + ALU_in2;  // ADD
            4'b0001: ALUResult = ALU_in1 - ALU_in2;  // SUB
            4'b0010: ALUResult = ALU_in1 & ALU_in2;  // AND
            4'b0011: ALUResult = ALU_in1 | ALU_in2;  // OR
            4'b0100: ALUResult = ALU_in1 ^ ALU_in2;  // XOR
            4'b0101: ALUResult = ALU_in1 << ALU_in2[4:0]; // SLL
            4'b0110: ALUResult = ALU_in1 >> ALU_in2[4:0]; // SRL
            4'b0111: ALUResult = $signed(ALU_in1) >>> ALU_in2[4:0]; // SRA
            4'b1000: ALUResult = ($signed(ALU_in1) < $signed(ALU_in2)) ? 1 : 0; // SLT
            default: ALUResult = 0;
        endcase
    end

    // AUIPC
    assign AUIPC_result = PC + ImmExt;

endmodule