module top(
    input [31:0] inst,
    input clk,
    input rst,
    output [31:0] result
);

    reg [31:0] pc_next;
    reg [31:0] pc;
    reg [31:0] alu_out;
    reg [4:0] rs1 = inst[14:12];
    reg [4:0] rs2 = inst[19:15];
    reg [4:0] rd = inst[11:7];
    reg [1:0] pc_sel;
    reg result_sel;
    reg wr_mem;
    reg [2:0] alu_ctrl;
    reg alu_sel;
    reg wr_reg;
    reg [1:0] imm_sel;
    reg zero;
    reg less;
    reg [31:0] rd1;
    reg [31:0] rd2;
    reg [24:0] imm;
    reg [24:0] imm_out;
    reg [31:0] rd_data;

endmodule