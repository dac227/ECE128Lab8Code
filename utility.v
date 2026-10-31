module bcd_7seg_decoder(input [3:0] bcd, output reg [6:0] seg);

always @(bcd) begin
    case(bcd)
        4'd0: seg = 7'b1000000;
        4'd1: seg = 7'b1111001;
        4'd2: seg = 7'b0100100;
        4'd3: seg = 7'b0110000;
        4'd4: seg = 7'b0011001;
        4'd5: seg = 7'b0010010;
        4'd6: seg = 7'b0000010;
        4'd7: seg = 7'b1111000;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0010000;
        default: seg = 7'b1111111;
    endcase
   end
endmodule

module bdc12to16bit(input  wire clk, input  wire rst, input wire en, input  wire [11:0] binary, output reg  [15:0] bcd, output reg rdy);

    // State Encoding
    localparam IDLE  = 3'd0;
    localparam SETUP = 3'd1;
    localparam ADD   = 3'd2;
    localparam SHIFT = 3'd3;
    localparam DONE  = 3'd4;

    reg [2:0]  state;
    reg [27:0] bcd_data;     // [27:24]=Thousands, [23:20]=Hundreds, [19:16]=Tens, [15:12]=Ones, [11:0]=Binary
    reg [3:0]  sh_counter;   // Counts up to 12 shifts
    reg [1:0]  add_counter;  // Cycles through 4 BCD digits (0 to 3)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            bcd_data    <= 28'b0;
            sh_counter  <= 4'd0;
            add_counter <= 2'd0;
            rdy         <= 1'b0;
            bcd         <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    if (en) begin
                        state <= SETUP;
                    end
                end

                SETUP: begin
                    bcd_data    <= {16'b0, binary};
                    sh_counter  <= 4'd0;
                    add_counter <= 2'd0;
                    rdy         <= 1'b0;
                    state       <= ADD;
                end

                ADD: begin
                    // Check each BCD digit sequentially; if > 4, add 3
                    case (add_counter)
                        2'd0: begin
                            if (bcd_data[15:12] > 4)
                                bcd_data[15:12] <= bcd_data[15:12] + 4'd3;
                            add_counter <= add_counter + 1'b1;
                        end
                        2'd1: begin
                            if (bcd_data[19:16] > 4)
                                bcd_data[19:16] <= bcd_data[19:16] + 4'd3;
                            add_counter <= add_counter + 1'b1;
                        end
                        2'd2: begin
                            if (bcd_data[23:20] > 4)
                                bcd_data[23:20] <= bcd_data[23:20] + 4'd3;
                            add_counter <= add_counter + 1'b1;
                        end
                        2'd3: begin
                            if (bcd_data[27:24] > 4)
                                bcd_data[27:24] <= bcd_data[27:24] + 4'd3;
                            add_counter <= 2'd0;
                            state       <= SHIFT;
                        end
                    endcase
                end

                SHIFT: begin
                    bcd_data   <= bcd_data << 1;     // Shift entire register left by 1
                    sh_counter <= sh_counter + 1'b1;

                    if (sh_counter == 4'd11) begin   // 12 shifts complete (0 through 11)
                        state <= DONE;
                    end else begin
                        state <= ADD;
                    end
                end

                DONE: begin
                    rdy   <= 1'b1;
                    bcd   <= bcd_data[27:12];        // Extract final 16-bit BCD result
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 02:03:59 PM
// Design Name: 
// Module Name: smallCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 01:42:36 PM
// Design Name: 
// Module Name: largeCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module t_ff (input  wire clk, input  wire rst_n, wire t, output reg  q);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;
        end else begin
            if (t)
                q <= ~q;
            else
                q <= q;
        end
    end

endmodule

module smallCounter (input  wire clk, input  wire rst_n, output wire [1:0] q);

    wire [1:0] t;

    // Toggle logic equations
    assign t[0]  = 1'b1;
    assign t[1]  = q[0];
    
    t_ff ff0 (.clk(clk), .rst_n(rst_n), .t(t[0]), .q(q[0]));
    t_ff ff1 (.clk(clk), .rst_n(rst_n), .t(t[1]), .q(q[1]));

endmodule


module decoder2to4(input [1:0] in, output reg [3:0] out);

    always @(*) begin
        case(in)
            2'b00: out = 4'b1110;
            2'b01: out = 4'b1101;
            2'b10: out = 4'b1011;
            2'b11: out = 4'b0111;
            default: out = 4'b1110;
        endcase
    end
endmodule

module mux4to1(input [15:0] bdcInput, [3:0] decoderInput, output reg [3:0] anodeOutput);

    always @(*) begin
        case(decoderInput)
            4'b1110: anodeOutput = bdcInput[3:0];
            4'b1101: anodeOutput = bdcInput[7:4];
            4'b1011: anodeOutput = bdcInput [11:8];
            4'b0111: anodeOutput = bdcInput [15:12];
        endcase
    end
endmodule


