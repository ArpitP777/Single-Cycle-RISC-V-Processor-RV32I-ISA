module alu(
    input [31:0] a,
    input [31:0] b,
    input [2:0]  alu_ctrl,
    output reg [31:0] alu_out,
    output reg zero
);

    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam SLL = 3'b101;
    localparam SRL = 3'b110;
    localparam SRA = 3'b111;
    // SLU,SLTU will be added later along with BLT,BGE,BLTU,BGEU

    always@(*) begin
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
        endcase
        zero = alu_out == 32'd0;
    end

endmodule