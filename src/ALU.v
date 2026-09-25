module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0]  alu_ctrl,
    output reg [31:0] alu_out,
    output reg zero,
    output reg less
);

    localparam SUB = 4'b0001;
    localparam ADD = 4'b0000;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLL = 4'b0101;
    localparam SRL = 4'b0110;
    localparam SRA = 4'b0111;
    localparam SLT = 4'b1000;
    localparam SLTU = 4'b1001; 
    
    always@(*) begin
        less = 1'b0;
        zero = 1'b0;
        alu_out = 32'd0;
        case(alu_ctrl)
                ADD: alu_out = a+b;
                SUB: begin
                    alu_out = a-b;
                    zero = !(a-b)?1:0;
                    end
                AND: alu_out = a&b;
                OR: alu_out = a | b;
                XOR: alu_out = a^b;
                SLL: alu_out = a<<b[4:0];
                SRL: alu_out = a>>b[4:0];
                SRA: alu_out = $signed(a)>>>b;
                SLT: begin
                    less = ($signed(a)<$signed(b));
                    alu_out = less?32'b1:32'b0;
                    end 
                SLTU: begin
                    less = (a<b);
                    alu_out = less?32'b1:32'b0;
                    end
        endcase
        zero = alu_out == 32'd0;
    end

endmodule