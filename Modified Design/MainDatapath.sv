`timescale 1ns / 1ps
import RISCV_PKG::*;

module MainDatapath(
    input  logic CLK,
    input  logic EN,
    input  logic Reset,
    output logic [31:0] PC_out     // Added output for Top module
);

    // =========================
    // INTERNAL SIGNALS
    // =========================
    logic [WORD_LENGTH-1:0] IF_PC, IF_Instruction;
    logic [WORD_LENGTH-1:0] ID_PC, ID_Instruction, ID_Immediate;
    logic [WORD_LENGTH-1:0] EX_ALUResult, EX_ReadData2, EX_ImmExt;
    logic [WORD_LENGTH-1:0] MEM_ReadData, MEM_ALUResult;
    logic [WORD_LENGTH-1:0] WB_WriteData;

    // REGISTER FILE
    logic [ADDRESS_PORT_WIDTH-1:0] ID_ReadReg1, ID_ReadReg2;
    logic [WORD_LENGTH-1:0] ID_ReadData1, ID_ReadData2;

    // CONTROL SIGNALS
    logic [2:0] ALUOp;
    logic ALUSrc, MemWrite, MemToReg, RegWrite;
    logic Branch, Jump, JumpReg;

    // =========================
    // IF STAGE
    // =========================
    ProgramCounter PC_reg(
        .CLK(CLK),
        .Reset(Reset),
        .JumpReg(JumpReg),
        .Jump(Jump),
        .Branch(Branch),
        .ONE(1'b1),
        .ImmediateOutput(ID_Immediate),
        .ReadData1(ID_ReadData1),
        .PC(IF_PC)
    );

    InstructionMemory IM(
        .EN(EN),
        .InstructionAddress(IF_PC),
        .ReadInstruction(IF_Instruction)
    );

    // =========================
    // ID STAGE
    // =========================
    ControlUnit CU(
    .Opcode(IF_Instruction[6:0]), // matches input port
    .ONE(1'b1),                   // tie constant 1, as required
    .ALUOp(ALUOp),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(),                    // optional, you can leave unconnected
    .MemToReg(MemToReg),
    .imm(),                        // optional, leave unconnected if not used
    .Branch(Branch),
    .Jump(Jump),
    .JALR(JumpReg)                 // mapping JumpReg to JALR
);

    ImmediateGenerator ImmGen(
    .instr(IF_Instruction), // matches input port
    .imm(ID_Immediate)      // matches output port
);

    RegisterFile RF(
        .ReadReg1(IF_Instruction[19:15]),
        .ReadReg2(IF_Instruction[24:20]),
        .WriteAddress(WB_WriteData[4:0]),
        .CLK(CLK),
        .Reset(Reset),
        .RegWrite(RegWrite),
        .WriteData(WB_WriteData),
        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2)
    );

    // Pipeline signal assignments
    assign ID_ReadReg1 = IF_Instruction[19:15];
    assign ID_ReadReg2 = IF_Instruction[24:20];
    assign ID_Instruction = IF_Instruction;
    assign ID_PC = IF_PC;
    assign EX_ImmExt = ID_Immediate;

    // =========================
    // EX STAGE
    // =========================
    logic [3:0] ALUControlSig;
    logic ALU_Zero;

    ALUControl ALUCtrl(
        .ALUOp(ALUOp),
        .func3(ID_Instruction[14:12]),
        .func7(ID_Instruction[31:25]),
        .ALUControlout(ALUControlSig)
    );

    logic [WORD_LENGTH-1:0] ALU_in1, ALU_in2;
    assign ALU_in1 = ID_ReadData1;
    assign ALU_in2 = (ALUSrc) ? EX_ImmExt : ID_ReadData2;

    ALU ALUUnit(
        .operandA(ALU_in1),
        .operandB(ALU_in2),
        .ALUControl(ALUControlSig),
        .Result(EX_ALUResult),
        .Zero(ALU_Zero)
    );

    assign EX_ReadData2 = ID_ReadData2;
    assign MEM_ALUResult = EX_ALUResult;

    // =========================
    // MEM STAGE
    // =========================
    DataMemory DM(
        .CLK(CLK),
        .MemWrite(MemWrite),
        .MemRead(1'b1),
        .Address(EX_ALUResult),
        .WriteData(EX_ReadData2),
        .ReadData(MEM_ReadData),
        .mask_bits(4'b1111)
    );

    // =========================
    // WB STAGE
    // =========================
    WriteBack WB(
        .CLK(CLK),
        .MemToReg(MemToReg),
        .ReadData(MEM_ReadData),
        .ALUResult(MEM_ALUResult),
        .WriteData(WB_WriteData)
    );

    // Output PC to Top
    assign PC_out = IF_PC;

endmodule