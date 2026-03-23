`timescale 1ns / 1ps
import RISCV_PKG::*;
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2026 20:28:33
// Design Name: 
// Module Name: ControlUnit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit_tb;

    logic [OPCODE_SIZE - 1:0] Opcode;
    logic [2:0] ALUOp;
    logic JumpReg, Jump, Branch, RegSrc1, RegSrc2, UpperImm, RegWrite, MemWrite, MemToReg, RetAddr;
    
    ControlUnit DUT (
        .Opcode(Opcode),
        .ALUOp(ALUOp),
        .JumpReg(JumpReg),
        .Jump(Jump),
        .Branch(Branch),
        .RegSrc1(RegSrc1),
        .RegSrc2(RegSrc2),
        .UpperImm(UpperImm),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RetAddr(RetAddr)
        );
    
    initial begin
        Opcode = 7'b0110011; //R-type
        
        #10;
        Opcode = 7'b0010011; //I-type ALU
        
        #10;
        Opcode = 7'b0000011; //Load
        
        #10;
        Opcode = 7'b0100011; //Store
        
        #10;
        Opcode = 7'b1100011; //Branch
        
        #10;
        Opcode = 7'b1100111; //JALR
        
        #10;
        Opcode = 7'b1101111; //JAL
        
        #10;
        Opcode = 7'b0110111; //LUI
        
        #10;
        Opcode = 7'b0010111; //AUIPC
        
        $finish;
    end
     
endmodule
