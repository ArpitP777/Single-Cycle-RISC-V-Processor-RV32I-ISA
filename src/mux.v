module pc_inc(
    input pc_sel,
    input [32:0] pc,
    input [32:0] imm_out,
    output reg [32:0] pc_next
);

    always@(*) begin
        pc_next = pc_sel?(pc + 4):(pc + imm_out);
    end
endmodule

module alu_in(
    input alu_sel,
    input [32:0] rd2,
    input [32:0] imm_out,
    output reg [32:0] in_alu
);

    always@(*) begin
        in_alu <= alu_sel?(imm_out):(rd2);
    end

endmodule

