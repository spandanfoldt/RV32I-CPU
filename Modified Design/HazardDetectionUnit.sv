`timescale 1ns / 1ps

module HazardDetectionUnit(
    input  logic [4:0] ID_rs1,
    input  logic [4:0] ID_rs2,
    input  logic [4:0] EX_rd,
    input  logic       EX_MemRead,

    output logic PCWrite,
    output logic IF_ID_Write,
    output logic ControlMuxSel
);

always_comb begin
    // default (no hazard)
    PCWrite       = 1'b1;
    IF_ID_Write   = 1'b1;
    ControlMuxSel = 1'b0;

    // load-use hazard
    if (EX_MemRead &&
       ((EX_rd == ID_rs1) || (EX_rd == ID_rs2)) &&
        (EX_rd != 5'd0)) begin

        PCWrite       = 1'b0;
        IF_ID_Write   = 1'b0;
        ControlMuxSel = 1'b1;
    end
end

endmodule