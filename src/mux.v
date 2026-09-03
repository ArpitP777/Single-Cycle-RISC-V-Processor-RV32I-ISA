module pc_mux(
    input pc_sel,
    input [31:0] pc,
    input [31:0] imm_out,
    output reg [31:0] pc_next
);

    always@(*) begin
        pc_next = pc_sel?(pc + 4):(pc + imm_out);
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