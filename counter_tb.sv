`timescale 1ns / 1ps

module counter_tb;

  parameter int WIDTH = 4;

  logic clk;
  logic rst_n;
  logic enable;
  logic [WIDTH-1:0] count;

  // Instantiate the counter module
  counter #(
      .WIDTH(WIDTH)
  ) dut (
      .clk(clk),
      .rst(rst_n),
      .en(enable),
      .count(count)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz clock
  end

  // Test sequence
  initial begin
    // Initialize signals
    rst_n  = 0;
    enable = 0;

    // Apply reset
    #10 rst_n = 1;  // Release reset after 10 ns

    // Enable counting
    #10 enable = 1;  // Enable counting after another 10 ns

    // Wait for some time to observe counting
    #100;

    // Disable counting
    enable = 0;

    // Wait for some time to observe that counting has stopped
    #50;



    // Finish simulation
    $finish;
  end

  initial begin
    $timeformat(-9, 1, " ns", 8);
    $monitor("time=%t clk=%b rst=%b en=%b count=%2d", $time, clk, rst_n, enable, count);
    $dumpfile("counter_tb.vcd");
    $dumpvars(0, counter_tb);
  end

endmodule
