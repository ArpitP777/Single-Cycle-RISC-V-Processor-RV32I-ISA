module imm_gen(
    input [31:0] instr,
    input [1:0] imm_sel,
    output reg [31:0] imm_out
);

    always@(*) begin
        case(imm_sel) 
            2'b00: imm_out = {{20{instr[31]}}, instr[31:20]};                     // I 
            2'b01: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};         // S
            2'b10: imm_out = {19{instr[31]}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};    // B
            2'b11: imm_out = {11{instr[31]}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};    // J
        endcase
    end

endmodule