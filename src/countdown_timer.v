`default_nettype none
`timescale 1ns/1ns
module countdown_timer (
    input clk,
    input reset,
    input countdown0,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out,
    output reg [6:0] dis0_out,
    output dis0_ctrl
);
    wire enc0_a_db, enc0_b_db;
    wire enc1_a_db, enc1_b_db;
    wire enc2_a_db, enc2_b_db;
    wire min_chk0;
    wire [7:0] enc0, enc1, enc2;
    reg [7:0] enc0_C, enc1_C, enc2_C;
    reg [3:0] enc0_H, enc0_L;
/***
    always @(*) begin
        enc0_H <= enc0[7:4];
	enc0_L <= enc0[3:0];
    end
***/
    always @(posedge clk) begin
	if (reset) begin
	    enc0_C <= 0;
	    enc1_C <= 0;
	    enc2_C <= 0;
	    enc0_H <= 0;
	    enc0_L <= 0;
        end else if (countdown0 == 1'b1) begin
	    if (min_chk0) begin
	        enc0_C <= enc0_C - 1;
	        enc0_H <= enc0_C[7:4];
	        enc0_L <= enc0_C[3:0];
	    end
	end else begin
	    enc0_C <= enc0;
	    enc0_H <= enc0[7:4];
	    enc0_L <= enc0[3:0];
	end
    end

    // debouncers, 2 for each encoder
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .button(enc0_a), .debounced(enc0_a_db));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .button(enc0_b), .debounced(enc0_b_db));
    debounce #(.HIST_LEN(8)) debounce1_a(.clk(clk), .reset(reset), .button(enc1_a), .debounced(enc1_a_db));
    debounce #(.HIST_LEN(8)) debounce1_b(.clk(clk), .reset(reset), .button(enc1_b), .debounced(enc1_b_db));

    debounce #(.HIST_LEN(8)) debounce2_a(.clk(clk), .reset(reset), .button(enc2_a), .debounced(enc2_a_db));
    debounce #(.HIST_LEN(8)) debounce2_b(.clk(clk), .reset(reset), .button(enc2_b), .debounced(enc2_b_db));

    // encoders
    encoder #(.WIDTH(8)) encoder0(.clk(clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0));
    encoder #(.WIDTH(8)) encoder1(.clk(clk), .reset(reset), .a(enc1_a_db), .b(enc1_b_db), .value(enc1));
    encoder #(.WIDTH(8)) encoder2(.clk(clk), .reset(reset), .a(enc2_a_db), .b(enc2_b_db), .value(enc2));

    // pwm modules
    pwm #(.WIDTH(8)) pwm0(.clk(clk), .reset(reset), .out(pwm0_out), .level(enc0));
    pwm #(.WIDTH(8)) pwm1(.clk(clk), .reset(reset), .out(pwm1_out), .level(enc1));
    pwm #(.WIDTH(8)) pwm2(.clk(clk), .reset(reset), .out(pwm2_out), .level(enc2));

    // seven segment modules
    seven_segment seven_segment0(.clk(clk), .reset(reset), .load(1'b1), .ten_count(enc0_H), .unit_count(enc0_L), .segments(dis0_out), .digit(dis0_ctrl));    

    // clock divider modules
    clock_divider clock_divider0(.clk(clk), .reset(countdown0), .min_tick(min_chk0));

endmodule
