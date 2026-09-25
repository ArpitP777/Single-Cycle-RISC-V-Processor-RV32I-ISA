module data_mem(
    input clk,
    input wr_mem,
    input [31:0] alu_out,
    input [31:0] wr_data,
    input [2:0] funct3,
    output reg [31:0] rd_data
);
    //funct3
    localparam mem_size = 1023;
    localparam LB = 3'b000;   // sb
    localparam LH = 3'b001;   // sh
    localparam LW = 3'b010;   // sw
    localparam LBU = 3'b100;
    localparam LHU = 3'b101;

    reg [7:0]mem [0:mem_size];    // 1024x8 = 1KB, byte addressable

    wire [9:0]addr = alu_out[9:0];

    always @(*) begin
        case(funct3)
            LB: rd_data = {{24{mem[addr][7]}}, mem[addr]};                          //byte
            LBU: rd_data = {24'b0, mem[addr]}; 
            LH: rd_data = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};           //half
            LHU: rd_data = {16'b0, mem[addr+1], mem[addr]};
            LW: rd_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};       //full word for last address + 1 th instruction it is fetched from the starting address
            default: rd_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};   
        endcase
    end

    always@(posedge clk) begin
        if(wr_mem) begin
            case (funct3)
                LB: mem[addr] <= wr_data[7:0];
                LH: begin
                        mem[addr] <= wr_data[7:0];
                        mem[addr+1] <= wr_data[15:8];
                    end
                LW: begin
                        mem[addr] <= wr_data[7:0];
                        mem[addr+1] <= wr_data[15:8];
                        mem[addr+2] <= wr_data[23:16];
                        mem[addr+3] <= wr_data[31:24];
                    end
            endcase
        end
    end

endmodule