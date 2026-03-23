`timescale 1ns / 1ps

module ALUControl(
    input  logic [2:0] ALUOp,
    input  logic [2:0] func3,
    input  logic [6:0] func7,
    output logic [3:0] ALUControlout
);

always_comb begin
    case (ALUOp)

        // =========================
        // LOAD / STORE ? ADD
        // =========================
        3'b000: ALUControlout = 4'b0010; // ADD

        // =========================
        // BRANCH ? SUB
        // =========================
        3'b001: ALUControlout = 4'b0011; // SUB

        // =========================
        // R-type & I-type
        // =========================
        3'b010: begin
            case (func3)

                // ADD / SUB / ADDI
                3'b000: begin
                    if (func7 == 7'b0100000)
                        ALUControlout = 4'b0011; // SUB
                    else
                        ALUControlout = 4'b0010; // ADD
                end

                // AND / ANDI
                3'b111: ALUControlout = 4'b0001;

                // OR / ORI
                3'b110: ALUControlout = 4'b0000;

                // XOR / XORI
                3'b100: ALUControlout = 4'b1001;

                // SLL / SLLI
                3'b001: ALUControlout = 4'b1000;

                // SRL / SRA / SRLI / SRAI
                3'b101: begin
                    if (func7 == 7'b0100000)
                        ALUControlout = 4'b1011; // SRA
                    else
                        ALUControlout = 4'b1010; // SRL
                end

                // SLT / SLTI
                3'b010: ALUControlout = 4'b0101;

                // SLTU / SLTIU
                3'b011: ALUControlout = 4'b1101;

                default: ALUControlout = 4'b0010; // safe default = ADD
            endcase
        end

        // =========================
        // LUI
        // =========================
        3'b011: ALUControlout = 4'b1111; // pass B (immediate)

        // =========================
        // DEFAULT
        // =========================
        default: ALUControlout = 4'b0010; // ADD

    endcase
end

endmodule