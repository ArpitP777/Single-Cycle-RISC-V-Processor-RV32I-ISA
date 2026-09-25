module inst_mem(
    input [31:0] pc,
    output reg [31:0] inst
);

reg [31:0] mem [0:255];    // 256 x 32 = 1kb

always@(*) begin
    inst <= mem[pc[9:2]];     // 2^8 = 256
end

endmodule