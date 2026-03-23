`timescale 1ns / 1ps

module BranchDecisionUnit(
    input  logic [2:0] funct3,
    input  logic [31:0] A,
    input  logic [31:0] B,
    output logic takeBranch
);

always_comb begin
    case (funct3)
        3'b000: takeBranch = (A == B);                      // BEQ
        3'b001: takeBranch = (A != B);                      // BNE
        3'b100: takeBranch = ($signed(A) < $signed(B));     // BLT
        3'b101: takeBranch = ($signed(A) >= $signed(B));    // BGE
        3'b110: takeBranch = (A < B);                       // BLTU
        3'b111: takeBranch = (A >= B);                      // BGEU
        default: takeBranch = 0;
    endcase
end

endmodule