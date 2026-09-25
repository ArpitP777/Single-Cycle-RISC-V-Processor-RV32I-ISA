`include "mux.v"

module top(
    input [31:0] instr,
    input clk,
    input rst,
    output [31:0] result
);
    // pc
    reg [31:0] pc_next;
    reg [1:0] pc_sel;
    reg [31:0] pc;

    // instruction memory
    reg [4:0] rs1 = inst[24:20];
    reg [4:0] rs2 = inst[19:15];
    reg [4:0] rd = inst[11:7];

    // alu
    reg [31:0] rd1;
    reg [31:0] rd2;
    reg [2:0] alu_ctrl;
    reg [31:0] alu_out;
    reg zero;
    reg less;
    reg [31:0] alu_in;

    // immediate generator
    reg [24:0] imm;
    reg [1:0] imm_sel;
    reg [24:0] imm_out;
    
    // control signals & result
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

    pc inst1(
        .clk(clk),
        .pc_next(pc_next),
        .rst(rst),
        .pc(pc)
    );

    inst_mem inst2(
        .pc(pc),
        .inst(instr)
    );

    reg_mem inst3(
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd_1(rd1),
        .rd_2(rd2),
        .wr_reg(wr_reg),
        .result(result),
        .rd(rd),
        .rst(rst)
    );

    imm_gen inst4(
        .instr(instr),
        .imm_sel(imm_sel),
        .imm_out(imm_out)
    );

    cu inst5(
        .funct7(funct7),
        .funct3(funct3),
        .opcode(opcode),
        .pc_sel(pc_sel),
        .result_sel(result_sel),
        .wr_mem(wr_mem),
        .alu_ctrl(alu_ctrl),
        .alu_sel(alu_sel),
        .imm_sel(imm_sel),
        .wr_reg(wr_reg),
        .zero(zero),
        .less(less)
    );

    alu inst6(
        .a(rd1),
        .b(alu_in),
        .alu_ctrl(alu_ctrl),
        .alu_out(alu_out),
        .zero(zero),
        .less(less)
    );

    data_mem inst7(
        .clk(clk),
        .wr_mem(wr_mem),
        .alu_out(alu_out),
        .wr_data(rd2),
        .funct3(funct3),
        .rd_data(rd_data)
    );

endmodule