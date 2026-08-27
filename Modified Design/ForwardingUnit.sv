module ForwardingUnit(
    input  logic [4:0] EX_rs1, EX_rs2,
    input  logic [4:0] MEM_rd, WB_rd,
    input  logic MEM_RegWrite, WB_RegWrite,

    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

always_comb begin
    // defaults
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // EX hazard (MEM stage)
    if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs1))
        ForwardA = 2'b10;

    if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs2))
        ForwardB = 2'b10;

    // MEM hazard (WB stage)
    if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs1))
        ForwardA = 2'b01;

    if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs2))
        ForwardB = 2'b01;
end

endmodule