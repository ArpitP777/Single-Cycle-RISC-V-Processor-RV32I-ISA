module pc_inc(
    input [32:0] pc,
    output reg [32:0] pc_plus4
);
    assign pc_plus4 = pc + 4;
    
endmodule