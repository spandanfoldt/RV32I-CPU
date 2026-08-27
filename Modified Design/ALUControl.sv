`timescale 1ns / 1ps

module ALUControl (
    input  logic [2:0] ALUOp,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] ALUControl
);

    always_comb begin

        // Default = ADD
        ALUControl = 4'b0010;

        case (ALUOp)

            // LOAD / STORE
            3'b000: begin
                ALUControl = 4'b0010;       // ADD
            end

            // BRANCH
            // BranchDecisionUnit handles actual comparison.
            3'b001: begin
                ALUControl = 4'b0011;       // SUB
            end

            // R-TYPE
            3'b010: begin
                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            ALUControl = 4'b0011; // SUB
                        else
                            ALUControl = 4'b0010; // ADD
                    end

                    3'b001:
                        ALUControl = 4'b1000;      // SLL

                    3'b010:
                        ALUControl = 4'b0101;      // SLT

                    3'b011:
                        ALUControl = 4'b1101;      // SLTU

                    3'b100:
                        ALUControl = 4'b1001;      // XOR

                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            ALUControl = 4'b1011;  // SRA
                        else
                            ALUControl = 4'b1010;  // SRL
                    end

                    3'b110:
                        ALUControl = 4'b0000;      // OR

                    3'b111:
                        ALUControl = 4'b0001;      // AND

                    default:
                        ALUControl = 4'b0010;

                endcase
            end

            // I-TYPE ALU INSTRUCTIONS
            3'b011: begin
                case (funct3)

                    3'b000:
                        ALUControl = 4'b0010;      // ADDI

                    3'b010:
                        ALUControl = 4'b0101;      // SLTI

                    3'b011:
                        ALUControl = 4'b1101;      // SLTIU

                    3'b100:
                        ALUControl = 4'b1001;      // XORI

                    3'b110:
                        ALUControl = 4'b0000;      // ORI

                    3'b111:
                        ALUControl = 4'b0001;      // ANDI

                    3'b001:
                        ALUControl = 4'b1000;      // SLLI

                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            ALUControl = 4'b1011;  // SRAI
                        else
                            ALUControl = 4'b1010;  // SRLI
                    end

                    default:
                        ALUControl = 4'b0010;

                endcase
            end

            // DEFAULT
            default: begin
                ALUControl = 4'b0010;
            end

        endcase
    end

endmodule