`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  reg enc0_a, enc0_b, enc1_a, enc1_b, enc2_a, enc2_b;
  reg countdown0;
  wire pwm0_out, pwm1_out, pwm2_out;
  wire dis0_ctrl;
  wire [6:0] dis0_out;

  assign pwm2_out = uio_out[2];
  assign pwm1_out = uio_out[1];
  assign pwm0_out = uio_out[0];
  assign dis0_ctrl = uo_out[7];
  assign dis0_out = uo_out[6:0];

  assign ui_in[0] = enc0_a;
  assign ui_in[1] = enc0_b;
  assign ui_in[2] = enc1_a;
  assign ui_in[3] = enc1_b;
  assign ui_in[4] = enc2_a;
  assign ui_in[5] = enc2_b;
  assign ui_in[7] = countdown0;

  // Replace tt_um_example with your module name:
  tt_um_tc503_countdown_timer tt_um_tc503_countdown_timer (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule
