`timescale 1ns/1ps

module tb;

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

    reg [31:0] fib [0:9];

    task clear_imem;
        for(i=0; i<256; i=i+1)
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

    function [31:0] read_word(input integer addr);
        read_word = {
        dut.inst7.mem[addr+3],
        dut.inst7.mem[addr+2],
        dut.inst7.mem[addr+1],
        dut.inst7.mem[addr]
        };
    endfunction

    task check_reg(input [4:0] r, input [31:0] exp);
        reg [31:0] got;
        begin
            got = dut.inst3.registers[r];
            if(got === exp) begin
                pass = pass+1;
                $display(" PASS x%0d = %0d", r, got);
            end
            else begin
                fail = fail+1;
                $display(" FAIL x%0d = %0d, expected %0d", r, got, exp);
            end
        end
    endtask

    task check_mem(input integer addr, input [31:0] exp);
        reg [31:0] got;
        begin
            got = read_word(addr);
            if(got === exp) begin
                pass = pass+1;
                $display(" PASS mem[%0d] = %0d", addr, got);
            end
            else begin
                fail = fail + 1;
                $display(" FAIL mem[%0d] = %0d, expected %0d", addr, got, exp);
            end
        end
    endtask

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb);

        fib[0] = 0; fib[1] = 1; fib[2] = 1; fib[3] = 2; fib[4] = 3;
        fib[5] = 5; fib[6] = 8; fib[7] = 13; fib[8] = 21; fib[9] = 34;

        // add
        $display("\nTEST 1: add 25 + 17");
        clear_imem;
        dut.inst2.mem[0] = 32'h01900093;   // addi x1, x0, 25
        dut.inst2.mem[1] = 32'h01100113;   // addi x2, x0, 17
        dut.inst2.mem[2] = 32'h002081b3;   // add x3, x1, x2
        dut.inst2.mem[3] = 32'h00302023;   // sw x3, 0(x0)
        dut.inst2.mem[4] = 32'h00002203;   // lw x4, 0(x0)
        dut.inst2.mem[5] = HALT;
        run;
        check_reg(1, 25);
        check_reg(2, 17);
        check_reg(3, 42);
        check_reg(4, 42);
        check_mem(0, 42);

        // gcd
        $display("\nTEST 2: gcd(48, 18)");
        clear_imem;
        dut.inst2.mem[0] = 32'h03000093;   // addi x1, x0, 48
        dut.inst2.mem[1] = 32'h01200113;   // addi x2, x0, 18
        dut.inst2.mem[2] = 32'h00208c63;   // beq x1, x2, done
        dut.inst2.mem[3] = 32'h0020c663;   // blt x1, x2, less
        dut.inst2.mem[4] = 32'h402080b3;   // sub x1, x1, x2
        dut.inst2.mem[5] = 32'hff5ff06f;   // jal x0, loop
        dut.inst2.mem[6] = 32'h40110133;   // sub x2, x2, x1
        dut.inst2.mem[7] = 32'hfedff06f;   // jal x0, loop
        dut.inst2.mem[8] = HALT;
        run;
        check_reg(1, 6);
        check_reg(2, 6);

        // fibonacci
        $display("\nTEST 3: first 10 fibonacci numbers");
        clear_imem;
        dut.inst2.mem[0]  = 32'h00000093;  // addi x1, x0, 0
        dut.inst2.mem[1]  = 32'h00100113;  // addi x2, x0, 1
        dut.inst2.mem[2]  = 32'h00000193;  // addi x3, x0, 0
        dut.inst2.mem[3]  = 32'h00a00213;  // addi x4, x0, 10
        dut.inst2.mem[4]  = 32'h00000293;  // addi x5, x0, 0
        dut.inst2.mem[5]  = 32'h0011a023;  // sw x1, 0(x3)
        dut.inst2.mem[6]  = 32'h00208333;  // add x6, x1, x2
        dut.inst2.mem[7]  = 32'h00010093;  // addi x1, x2, 0
        dut.inst2.mem[8]  = 32'h00030113;  // addi x2, x6, 0
        dut.inst2.mem[9]  = 32'h00418193;  // addi x3, x3, 4
        dut.inst2.mem[10] = 32'h00128293;  // addi x5, x5, 1
        dut.inst2.mem[11] = 32'hfe42c4e3;  // blt x5, x4, loop
        dut.inst2.mem[12] = HALT;
        run;

        $write(" series: ");
        for(i=0; i<10; i=i+1)
            $write("%0d ", read_word(i*4));
            $write("\n");

        check_reg(5, 10);
        for(i=0; i<10; i=i+1)
            check_mem(i*4, fib[i]);

        $display("\n%0d passed, %0d failed", pass, fail);
        if(fail == 0)
            $display("ALL TESTS PASSED\n");
        else
            $display("%0d TESTS FAILED\n", fail);
        $finish;
    end

endmodule    