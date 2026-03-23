`timescale 1ns / 1ps

module InstructionDecode(
    input  logic CLK,
    input  logic EN,
    input  logic Reset,
    input  logic IF_ID_Write,

    input  logic [31:0] ReadInstruction,
    input  logic [31:0] PC,

    input  logic RegWrite,
    input  logic [4:0] WriteReg,
    input  logic [31:0] WriteData,

    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2,
    output logic [31:0] ImmediateOutput,

    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,

    output logic [2:0] func3,
    output logic [6:0] func7,
    output logic [6:0] Opcode
);

logic [31:0] Instruction_reg;
logic [31:0] PC_reg;

logic [31:0] RegFile [0:31];

// IF/ID pipeline register (with stall)
always_ff @(posedge CLK or posedge Reset) begin
    if (Reset) begin
        Instruction_reg <= 0;
        PC_reg <= 0;
    end else if (IF_ID_Write) begin
        Instruction_reg <= ReadInstruction;
        PC_reg <= PC;
    end
end

// decode fields
assign Opcode = Instruction_reg[6:0];
assign rd     = Instruction_reg[11:7];
assign func3  = Instruction_reg[14:12];
assign rs1    = Instruction_reg[19:15];
assign rs2    = Instruction_reg[24:20];
assign func7  = Instruction_reg[31:25];

// register read
assign ReadData1 = RegFile[rs1];
assign ReadData2 = RegFile[rs2];

// writeback
always_ff @(posedge CLK) begin
    if (RegWrite && (WriteReg != 0))
        RegFile[WriteReg] <= WriteData;
end

// simple immediate (I-type only for now)
assign ImmediateOutput = {{20{Instruction_reg[31]}}, Instruction_reg[31:20]};

endmodule