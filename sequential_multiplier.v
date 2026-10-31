
module sequential_multiplier (
    input clk,
    input rst,
    input enable,
    input [3:0] i_md, // Multiplicand
    input [3:0] i_mr, // Multiplier
    output reg [7:0] product,
    output reg busy
);

    // State definitions
    localparam IDLE     = 2'b00;
    localparam PROCESS  = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [7:0] rs;     // Running sum
    reg [7:0] md;     // Shifted multiplicand
    reg [2:0] i;      // Bit index/counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            product <= 8'd0;
            rs      <= 8'd0;
            md      <= 8'd0;
            i       <= 3'd0;
            busy    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 1'b0;
                    if (enable) begin
                        busy    <= 1'b1;
                        rs      <= 8'd0;
                        i       <= 3'd0;
                        md      <= {4'b0000, i_md}; // Zero-extend multiplicand
                        state   <= PROCESS;
                    end
                end

                PROCESS: begin
                    // Test current bit of multiplier i_mr[i]
                    if (i_mr[i]) begin
                        rs <= rs + md;
                    end
                    
                    md <= md << 1; // Shift multiplicand left

                    if (i == 3) begin
                        state <= DONE;
                    end else begin
                        i <= i + 1;
                    end
                end

                DONE: begin
                    // Final assignment matching ASM flowchart flow
                    if (i_mr[3]) begin
                        product <= rs; // Updated running sum
                    end else begin
                        product <= rs;
                    end
                    busy  <= 1'b0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule

