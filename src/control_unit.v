module cu(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,

    output reg [1:0] pc_sel,
    output reg result_sel,
    output reg wr_mem,
    output reg [3:0] alu_ctrl,
    output reg alu_sel,
    output reg [1:0] imm_sel,
    output reg wr_reg,

    input zero,
    input less
);

    localparam R = 7'b0110011;
    localparam I = 7'b0010011;
    localparam I_L = 7'b0000011;
    localparam I_J = 7'b1100111;
    localparam S = 7'b0100011;
    localparam B = 7'b1100011;
    localparam J = 7'b1101111;

    //ALU ctrl
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLL = 4'b0101;
    localparam SRL = 4'b0110;
    localparam SRA = 4'b0111;
    localparam SLT = 4'b1000;
    localparam SLTU = 4'b1001;  


    always @(*) begin
        pc_sel = 2'b01;
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
                    3'b010: alu_ctrl = SLT;       // slt
                    3'b011: alu_ctrl = SLTU;        // sltu
                    3'b100: alu_ctrl = XOR;       // xor
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
                    3'b010: alu_ctrl = SLT;      // slti
                    3'b011: alu_ctrl = SLTU;       // sltiu
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
                alu_ctrl = ADD;
            end

            I_J: begin // jal
                pc_sel = 2'b00;
                alu_sel = 1'b1;
                wr_reg = 1'b1;
            end

            S: begin // store
                wr_mem = 1'b1;
                alu_sel = 1'b1;
                imm_sel = 2'b01;
                alu_ctrl = ADD;
            end

            B: begin    
                imm_sel = 2'b10;
                case (funct3)
                    3'b000: begin
                        pc_sel = (zero)?2'b01:2'b00;  // beq
                        alu_ctrl = SUB;
                    end
                    3'b001: begin
                        pc_sel = (zero)?2'b01:2'b00;  // bne
                        alu_ctrl = SUB;
                    end
                    3'b100: begin
                        pc_sel = (less)?2'b00:2'b01;  // blt
                        alu_ctrl = SLT;
                    end
                    3'b101: begin
                        pc_sel = (less)?2'b01:2'b00;  //bge
                        alu_ctrl = SLT;
                    end
                    3'b110: begin
                        pc_sel = (less)?2'b00:2'b01;  //bltu
                        alu_ctrl = SLTU;
                    end
                    3'b111: begin
                        pc_sel = (less)?2'b01:2'b00;  //bgeu
                        alu_ctrl = SLTU;
                    end
                endcase
            end

            J: begin // jalr
                pc_sel = 2'b10;
                alu_sel = 1'b1;
                imm_sel = 2'b11;
                wr_reg = 1'b1;
            end
        endcase
    end

endmodule