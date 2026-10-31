module combinational_multiplier (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] p
);


    wire [7:0] m0 = {4'b0000, ({4{b[0]}} & a)};       // b[0] * a
    wire [7:0] m1 = {3'b000,  ({4{b[1]}} & a), 1'b0};  // b[1] * a shifted left 1
    wire [7:0] m2 = {2'b00,   ({4{b[2]}} & a), 2'b0};  // b[2] * a shifted left 2
    wire [7:0] m3 = {1'b0,    ({4{b[3]}} & a), 3'b0};  // b[3] * a shifted left 3

    // Sum partial products combinations
    wire [7:0] s1 = m0 + m1;
    wire [7:0] s2 = s1 + m2;
    wire [7:0] s3 = s2 + m3;

    assign p = s3;

endmodule
