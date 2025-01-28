/*module tb;


logic clk2, clk3, clk4, clk;
logic [6:0] h0, h1, h2, h3, h4, h5;
logic [9:0] LEDR;
logic [3:0] KEY;
logic [9:0] SW;

Minilab0 iDUT(
.CLOCK2_50(clk2),
.CLOCK3_50(clk3),
.CLOCK4_50(clk4),
.CLOCK_50(clk),
.HEX0(h0),
.HEX1(h1),
.HEX2(h2),
.HEX3(h3),
.HEX4(h4),
.HEX5(h5),
.LEDR(LEDR),
.KEY(KEY),
.SW(SW)
);

initial begin
clk = 0;
SW = 0; 
KEY = 4'b1111;


// Fill FIFO with data
        KEY[0] = 0;   // Simulate pressing Key 0 (write enable)
        #20 KEY[0] = 1;

	SW = 10'h0C1; // Another input data

        // Wait for computation to complete
        wait (LEDR[0] == 1); // Assume LEDR[0] indicates DONE state

        // Observe outputs on HEX displays
        $display("Result displayed on HEX: %h %h %h %h %h %h", h5, h4, h3, h2, h1, h0);

        // End simulation
        #100 $stop;


end

always #5 clk = ~clk;


endmodule*/

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module tb;

  // Clock and reset
  reg CLOCK_50, CLOCK2_50, CLOCK3_50, CLOCK4_50;
  reg [3:0] KEY;  // Reset and other control keys
  reg [9:0] SW;   // Switch inputs
  wire [9:0] LEDR;  // LED outputs
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // HEX display outputs

  // Instantiate the DUT
  Minilab0 DUT (
    .CLOCK2_50(CLOCK2_50),
    .CLOCK3_50(CLOCK3_50),
    .CLOCK4_50(CLOCK4_50),
    .CLOCK_50(CLOCK_50),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .LEDR(LEDR),
    .KEY(KEY),
    .SW(SW)
  );

  // Clock generation
  initial begin
    CLOCK_50 = 0;
    forever #5 CLOCK_50 = ~CLOCK_50;  // 50MHz clock
  end

  initial begin
    CLOCK2_50 = 0;
    CLOCK3_50 = 0;
    CLOCK4_50 = 0;
  end

  // Test logic
  initial begin
    // Initialize inputs
    KEY = 4'b1111;  // Active low reset
    SW = 0;

    // Apply reset
    #10 KEY[0] = 0;  // Assert reset
    #20 KEY[0] = 1;  // Deassert reset

    // Fill FIFO with data
    $display("Filling FIFO...");
    #10 SW = SW + 1;
    /* repeat (8) begin
      #10 SW = SW + 1;  // Increment SW value to simulate input data
      #10 KEY[1] = 0;   // Simulate pressing a write enable key
      #10 KEY[1] = 1;
    end */

    // Wait for MAC operation to start
    $display("Starting MAC operations...");
    #50;

    // Wait for execution to complete
    wait (LEDR[1]);  // Wait for EXEC state to indicate processing
    #50;

    // Verify results
    $display("Verifying results...");
    $display("Result on HEX displays: %h %h %h %h %h %h", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("State: %d", LEDR[1:0]);

    // End simulation
    #100;
    $stop;
  end
endmodule

