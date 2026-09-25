module pc(

    input clk,
    input [31:0] pc_next, // immediate/jump 
    input rst,
    output reg [31:0] pc
);

    always@(posedge clk) begin
        if(rst) begin
            pc <= 32'd0;
        end
        else begin
            pc <= pc_next;
        end
    end

endmodule