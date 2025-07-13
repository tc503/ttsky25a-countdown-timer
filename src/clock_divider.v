`default_nettype none
`timescale 1ns/1ps
module clock_divider (
    input clk,
    input reset,
    output reg min_tick 
);
    // Adjust max_count for a 1-minute period based on your system clock frequency
//    localparam MAX_COUNT = 960000000; // (clock_frequency * 60) - 1 
//    localparam BITS = 30; 
//    reg [BITS-1:0] counter; // BITS depends on MAX_COUNT
    reg [30-1:0] counter; // BITS depends on MAX_COUNT

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            min_tick <= 0;
        end else if (counter == 960000000) begin
            counter <= 0;
            min_tick <= 1'b1;
        end else begin
            counter <= counter + 1;
            min_tick <= 1'b0;
        end
    end
endmodule
