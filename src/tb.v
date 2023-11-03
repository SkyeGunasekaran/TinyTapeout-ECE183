`timescale 1s/1s

module tb;
reg        clk;
reg        rst_n;
reg  [7:0] ui_in;
wire [7:0] uo_out;
wire [7:0] uio_out;

tt_um_LSNN uut (
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_out(uio_out)
);

// Clock generation
always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
end

initial begin

    // Initialize inputs
    clk = 0;
    rst_n = 1;
    ui_in = 8'h00;
    #5 rst_n = 0;
    rst_n = 0;

    #10 ui_in = 8'h10; // Spike up
    #10 ui_in = 8'h20; // Spike up
    #10 ui_in = 8'h10; // Spike up
    #10 ui_in = 8'h00; // Spike down
    #10 ui_in = 8'h10; // Spike up
    #10 ui_in = 8'h99; // Spike up
    #10 ui_in = 8'h00; // Spike down
    #10 ui_in = 8'h00; // Spike down
    #10 ui_in = 8'h10; // Spike up
    #10 ui_in = 8'h10; // Spike up
    #10 ui_in = 8'h00; // Spike down

    $finish;
end


initial begin
    $monitor("time=%0t: current=%h, spike_out=%h, threshold=%h", $time, ui_in, uo_out, uio_out);
    $dumpfile("tb.vcd"); 
    $dumpvars(0, tb);    
end

endmodule
