module alu(
    input [31:0] a,
    input [31:0] b,
    input [2:0]  alu_ctrl,
    output reg [31:0] alu_out,
    output zero
);

    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam SLL = 3'b101;
    localparam SRL = 3'b110;
    localparam SRA = 3'b111;

endmodule