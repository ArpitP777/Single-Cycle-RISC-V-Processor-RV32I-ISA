module cu(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg pc_sel,
    output reg result_sel,
    output reg wr_mem,
    output reg [2:0] alu_ctrl,
    output reg alu_sel,
    output reg [1:0] imm_sel,
    output reg wr_reg,
    input zero
);
    localparam R = 7'b0110011;
    localparam I = 7'b0010011;
    localparam I_L = 7'b0000011;
    localparam I_J = 7'b1100111;
    localparam S = 7'b0100011;
    localparam B = 7'b1100011;
    localparam J = 7'b1101111;

    always@(*) begin
        case(opcode)
            R: begin
                pc_sel = 1'b1;
                result_sel = 1'b0;
                wr_mem = 1'b0;
                alu_sel = 1'b0;
                imm_sel = XX;
                wr_reg = 1'b1;
                case(funct7)
                    
                endcase
            end
        endcase
    end

endmodule