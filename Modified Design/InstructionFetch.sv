`timescale 1ns / 1ps

module InstructionFetch(
    input  logic CLK,
    input  logic EN,
    input  logic Reset,
    input  logic PCWrite,
    input  logic [31:0] PC_in,

    output logic [31:0] Instruction,
    output logic [31:0] PC
);

logic [31:0] PC_reg;
logic [31:0] InstrMem [0:255];

// ? HARD-CODED FILE (SYNTHESIZABLE STYLE)
initial begin
    $readmemh("Instructions.mem", InstrMem);
end

// PC update
always_ff @(posedge CLK or posedge Reset) begin
    if (Reset)
        PC_reg <= 0;
    else if (EN && PCWrite)
        PC_reg <= PC_in;
end

assign PC = PC_reg;
assign Instruction = InstrMem[PC_reg[9:2]];

endmodule