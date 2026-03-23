module ALU (
    input  logic [31:0] operandA,
    input  logic [31:0] operandB,
    input  logic [3:0]  ALUControl,
    output logic [31:0] Result,
    output logic        Zero
);

always_comb begin
    unique case (ALUControl)

        //  Arithmetic
        4'b0010: Result = operandA + operandB; // ADD
        4'b0011: Result = operandA - operandB; // SUB

        //  Logical
        4'b0000: Result = operandA | operandB; // OR
        4'b0001: Result = operandA & operandB; // AND
        4'b1001: Result = operandA ^ operandB; // XOR

        //  Comparison
        4'b0101: Result = ($signed(operandA) < $signed(operandB)) ? 32'd1 : 32'd0; // SLT
        4'b1101: Result = (operandA < operandB) ? 32'd1 : 32'd0; // SLTU

        //  SHIFT OPERATIONS (RV32I CORRECT)

        4'b1000: Result = operandA << operandB[4:0];  
        // SLL / SLLI

        4'b1010: Result = operandA >> operandB[4:0];  
        // SRL / SRLI (logical)

        4'b1011: Result = $signed(operandA) >>> operandB[4:0];  
        // SRA / SRAI (arithmetic)

        //  Default (illegal)
        default: Result = 32'd0;

    endcase
end

//  Zero flag (used in branch)
assign Zero = (Result == 32'd0);

endmodule