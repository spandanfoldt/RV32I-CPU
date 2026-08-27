`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 23:23:36
// Design Name: 
// Module Name: PC
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


module PC(
    input logic CLK,
    input logic Reset,
    input logic PCWrite,
    
    input logic [31:0] NextPC,
    
    output logic [31:0] PC_out
    );
    
    always_ff @(posedge CLK or posedge Reset) begin
        if(Reset)
            PC_out <= 'h0;
        else if(PCWrite)
            PC_out <= NextPC;
    end
    
    
endmodule
