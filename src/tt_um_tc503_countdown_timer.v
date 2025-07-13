/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_tc503_countdown_timer (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire rst = ! rst_n;
  assign uio_oe = 8'b0000_0111;
  assign uio_out[7:3] = 5'b0_0000;

  countdown_timer countdown_timer (
    .clk(clk),
    .reset(rst),
    .countdown0(ui_in[7]),
    .enc0_a(ui_in[0]),
    .enc0_b(ui_in[1]),
    .enc1_a(ui_in[2]),
    .enc1_b(ui_in[3]),
    .enc2_a(ui_in[4]),
    .enc2_b(ui_in[5]),
    .pwm0_out(uio_out[0]),
    .pwm1_out(uio_out[1]),
    .pwm2_out(uio_out[2]),
    .dis0_out(uo_out[6:0]),
    .dis0_ctrl(uo_out[7])
  );


  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
