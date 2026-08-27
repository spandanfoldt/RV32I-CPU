`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2026 20:28:49
// Design Name: 
// Module Name: DataMemory
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


module DataMemory #(parameter DEPTH = 1024)(
    input logic CLK,
    input logic EN,
    
    input logic MemWrite,
    input logic MemRead,
    
    input logic [9:0] Address,
    input logic [31:0] WriteData,
    
    output logic [31:0] ReadData
    );
    
    logic [31:0] Mem [0 : DEPTH - 1];
    
    //READ
    always_comb begin
        if (EN && MemRead)
            ReadData = Mem[Address];
        else
            ReadData = 'b0;
    end
    
    
    //WRITE
    always_ff @(posedge CLK) begin
        if (EN && MemWrite)
            Mem[Address] <= WriteData;
    end
endmodule
