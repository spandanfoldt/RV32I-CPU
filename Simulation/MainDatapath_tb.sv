`timescale 1ns / 1ps
import RISCV_PKG::*;

module MainDatapath_tb;

    logic CLK, Reset, EN;
    logic [31:0] sim_time = 0;

    // DUT
    MainDatapath DUT (
        .CLK(CLK),
        .EN(EN),
        .Reset(Reset)
    );

    // Clock generation
    always #5 CLK = ~CLK;

    // Initialize
    initial begin
        CLK = 0;
        Reset = 1;
        EN = 1;
        #10;
        Reset = 0;
    end

    // Simulation runtime
    always @(posedge CLK) begin
        sim_time++;
        if (sim_time > 200) begin
            $display("Simulation Timeout");
            $finish;
        end
    end

    // Waveform dump
    initial begin
        $dumpfile("MainDatapath.vcd");
        $dumpvars(0, MainDatapath_tb);
    end

endmodule