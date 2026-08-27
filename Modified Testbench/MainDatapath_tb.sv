`timescale 1ns / 1ps

module MainDatapath_tb;

    logic CLK;
    logic EN;
    logic Reset;

    logic [31:0] PC_out;

    // DUT
    MainDatapath dut (
        .CLK(CLK),
        .EN(EN),
        .Reset(Reset),
        .PC_out(PC_out)
    );

    // 10 ns clock
    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        // Initial values
        Reset = 1'b1;
        EN    = 1'b0;

        // Hold reset for 20 ns
        #20;

        Reset = 1'b0;
        EN    = 1'b1;

        // Run CPU
        #300;

        $finish;
    end

    // Monitor PC
    initial begin
        $monitor("Time=%0t | Reset=%b | EN=%b | PC=%h",
                 $time, Reset, EN, PC_out);
    end

endmodule