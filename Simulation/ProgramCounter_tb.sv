`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 16:58:54
// Design Name: 
// Module Name: ProgramCounter_tb
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


module ProgramCounter_tb;
    
    // inputs
    logic CLK;
    logic Reset, JumpReg, Jump, Branch, ONE;
    logic [31:0] ImmediateOutput, ReadData1;
    
    //outputs
    logic [31:0] PC = 0;
    
    ProgramCounter DUT (
        .CLK(CLK),
        .Reset(Reset),
        .JumpReg(JumpReg),
        .Jump(Jump),
        .Branch(Branch),
        .ONE(ONE),
        .ImmediateOutput(ImmediateOutput),
        .ReadData1(ReadData1),
        .PC(PC)
    );
    
    always #5 CLK = ~CLK;
    
    initial begin
    
        CLK = 0;
        Reset = 1;
        JumpReg = 0;
        Jump = 0;
        Branch = 0;
        ONE = 0;
        ImmediateOutput = 32'd20;
        ReadData1 = 32'd300;
        Reset = 0;
        
        #10;
        $display("Final PC after 3 cycles = %0d", PC);
        
        $finish;
    end

endmodule
