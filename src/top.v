module top(
    input [31:0] inst,
    input clk,
    input rst,
    output [31:0] result
);

    reg [31:0] pc_next;
    reg [1:0] pc_sel;
    reg [31:0] pc;

    reg [4:0] rs1 = inst[24:20];
    reg [4:0] rs2 = inst[19:15];
    reg [4:0] rd = inst[11:7];

    reg [31:0] rd1;
    reg [31:0] rd2;
    reg [2:0] alu_ctrl;
    reg [31:0] alu_out;
    reg zero;
    reg less;
    reg [31:0] alu_in;

    reg [24:0] imm;
    reg [1:0] imm_sel;
    reg [24:0] imm_out;
    
    reg result_sel;
    reg wr_mem;
    reg alu_sel;
    reg wr_reg;
    reg [2:0] funct3 = inst[14:12];
    reg [6:0] funct7 = inst[31:25];
    reg [6:0] opcode = inst[6:0];
    reg [31:0] rd_data;

    pc_mux pmux(
        .pc_sel(pc_sel),
        .pc(pc),
        .imm_out(imm_out),
        .alu_out(alu_out),
        .pc_next(pc_next)
    );

    alu_mux alumux(
        .alu_sel(alu_sel),
        .rd2(rd2),
        .imm_out(imm_out),
        .in_alu(alu_in)
    );

    result_mux resultmux(
        .result_sel(result_sel),
        .alu_out(alu_out),
        .rd_data(rd_data),
        .result(result)
    );

    

endmodule