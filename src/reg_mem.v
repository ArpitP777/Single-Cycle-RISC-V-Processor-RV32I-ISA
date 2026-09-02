module reg_mem(

    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    output [31:0] rd_1,
    output [31:0] rd_2,
    input wr_reg,
    input [31:0] result,
    input [4:0] rd
    
);

    reg [31:0] registers [0:31];

    always @(*) begin
        rd_1 = registers[rs1];
        rd_2 = registers[rs2];
    end

    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i<32; i++) begin
                registers[i] = 0;
            end
        end
        else if(wr_reg && rd != 5'd0) begin
            registers[rd] <= result;
        end
    end

endmodule