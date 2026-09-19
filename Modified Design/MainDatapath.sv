`timescale 1ns / 1ps
import RISCV_PKG::*;

module MainDatapath(
    input  logic CLK,
    input  logic EN,
    input  logic Reset,
    output logic [31:0] PC_out,
);



    //IF Stage
    logic [31:0] IF_Instruction;
    logic [31:0] IF_PC;
    logic [31:0] PC_plus4;
    logic [31:0] NextPC;
    logic PCWrite;
    
    InstructionFetch instruction_fetch (
        .CLK(CLK),
        .EN(EN),
        .Reset(Reset),
        .PCWrite(PCWrite),
        .NextPC(NextPC),
    
        .IF_Instruction(IF_Instruction),
        .IF_PC(IF_PC)
    );
    
    assign PC_out = IF_PC;
    assign PC_plus4 = PC_out + 32'd4;
    
    
    //branch decision logic
    logic BranchTaken;
    logic EX_ZeroResult;
    logic EX_Branch;
    logic [2:0] EX_funct3;
    logic [31:0] EX_PC;
    logic [31:0] EX_Immediate;

    always_comb begin
        BranchTaken = 1'b0;

        if (EX_Branch) begin
            case (EX_funct3)
                3'b000: BranchTaken = EX_ZeroResult;      // BEQ
                3'b001: BranchTaken = ~EX_ZeroResult;     // BNE
                default: BranchTaken = 1'b0;
            endcase
        end
    end

    logic [31:0] BranchTarget;
    assign BranchTarget = EX_PC + EX_Immediate;

    logic EX_JALR;
    logic [31:0] EX_ALUResult;
    logic [31:0] JumpTarget;
    assign JumpTarget = EX_JALR ? (EX_ALUResult & 32'hFFFFFFFE) : EX_PC + EX_Immediate;

    logic EX_Jump;

    always_comb begin
        NextPC = PC_plus4;

        if (BranchTaken)
            NextPC = BranchTarget;
        else if (EX_Jump)
            NextPC = JumpTarget;
    end

    //IF-ID Pipeline
    logic [31:0] ID_PC;
    logic [31:0] ID_Instruction;

    logic IF_ID_Write;
    logic IF_ID_Flush;

    assign IF_ID_Flush = BranchTaken || EX_Jump;

    IF_ID_pipelineRegister if_id_reg (
        .CLK(CLK),
        .Reset(Reset),
        .Wen(IF_ID_Write),
        .Flush(IF_ID_Flush),

        .IF_PC(IF_PC),
        .IF_Instruction(IF_Instruction),

        .ID_PC(ID_PC),
        .ID_Instruction(ID_Instruction)
    );

    logic [4:0] IF_ID_rs1;
    logic [4:0] IF_ID_rs2;

    assign IF_ID_rs1 = ID_Instruction[19:15];
    assign IF_ID_rs2 = ID_Instruction[24:20];

    //Instruction Decode
    logic [31:0] ID_ReadData1;
    logic [31:0] ID_ReadData2;
    logic [31:0] ID_Immediate;

    logic [4:0] ID_rs1;
    logic [4:0] ID_rs2;
    logic [4:0] ID_rd;

    logic [2:0] ID_funct3;
    logic [6:0] ID_funct7;
    logic [6:0] ID_Opcode;

    logic [31:0] WB_WriteData;
    logic [4:0] WB_rd;
    logic WB_RegWrite;

    InstructionDecode decode (
        .CLK(CLK),
        .Reset(Reset),

        .ReadInstruction(ID_Instruction),

        .RegWrite(WB_RegWrite),
        .WriteReg(WB_rd),
        .WriteData(WB_WriteData),

        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2),
        .ImmediateOutput(ID_Immediate),

        .rs1(ID_rs1),
        .rs2(ID_rs2),
        .rd(ID_rd),

        .func3(ID_funct3),
        .func7(ID_funct7),
        .Opcode(ID_Opcode)

    );

    //Control Unit
    logic [2:0] ID_ALUOp;

    logic ID_RegWrite;
    logic ID_MemWrite;
    logic ID_MemRead;
    logic ID_MemToReg;
    logic ID_ALUSrc;
    logic ID_Branch;
    logic ID_Jump;
    logic ID_JALR;
    logic ID_LUI;
    logic ID_AUIPC;
    logic ID_Link;

    ControlUnit control_unit (
        .Opcode(ID_Opcode),

        .ALUOp(ID_ALUOp),
        .RegWrite(ID_RegWrite),
        .MemWrite(ID_MemWrite),
        .MemRead(ID_MemRead),
        .MemToReg(ID_MemToReg),
        .ALUSrc(ID_ALUSrc),

        .Branch(ID_Branch),
        .Jump(ID_Jump),
        .JALR(ID_JALR),

        .LUI(ID_LUI),
        .AUIPC(ID_AUIPC),
        .Link(ID_Link)
    );

    //ID-EX Pipeline
    logic [31:0] EX_ReadData1;
    logic [31:0] EX_ReadData2;
    logic [31:0] EX_Instruction;

    logic [4:0] EX_rs1;
    logic [4:0] EX_rs2;
    logic [4:0] EX_rd;

    logic [6:0] EX_funct7;

    logic [2:0] EX_ALUOp;

    logic EX_RegWrite;
    logic EX_MemWrite;
    logic EX_MemRead;
    logic EX_MemToReg;
    logic EX_ALUSrc;
    //logic EX_JALR;
    logic EX_LUI;
    logic EX_AUIPC;
    logic EX_Link;
    logic Stall;
    logic ID_EX_Flush;

    assign ID_EX_Flush = Stall || BranchTaken || EX_Jump;

    ID_EX_pipelineRegister id_ex_reg (

        .CLK(CLK),
        .Reset(Reset),
        .Flush(ID_EX_Flush),

        .ID_PC(ID_PC),
        .ID_ReadData1(ID_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .ID_Immediate(ID_Immediate),
        .ID_Instruction(ID_Instruction),

        .ID_rs1(ID_rs1),
        .ID_rs2(ID_rs2),
        .ID_rd(ID_rd),

        .ID_funct3(ID_funct3),
        .ID_funct7(ID_funct7),

        .ID_ALUOp(ID_ALUOp),
        .ID_RegWrite(ID_RegWrite),
        .ID_MemWrite(ID_MemWrite),
        .ID_MemRead(ID_MemRead),
        .ID_MemToReg(ID_MemToReg),
        .ID_ALUSrc(ID_ALUSrc),
        .ID_Branch(ID_Branch),
        .ID_Jump(ID_Jump),
        .ID_JALR(ID_JALR),
        .ID_LUI(ID_LUI),
        .ID_AUIPC(ID_AUIPC),
        .ID_Link(ID_Link),

        .EX_PC(EX_PC),
        .EX_ReadData1(EX_ReadData1),
        .EX_ReadData2(EX_ReadData2),
        .EX_Immediate(EX_Immediate),
        .EX_Instruction(EX_Instruction),

        .EX_rs1(EX_rs1),
        .EX_rs2(EX_rs2),
        .EX_rd(EX_rd),

        .EX_funct3(EX_funct3),
        .EX_funct7(EX_funct7),

        .EX_ALUOp(EX_ALUOp),
        .EX_RegWrite(EX_RegWrite),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemToReg(EX_MemToReg),
        .EX_ALUSrc(EX_ALUSrc),
        .EX_Branch(EX_Branch),
        .EX_Jump(EX_Jump),
        .EX_JALR(EX_JALR),
        .EX_LUI(EX_LUI),
        .EX_AUIPC(EX_AUIPC),
        .EX_Link(EX_Link)
    );

    //EX Stage
    logic [3:0] EX_ALUControl;
    //logic [31:0] EX_ALUResult;
    logic [31:0] EX_WriteData;
    logic [31:0] EX_AUIPCResult;
    logic [31:0] MEM_WriteData;
    logic [31:0] MEM_ALUResult;
    logic [31:0] EX_LUIResult;
    
    assign EX_LUIResult = EX_Immediate;

    ALUControl alu_control (
        .ALUOp(EX_ALUOp),
        .funct3(EX_funct3),
        .funct7(EX_funct7),
        .ALUControl(EX_ALUControl)
    );

    logic [1:0] ForwardA;
    logic [1:0] ForwardB;

    logic [4:0] MEM_rd;
    logic MEM_RegWrite;

    ForwardingUnit forwarding_unit (
        .ID_EX_rs1(EX_rs1),
        .ID_EX_rs2(EX_rs2),

        .EX_MEM_rd(MEM_rd),
        .EX_MEM_RegWrite(MEM_RegWrite),

        .MEM_WB_rd(WB_rd),
        .MEM_WB_RegWrite(WB_RegWrite),

        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    Execute execute (
        .ReadData1(EX_ReadData1),
        .ReadData2(EX_ReadData2),
        .ImmExt(EX_Immediate),
        .PC(EX_PC),

        .ALUControl(EX_ALUControl),
        .ALUSrc(EX_ALUSrc),

        .ForwardA(ForwardA),
        .ForwardB(ForwardB),

        .EX_MEM_ALUResult(MEM_ALUResult),
        .MEM_WB_WriteData(WB_WriteData),

        .ALUResult(EX_ALUResult),
        .WriteData(EX_WriteData),
        .AUIPC_result(EX_AUIPCResult),
        .ZeroResult(EX_ZeroResult)
    );

    // EX-MEM Pipeline
    logic [31:0] MEM_PC;
    logic [31:0] MEM_AUIPCResult;
    logic [31:0] MEM_Instruction;

    logic MEM_MemWrite;
    logic MEM_MemRead;
    logic MEM_MemToReg;
    logic MEM_LUI;
    logic MEM_AUIPC;
    logic MEM_Link;
    logic [31:0] MEM_LUIResult;

    EX_MEM_pipelineRegister ex_mem_reg (

        .CLK(CLK),
        .Reset(Reset),
        .Flush(1'b0),

        .EX_PC(EX_PC),
        .EX_ALUResult(EX_ALUResult),
        .EX_WriteData(EX_WriteData),
        .EX_AUIPCResult(EX_AUIPCResult),
        .EX_Instruction(EX_Instruction),
        .EX_LUIResult(EX_LUIResult),

        .EX_rd(EX_rd),

        .EX_RegWrite(EX_RegWrite),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemToReg(EX_MemToReg),
        .EX_LUI(EX_LUI),
        .EX_AUIPC(EX_AUIPC),
        .EX_Link(EX_Link),

        .MEM_PC(MEM_PC),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_WriteData(MEM_WriteData),
        .MEM_AUIPCResult(MEM_AUIPCResult),
        .MEM_Instruction(MEM_Instruction),
        .MEM_LUIResult(MEM_LUIResult),

        .MEM_rd(MEM_rd),

        .MEM_RegWrite(MEM_RegWrite),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_LUI(MEM_LUI),
        .MEM_AUIPC(MEM_AUIPC),
        .MEM_Link(MEM_Link)
    );

    //Data Memory
    logic [31:0] MEM_ReadData;

    DataMemory data_memory (
        .CLK(CLK),
        .EN(EN),

        .MemWrite(MEM_MemWrite),
        .MemRead(MEM_MemRead),

        .Address(MEM_ALUResult[11:2]),
        .WriteData(MEM_WriteData),

        .ReadData(MEM_ReadData)
    );

    //MEM-WB Pipeline
    logic [31:0] WB_PC;
    logic [31:0] WB_ALUResult;
    logic [31:0] WB_ReadData;
    logic [31:0] WB_AUIPCResult;
    logic [31:0] WB_LUIResult;
    logic [31:0] WB_Instruction;

    logic WB_MemToReg;
    logic WB_LUI;
    logic WB_AUIPC;
    logic WB_Link;

    MEM_WB_PipelineRegister mem_wb_reg (

        .CLK(CLK),
        .Reset(Reset),

        .MEM_PC(MEM_PC),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_ReadData(MEM_ReadData),
        .MEM_AUIPCResult(MEM_AUIPCResult),
        .MEM_LUIResult(MEM_LUIResult),
        .MEM_Instruction(MEM_Instruction),

        .MEM_rd(MEM_rd),

        .MEM_RegWrite(MEM_RegWrite),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_LUI(MEM_LUI),
        .MEM_AUIPC(MEM_AUIPC),
        .MEM_Link(MEM_Link),

        .WB_PC(WB_PC),
        .WB_ALUResult(WB_ALUResult),
        .WB_ReadData(WB_ReadData),
        .WB_AUIPCResult(WB_AUIPCResult),
        .WB_LUIResult(WB_LUIResult),
        .WB_Instruction(WB_Instruction),

        .WB_rd(WB_rd),

        .WB_RegWrite(WB_RegWrite),
        .WB_MemToReg(WB_MemToReg),
        .WB_LUI(WB_LUI),
        .WB_AUIPC(WB_AUIPC),
        .WB_Link(WB_Link)
    );

    //Write Back
    WriteBack writeback (
        .WB_PC(WB_PC),
        .WB_ALUResult(WB_ALUResult),
        .WB_ReadData(WB_ReadData),
        .WB_LUIResult(WB_LUIResult),
        .WB_AUIPCResult(WB_AUIPCResult),

        .WB_MemToReg(WB_MemToReg),
        .WB_LUI(WB_LUI),
        .WB_AUIPC(WB_AUIPC),
        .WB_Link(WB_Link),

        .WB_WriteData(WB_WriteData)
    );

    //Hazard Detection

    HazardDetectionUnit hazard_unit (
        .ID_EX_MemRead(EX_MemRead),
        .ID_EX_rd(EX_rd),

        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),

        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .Stall(Stall)
    );

endmodule
