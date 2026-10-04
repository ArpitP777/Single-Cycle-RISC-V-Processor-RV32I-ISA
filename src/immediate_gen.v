module imm_gen(
    input [31:0] instr,
    input [2:0] imm_sel,
    output reg [31:0] imm_out
);

    always@(*) begin
        case(imm_sel) 
            3'b000: imm_out = {{20{instr[31]}}, instr[31:20]};       // I 
            3'b001: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};      // S
            3'b010: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};      // B
            3'b011: imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};      // J
            3'b100: imm_out = {{instr[31:12], 12'b0}};   // U
        endcase
    end

endmodule