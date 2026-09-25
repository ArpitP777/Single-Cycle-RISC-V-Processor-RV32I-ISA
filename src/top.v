`include "mux.v"

module top(
    input clk,
    input rst,
    output reg [31:0] result
);
    // pc
    wire [31:0] pc_next;
    wire [1:0] pc_sel;
    wire [31:0] pc;

    // instruction memory
    wire [31:0] instr,
    wire [4:0] rs1 = instr[24:20];
    wire [4:0] rs2 = instr[19:15];
    wire [4:0] rd = instr[11:7];

    // alu
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [3:0] alu_ctrl;
    wire [31:0] alu_out;
    wire zero;
    wire less;
    wire [31:0] alu_in;

    // immediate generator
    wire [1:0] imm_sel;
    wire [31:0] imm_out;
    
    // control signals & result
    wire result_sel;
    wire wr_mem;
    wire alu_sel;
    wire wr_wire;
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [6:0] opcode = instr[6:0];
    wire [31:0] rd_data;

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

    wire_mem inst3(
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd_1(rd1),
        .rd_2(rd2),
        .wr_wire(wr_wire),
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
        .wr_wire(wr_wire),
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