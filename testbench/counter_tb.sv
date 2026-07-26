`timescale 1ns / 1ps

module counter_tb;
  // Parameters
  localparam int WIDTH = 8;
  localparam int CLK_PERIOD = 10;  // ns, for a 100MHz clock

  // Signals to connect to the DUT
  logic             clk;
  logic             rst;
  logic             en;
  logic [WIDTH-1:0] count;

  // Instantiate the counter module
  counter #(
      .WIDTH(WIDTH)
  ) dut (
      .clk  (clk),
      .rst  (rst),
      .en   (en),
      .count(count)
  );

  // Clock generation
  initial clk = 0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  // Test sequence
  initial begin
    // Initialize signals
    rst = 0;  // Assert active-low reset
    en  = 0;
    repeat (2) @(posedge clk);  // Wait for 2 clock cycles

    rst = 1;  // De-assert reset
    repeat (2) @(posedge clk);

    en = 1;  // Enable counting
    repeat (10) @(posedge clk);  // Let it count for 10 cycles

    en = 0;  // Disable counting
    repeat (5) @(posedge clk);

    // Finish simulation
    $finish;
  end

  // Dump waveforms to a VCD file
  initial begin
    $timeformat(-9, 1, " ns", 8);
    $monitor("time=%t clk=%b rst=%b en=%b count=%2d", $time, clk, rst, en, count);
    $dumpfile("counter_tb.vcd");
    $dumpvars(0, counter_tb);
  end

endmodule
