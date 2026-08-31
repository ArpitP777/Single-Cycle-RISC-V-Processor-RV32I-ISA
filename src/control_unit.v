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

    localparam R   = 7'b0110011;
    localparam I   = 7'b0010011;
    localparam I_L = 7'b0000011;
    localparam I_J = 7'b1100111;
    localparam S   = 7'b0100011;
    localparam B   = 7'b1100011;
    localparam J   = 7'b1101111;

    //ALU ctrl
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam SLL = 3'b101;
    localparam SRL = 3'b110;
    localparam SRA = 3'b111;


    always @(*) begin
        pc_sel = 1'b0;
        result_sel = 1'b0;
        wr_mem = 1'b0;
        alu_ctrl = ADD;
        alu_sel = 1'b0;
        imm_sel = 2'b00;
        wr_reg = 1'b0;

        case(opcode)
            R: begin
                wr_reg = 1'b1;
                case (funct3)
                    3'b000: alu_ctrl = (funct7 == 7'b0000000)?ADD:SUB; // add / sub
                    3'b001: alu_ctrl = SLL;       // sll
                    3'b010: alu_ctrl = SUB;       // slt
                    3'b011: alu_ctrl = SUB;        // sltu
                    3'b100: alu_ctrl = XOR        // xor
                    3'b101: alu_ctrl = (funct7 == 7'b0000000)?SRL:SRA; // srl / sra
                    3'b110: alu_ctrl = OR;          // or
                    3'b111: alu_ctrl = AND;         // and
                    default: alu_ctrl = ADD;
                endcase
            end

            I: begin
                alu_sel = 1'b1;
                wr_reg = 1'b1;
                case (funct3)
                    3'b000: alu_ctrl = ADD;      // addi
                    3'b001: alu_ctrl = SLL;       // slli
                    3'b010: alu_ctrl = SUB;      // slti
                    3'b011: alu_ctrl = SUB;       // sltiu
                    3'b100: alu_ctrl = XOR;      // xori
                    3'b101: alu_ctrl = (funct7 == 7'b0000000)?SRL:SRA; // srli / srai
                    3'b110: alu_ctrl = OR;     // ori
                    3'b111: alu_ctrl = AND;       // andi
                    default: alu_ctrl = ADD;
                endcase
            end

            I_L: begin // load
                result_sel = 1'b1;
                alu_sel = 1'b1;
                wr_reg = 1'b1;
            end

            I_J: begin // jalr
                pc_sel = 1'b1;
                alu_sel = 1'b1;
                wr_reg = 1'b1;
            end

            S: begin // store
                wr_mem = 1'b1;
                alu_sel = 1'b1;
                imm_sel = 2'b01;
            end

            B: begin
                alu_ctrl = SUB;
                imm_sel = 2'b10;
                case (funct3)
                    3'b000: pc_sel = zero;  // beq
                    3'b001: pc_sel = !zero; // bne
                endcase
            end

            J: begin // jal
                pc_sel = 1'b1;
                alu_sel = 1'b1;
                imm_sel = 2'b11;
                wr_reg = 1'b1;
            end
        endcase
    end

endmodule