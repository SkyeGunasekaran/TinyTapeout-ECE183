`default_nettype none

module tt_um_LSNN (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Reset signal
    input  wire [7:0] ui_in,  // Voltage current
    output wire [7:0] uo_out, // Spike output
    output wire [7:0] uio_out,// Threshold

    // the following wires are not used
    input  wire [7:0] uio_in,
    input  wire       ena,
    output wire [7:0] uio_oe
);

// unused wires become 0

assign uio_oe = 8'b0;

// parameters a
parameter alpha = 8'b00001000;      
parameter b0j = 8'b00001000;     

// state and threshold registers
reg [7:0] next_state; 
reg [7:0] adaptation;    
reg [7:0] threshold;
reg [7:0] state;

// clock cycle moves up state
always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        adaptation <= alpha;
        threshold <= b0j;
        state <= 8'b0;
    end else begin
        state <= next_state;
    end
end

// assign spike to 0 or 1
assign uo_out = (state >= threshold) ? 8'b00000001 : 8'b00000000;

// Update the next state and threshold decay/increase
always @(*) begin
    next_state = ui_in + (state >> 1); // decay by 50%
    adaptation = (state >= threshold) ? ((adaptation) + (adaptation >> 2)) : ((adaptation >> 1) + (adaptation >> 2)); // 25% increase or decrease
    threshold = b0j + adaptation; 
end

// Make threshold viewable
//assign uio_out = threshold;

endmodule
