`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2026 20:21:08
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory #(parameter DEPTH = 1024)(
    input  logic        EN,
    input  logic [11:2] InstructionAddress,
    output logic [31:0] ReadInstruction 
    );
    
    logic [31:0] Mem [0 : DEPTH - 1];
    
    //LOAD program
    initial begin
        $readmemh("Instructions.mem", Mem);
    end
    
    always_comb begin
        if(EN)
            ReadInstruction = Mem[InstructionAddress];
        else
            ReadInstruction = 'h13; //NOP
        
    end
    
endmodule
