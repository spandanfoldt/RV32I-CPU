module InstructionMemory(
    input  logic EN,
    input  logic [31:0] InstructionAddress,
    output logic [31:0] ReadInstruction
);

    logic [31:0] memory [0:255];

    initial begin
        $readmemh("Instructions.mem", memory);
    end

    always_comb begin
        if (EN)
            ReadInstruction = memory[InstructionAddress[9:2]];
        else
            ReadInstruction = 32'b0;
    end

endmodule