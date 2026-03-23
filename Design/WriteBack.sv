`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2026 19:33:55
// Design Name: 
// Module Name: WriteBack
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
import RISCV_PKG::*;


module WriteBack(input logic CLK, MemToReg,
                 input logic [WORD_LENGTH - 1:0] ReadData, ALUResult,
                 output logic [WORD_LENGTH - 1:0] WriteData
    );
    
    always_comb
        WriteData = (MemToReg) ? ReadData : ALUResult;
    
endmodule
