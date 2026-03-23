`timescale 1ns / 1ps
import RISCV_PKG::*;

module RegisterFile(input logic [ADDRESS_PORT_WIDTH-1:0] ReadReg1, ReadReg2, WriteAddress,
                    input logic CLK, Reset, RegWrite,
                    input logic [REG_WIDTH-1:0] WriteData,
                    output logic [REG_WIDTH-1:0] ReadData1, ReadData2
    );
    logic [REG_WIDTH - 1:0] Registers [REG_COUNT - 1:0]  = '{default:0};
    
    always_comb begin
        ReadData1 = Registers[ReadReg1];
        ReadData2 = Registers[ReadReg2];
    end
    
    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset)
            Registers <= '{default:0};
        else begin
            if (RegWrite && (WriteAddress != 5'b0))
                Registers[WriteAddress] <= WriteData;
        end
    end
    
endmodule
