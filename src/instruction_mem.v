module inst_reg(
    input [31:0] pc,
    output [31:0] inst,
);

reg [31:0] mem [0:255];    // 256 x 32 = 1kb

assign inst = mem[pc[9:2]];     // 2^8 = 256

endmodule