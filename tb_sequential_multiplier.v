`timescale 1ns / 1ps

// File: tb_sequential_multiplier.v
`timescale 1ns / 1ps

module tb_sequential_multiplier();

    reg clk;
    reg rst;
    reg enable;
    reg [3:0] i_md;
    reg [3:0] i_mr;

    wire [7:0] product;
    wire busy;

    // Instantiate Unit Under Test (UUT)
    sequential_multiplier uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .i_md(i_md),
        .i_mr(i_mr),
        .product(product),
        .busy(busy)
    );

    // Clock Generation: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        enable = 0;
        i_md = 0;
        i_mr = 0;

        #20 rst = 0;
        #10;

        // Test 1: 6 * 3 = 18 (0x12)
        i_md = 4'd6;
        i_mr = 4'd3;
        enable = 1;
        #10 enable = 0;
        
        // Wait for busy to clear
        wait(!busy);
        #20;

        // Test 2: 15 * 15 = 225 (0xE1)
        i_md = 4'd15;
        i_mr = 4'd15;
        enable = 1;
        #10 enable = 0;

        wait(!busy);
        #20;

        // Test 3: 9 * 0 = 0
        i_md = 4'd9;
        i_mr = 4'd0;
        enable = 1;
        #10 enable = 0;

        wait(!busy);
        #20;

        $finish;
    end

endmodule

