module pc(
    input clk,
    input [31:0] pc_next, // immediate or jump 
    input rst,
    output [31:0] pc
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