import RISCV_PKG::*;
`timescale 1ns / 1ps

module TracerPipelineRegister(
    input logic CLK, ID_ValidInstruction, ID_EX_HazardDetected, HazardDetected,
    input logic [WORD_LENGTH-1:0] IF_Instruction, ID_ReadData1, ID_ReadData2, WB_WriteData, IF_ID_PC, 
    input logic [WORD_LENGTH-1:0] IF_PC, MEM_ReadData, MEM_WriteData, MEM_ReadAddress,
    input logic [ADDRESS_PORT_WIDTH-1:0] ID_ReadReg1, ID_ReadReg2, MEM_WriteAddress,
    input logic [3:0] MEM_mask_bits,

    output logic rvfi_i_bool,
    output logic [3:0]  rvfi_i_uint4,
    output logic [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_0,
    output logic [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_1,
    output logic [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_2,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_0,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_1,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_2,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_3,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_4,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_5,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_6,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_7,
    output logic [WORD_LENGTH-1:0] rvfi_i_uint32_8
);

    // --- Internal bundled registers to reduce LUT usage
    logic [WORD_LENGTH-1:0] rvfi_regs32[0:8];
    logic [ADDRESS_PORT_WIDTH-1:0] rvfi_regs5[0:2];
    logic rvfi_valid;
    logic [3:0] rvfi_mask;

    // --- Pipeline stage registers
    logic ID_EX_ValidInstruction, EX_MEM_ValidInstruction;
    logic [WORD_LENGTH-1:0] ID_EX_Instruction, EX_MEM_Instruction;
    logic [WORD_LENGTH-1:0] ID_EX_prevPC, EX_MEM_prevPC;
    logic [WORD_LENGTH-1:0] ID_EX_nextPC, EX_MEM_nextPC;
    logic [WORD_LENGTH-1:0] EX_MEM_ReadData1, EX_MEM_ReadData2;
    logic [ADDRESS_PORT_WIDTH-1:0] EX_MEM_ReadReg1, EX_MEM_ReadReg2;

    // --- ID-EX
    always_ff @(posedge CLK) begin
        ID_EX_ValidInstruction <= HazardDetected ? 0 : ID_ValidInstruction;
        ID_EX_Instruction      <= IF_Instruction;
        ID_EX_prevPC           <= IF_ID_PC;
        ID_EX_nextPC           <= IF_PC;
    end

    // --- EX-MEM
    always_ff @(posedge CLK) begin
        EX_MEM_ValidInstruction <= ID_EX_HazardDetected ? 0 : ID_EX_ValidInstruction;
        EX_MEM_Instruction      <= ID_EX_Instruction;
        EX_MEM_prevPC           <= ID_EX_prevPC;
        EX_MEM_nextPC           <= ID_EX_nextPC;
        EX_MEM_ReadData1        <= ID_ReadData1;
        EX_MEM_ReadData2        <= ID_ReadData2;
        EX_MEM_ReadReg1         <= ID_ReadReg1;
        EX_MEM_ReadReg2         <= ID_ReadReg2;
    end

    // --- MEM-WB
    always_ff @(posedge CLK) begin
        rvfi_valid        <= EX_MEM_ValidInstruction;
        rvfi_regs32[0]    <= EX_MEM_Instruction;
        rvfi_regs32[1]    <= EX_MEM_ReadData1;
        rvfi_regs32[2]    <= EX_MEM_ReadData2;
        rvfi_regs32[4]    <= EX_MEM_prevPC;
        rvfi_regs32[5]    <= EX_MEM_nextPC;
        rvfi_regs32[6]    <= MEM_ReadAddress;
        rvfi_regs32[8]    <= MEM_WriteData;
        rvfi_regs5[0]     <= EX_MEM_ReadReg1;
        rvfi_regs5[1]     <= EX_MEM_ReadReg2;
    end

    // --- Combinational assignments
    always_comb begin
        rvfi_i_bool      = rvfi_valid;
        rvfi_i_uint32_0  = rvfi_regs32[0];
        rvfi_i_uint32_1  = rvfi_regs32[1];
        rvfi_i_uint32_2  = rvfi_regs32[2];
        rvfi_i_uint32_3  = WB_WriteData;
        rvfi_i_uint32_4  = rvfi_regs32[4];
        rvfi_i_uint32_5  = rvfi_regs32[5];
        rvfi_i_uint32_6  = rvfi_regs32[6];
        rvfi_i_uint32_7  = MEM_ReadData;
        rvfi_i_uint32_8  = rvfi_regs32[8];

        rvfi_i_uint5_0   = rvfi_regs5[0];
        rvfi_i_uint5_1   = rvfi_regs5[1];
        rvfi_i_uint5_2   = MEM_WriteAddress;

        rvfi_i_uint4     = MEM_mask_bits;
    end

endmodule