module pc_mux(
    input [1:0] pc_sel,
    input [31:0] pc,
    input [31:0] imm_out,
    input [31:0] alu_out,
    output reg [31:0] pc_next
);

    always@(*) begin
        case(pc_sel) 
            2'b01: pc_next <= pc + 4;
            2'b00: pc_next <= pc + imm_out;
            2'b10: pc_next <= alu_out;
            default: pc_next <= pc + 4;
        endcase
    end
endmodule

module alu_mux(
    input alu_sel,
    input [31:0] rd2,
    input [31:0] imm_out,
    output reg [31:0] in_alu
);

    always@(*) begin
        in_alu = alu_sel?(imm_out):(rd2);
    end

endmodule

module result_mux(
    input result_sel,
    input [31:0] alu_out,
    input [31:0] rd_data,
    output reg [31:0] result
);

    always@(*) begin
        result = result_sel?(rd_data):(alu_out);
    end

endmodule