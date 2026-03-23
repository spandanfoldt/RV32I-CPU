`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2026 21:38:42
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;
    logic [31:0] a, b;
    logic [3:0] ALUOp;
    logic [31:0] out;
    logic ONE;
    
    ALU DUT(.dataA(a), .dataB(b), .ALUOperation(ALUOp), .dataOut(out));
    
    initial begin
        a = 32'd4;
        b = 32'd2;
        
        #10;
        ALUOp = 4'b0000;
        
        #10;
        ALUOp = 4'b0001;
        
        #10;
        ALUOp = 4'b0010;
        
        #10;
        ALUOp = 4'b0011;
        
        #10;
        ALUOp = 4'b0101;
        
        #10;
        ALUOp = 4'b1000;
        
        #10;
        ALUOp = 4'b1001;
        
        #10;
        ALUOp = 4'b1010;
        
        #10;
        ALUOp = 4'b1011;
        
        #10;
        ALUOp = 4'b1101;
    end
    
    
endmodule
