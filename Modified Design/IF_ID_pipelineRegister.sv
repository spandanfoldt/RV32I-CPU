`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2026 22:06:25
// Design Name: 
// Module Name: IF_ID_pipelineRegister
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


module IF_ID_pipelineRegister(
    input  logic            CLK,
    input  logic            Reset,
    input  logic            Wen,
    input  logic            Flush,
    
    input  logic [31:0]     IF_PC,
    input  logic [31:0]     IF_Instruction,
    
    output logic [31:0]     ID_PC,
    output logic [31:0]     ID_Instruction
    );
    
    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            ID_PC <= 0;
            ID_Instruction <= 32'h00000013; //NOP
        end
        
        else if (Flush) begin
            ID_PC <= 0;
            ID_Instruction <= 32'h00000013; //NOP
        end
        
        else if (Wen) begin
            ID_PC <= IF_PC;
            ID_Instruction <= IF_Instruction;
        end
    end
endmodule
