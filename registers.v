module registers(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    output [31:0] rd_data1,
    output [31:0] rd_data2,
    input w_en,
    input [31:0] w_data,
    input [4:0] rd
);

    reg [31:0] registers [0:31];

    always @(*) begin
        rd_data1 = registers[rs1];
        rd_data2 = registers[rs2];
    end

    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i<32; i++) begin
                registers[i] = 0;
            end
        end
        else if(w_en && rd != 5'd0) begin
            registers[rd] <= w_data;
        end
    end

endmodule