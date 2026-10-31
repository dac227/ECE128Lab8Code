`timescale 1ns / 1ps

// File: tb_combinational_multiplier.v

module tb_combinational_multiplier();

    // Inputs
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [7:0] p;

    // Instantiate Unit Under Test (UUT)
    combinational_multiplier uut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        // Monitor output changes in simulation console
        $monitor("Time=%0t ps | a=%d (%b), b=%d (%b) -> p=%d (0x%h)", 
                 $time, a, a, b, b, p, p);

        // Initialize inputs
        a = 4'd0;
        b = 4'd0;
        #10;

        // Test 1: 6 * 3 = 18 (0x12)
        a = 4'd6;
        b = 4'd3;
        #10;
        if (p !== 8'd18) $error("Test 1 Failed: Expected 18, got %d", p);

        // Test 2: 15 * 15 = 225 (0xE1)
        a = 4'd15;
        b = 4'd15;
        #10;
        if (p !== 8'd225) $error("Test 2 Failed: Expected 225, got %d", p);

        // Test 3: 9 * 0 = 0
        a = 4'd9;
        b = 4'd0;
        #10;
        if (p !== 8'd0) $error("Test 3 Failed: Expected 0, got %d", p);

        // Test 4: Maximum single-bit tests (e.g., 1 * 8 = 8)
        a = 4'd1;
        b = 4'd8;
        #10;
        if (p !== 8'd8) $error("Test 4 Failed: Expected 8, got %d", p);

        $display("All tests completed.");
        $finish;
    end

endmodule
