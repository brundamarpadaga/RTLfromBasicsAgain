`timescale 1ns / 1ps

module alu_tb;

  logic [3:0] a, b;
  logic [1:0] op;
  logic [3:0] result;
  logic zero;

  logic clk;

  alu a1 (
      a,
      b,
      op,
      result,
      zero
  );

  always #5 clk = ~clk;

  initial begin
    a  = 0;
    b  = 0;
    op = 2'b00;
    #10 a = 4;
    b  = 2;
    op = 2'b00;  // addition
    #10 a = 4;
    b  = 2;
    op = 2'b01;  // subtraction
    #10 a = 4;
    b  = 2;
    op = 2'b10;  // multiplication
    #10 a = 4;
    b  = 2;
    op = 2'b11;  // division
    #10 a = 4;
    b  = 4;
    op = 2'b01;  // subtraction to get zero
    #10 $finish;


  end


  // Dump waveforms to a VCD file
  initial begin
    $timeformat(-9, 1, " ns", 8);
    $monitor("time=%t a=%b b=%b op=%b result=%b, zero=%b", $time, a, b, op, result, zero);
    $dumpfile("alu_tb.vcd");  // Specify the name of the VCD file
    $dumpvars(0, alu_tb);  // Dump all variables in the testbench module
  end

endmodule
