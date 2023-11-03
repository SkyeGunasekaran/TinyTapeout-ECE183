`include "tt_um_LSNN.v"
`timescale 1s/1ns
module tb_tt_um_LSNN;

  reg       clk;
  reg       rst_n;
  reg [7:0] ui_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the module under test
  tt_um_LSNN dut (
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_out(uio_out),
    .uio_in(8'b0), // Unused input, set to 0
    .ena(1'b0),    // Unused input, set to 0
    .uio_oe(uio_oe) // Unused output, not monitored
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    $dumpfile("dump.vcd"); // VCD file for simulation waveform

    clk = 0;
    rst_n = 0;
    
    // Reset
    rst_n = 0;
    #10 rst_n = 1;

    // Apply different current values
    ui_in = 8'h02;
    #100; // Run simulation for a while
    ui_in = 8'h21;
    #100;
    ui_in = 8'h90;
    #100;
    ui_in = 8'h02;
    #100;
    ui_in = 8'h00;
    #100;
    ui_in = 8'h10;
    #100;
    ui_in = 8'h23;
    #100;
    ui_in = 8'h98;
    #100;
    ui_in = 8'h00;
    #100;
    ui_in = 8'h00;
    #100;

    // Monitor signals
    $display("Time: %t | Current: %h | Threshold: %h | State: %h | Adaptation: %h", $time, ui_in, uio_out, uo_out, dut.adaptation);

    // Run the simulation for a few more clock cycles
    #50 $finish;
  end

initial begin
  $dumpvars(0, tb_tt_um_LSNN); // Dump all variables
end

initial $monitor("Time: %t | Current: %h | Threshold: %h | State: %h | Adaptation: %h", $time, ui_in, uio_out, uo_out, dut.adaptation);

endmodule
