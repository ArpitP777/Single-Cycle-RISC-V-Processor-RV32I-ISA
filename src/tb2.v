`timescale 1ns/1ps

module tb2;

    reg clk = 0;
    reg rst = 1;

    top dut(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    localparam HALT = 32'h0000006f;
    localparam NOP  = 32'h00000013;
    localparam TIMEOUT = 2000;

    integer pass = 0;
    integer fail = 0;
    integer i, cycles;

    task clear_imem;
        for (i=0; i<256; i=i+1)
            dut.inst2.mem[i] = NOP;
    endtask

    task run;
        begin
            rst = 1;
            repeat(2)@(negedge clk);
            rst = 0;

            cycles = 0;
            while(dut.instr !== HALT && cycles < TIMEOUT) begin
                @(negedge clk);
                cycles = cycles + 1;
            end

            if(cycles >= TIMEOUT)
                $display(" TIMEOUT: program never reached halt");
        end
    endtask

    task check_reg(input [4:0] r, input [31:0] exp);
        reg [31:0] got;
        begin
            got = dut.inst3.registers[r];
            if(got === exp) begin
                pass = pass + 1;
                $display(" PASS  x%0d = 0x%h", r, got);
            end
            else begin
                fail = fail + 1;
                $display(" FAIL  x%0d = 0x%h, expected 0x%h", r, got, exp);
            end
        end
    endtask

    initial begin
        $dumpfile("cpu2.vcd");
        $dumpvars(0, tb_lui_auipc_jalr);

        // lui
        $display("\nTEST 1: lui");
        clear_imem;
        dut.inst2.mem[0] = 32'h123450b7;   // lui  x1, 0x12345
        dut.inst2.mem[1] = 32'h67808113;   // addi x2, x1, 0x678
        dut.inst2.mem[2] = 32'hfffff1b7;   // lui  x3, 0xfffff
        dut.inst2.mem[3] = HALT;
        run;
        check_reg(1, 32'h12345000);
        check_reg(2, 32'h12345678);
        check_reg(3, 32'hfffff000);

        // auipc
        $display("\nTEST 2: auipc");
        clear_imem;
        dut.inst2.mem[0] = 32'h00000097;   // auipc x1, 0
        dut.inst2.mem[1] = 32'h00001117;   // auipc x2, 1
        dut.inst2.mem[2] = 32'hfffff197;   // auipc x3, 0xfffff
        dut.inst2.mem[3] = HALT;
        run;
        check_reg(1, 32'h00000000);        // pc = 0
        check_reg(2, 32'h00001004);        // pc = 4
        check_reg(3, 32'hfffff008);        // pc = 8

        // jalr
        $display("\nTEST 3: jalr");
        clear_imem;
        dut.inst2.mem[0] = 32'h01000093;   // addi x1, x0, 16
        dut.inst2.mem[1] = 32'h00008167;   // jalr x2, 0(x1)
        dut.inst2.mem[2] = 32'h06300193;   // addi x3, x0, 99  (skipped)
        dut.inst2.mem[3] = 32'h06300193;   // addi x3, x0, 99  (skipped)
        dut.inst2.mem[4] = 32'h00700213;   // addi x4, x0, 7
        dut.inst2.mem[5] = 32'h00c082e7;   // jalr x5, 12(x1)
        dut.inst2.mem[6] = 32'h06300313;   // addi x6, x0, 99  (skipped)
        dut.inst2.mem[7] = HALT;
        run;
        check_reg(1, 16);
        check_reg(2, 8);                   // link address of first jalr
        check_reg(3, 0);                   // skipped
        check_reg(4, 7);                   // landed on the target
        check_reg(5, 24);                  // link address of second jalr
        check_reg(6, 0);                   // skipped

        $display("\n%0d passed, %0d failed", pass, fail);
        if(fail == 0)
            $display("ALL TESTS PASSED\n");
        else
            $display("%0d TESTS FAILED\n", fail);
        $finish;
    end

endmodule