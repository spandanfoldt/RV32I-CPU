module ControlUnit(
    input  logic [6:0] Opcode,
    input  logic ONE,

    output logic [2:0] ALUOp,
    output logic RegWrite, MemWrite, MemRead,
    output logic MemToReg, imm,
    output logic Branch,
    output logic Jump,
    output logic JALR
);

always_comb begin
    // defaults
    ALUOp    = 3'b000;
    RegWrite = 0;
    MemWrite = 0;
    MemRead  = 0;
    MemToReg = 0;
    imm      = 0;
    Branch   = 0;
    Jump     = 0;
    JALR     = 0;

    case (Opcode)

        7'b0110011: begin // R-type
            RegWrite = 1;
            ALUOp    = 3'b010;
        end

        7'b0010011: begin // I-type
            RegWrite = 1;
            ALUOp    = 3'b011;
            imm      = 1;
        end

        7'b0000011: begin // LOAD
            RegWrite = 1;
            MemRead  = 1;
            MemToReg = 1;
            imm      = 1;
        end

        7'b0100011: begin // STORE
            MemWrite = 1;
            imm      = 1;
        end

        7'b1100011: begin // BRANCH
            Branch = 1;
            ALUOp  = 3'b001;
        end

        7'b1101111: begin // JAL
            RegWrite = 1;
            Jump     = 1;
        end

        7'b1100111: begin // JALR
            RegWrite = 1;
            Jump     = 1;
            JALR     = 1;
            imm      = 1;
        end

        7'b0110111: begin // LUI
            RegWrite = 1;
        end

        7'b0010111: begin // AUIPC
            RegWrite = 1;
        end

    endcase
end

endmodule