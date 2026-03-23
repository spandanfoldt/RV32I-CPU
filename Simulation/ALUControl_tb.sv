`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2026 21:19:43
// Design Name: 
// Module Name: ALUControl_tb
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


module ALUControl_tb;
    logic [2:0] ALUOpin, func3;
    logic [6:0] func7;
    logic [3:0] ALUOpOut;
    
    ALUControl DUT (
    .ALUOpin(ALUOpin),
    .func3(func3),
    .func7(func7),
    .ALUOpout(ALUOpOut)
    );
    
    initial begin
        ALUOpin = '0;
        func3 = '0;
        func7 = '0;
        //ALUOpOut = '0;
        
        //  Itype logical 
        ALUOpin = 3'b000; func3 = 3'b110; func7 = 7'b0000000; #10; // OR

        ALUOpin = 3'b000; func3 = 3'b111; func7 = 7'b0000000; #10; // AND

        //  SLT 
        ALUOpin = 3'b000; func3 = 3'b010; func7 = 7'b0000000; #10;

        //  Rtype ADD / SUB 
        ALUOpin = 3'b101; func3 = 3'b000; func7 = 7'b0000000; #10; // ADD

        ALUOpin = 3'b101; func3 = 3'b000; func7 = 7'b0100000; #10; // SUB

        //  Shifts 
        ALUOpin = 3'b101; func3 = 3'b001; func7 = 7'b0000000; #10; // SLL

        ALUOpin = 3'b101; func3 = 3'b101; func7 = 7'b0000000; #10; // SRL

        ALUOpin = 3'b101; func3 = 3'b101; func7 = 7'b0100000; #10; // SRA

        //  XOR 
        ALUOpin = 3'b101; func3 = 3'b100; func7 = 7'b0000000; #10;

        //  Default / invalid 
        ALUOpin = 3'b111; func3 = 3'b111; func7 = 7'b1111111; #10;

        #20;
        $finish;
    end        
    
endmodule
