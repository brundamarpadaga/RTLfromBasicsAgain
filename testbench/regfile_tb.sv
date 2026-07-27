`timescale 1ns / 1ps

module regfile_tb;
  localparam int DATA_WIDTH = 8;
  localparam int ADDR_WIDTH = 3;
  localparam int CLK_PERIOD = 10;

  logic clk;
  logic rst;

  logic we;
  logic [ADDR_WIDTH-1:0] waddr;
  logic [DATA_WIDTH-1:0] wdata;

  logic [ADDR_WIDTH-1:0] raddr1, raddr2;
  logic [DATA_WIDTH-1:0] rdata1, rdata2;

  regfile #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
      .clk(clk),
      .rst(rst),
      .we(we),
      .waddr(waddr),
      .wdata(wdata),
      .raddr1(raddr1),
      .raddr2(raddr2),
      .rdata1(rdata1),
      .rdata2(rdata2)
  );

  initial clk = 0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    // reset
    rst = 0;
    we = 0;
    waddr = 0;
    wdata = 0;
    raddr1 = 0;
    raddr2 = 0;
    repeat (2) @(negedge clk);
    rst = 1;
    repeat (2) @(negedge clk);

    // try to write x0 -- must NOT stick
    we = 1;
    waddr = 0;
    wdata = 8'hFF;
    @(negedge clk);
    we = 0;
    raddr1 = 0;
    #1;  // let the combinational read settle

    // write a few registers
    we = 1;
    waddr = 1;
    wdata = 8'hAA;
    @(negedge clk);
    waddr = 2;
    wdata = 8'h55;
    @(negedge clk);
    waddr = 3;
    wdata = 8'h0F;
    @(negedge clk);
    we = 0;

    // dual-port read: reg1 and reg2 at the same time
    raddr1 = 1;
    raddr2 = 2;
    #1;

    // dual-port read: reg3 and reg0 (x0 should still read 0)
    raddr1 = 3;
    raddr2 = 0;
    #1;

    we = 1;
    waddr = 1;
    wdata = 8'h33;
    raddr1 = 1;
    #1;  // read before the edge -> still 0xAA
    @(negedge clk);
    we = 0;
    #1;  // read after the edge -> now 0x33

    repeat (2) @(negedge clk);
    $finish;
  end

  initial begin
    $timeformat(-9, 1, " ns", 8);
    $monitor(
        "time=%t rst=%b we=%b waddr=%0d wdata=%h | raddr1=%0d rdata1=%h | raddr2=%0d rdata2=%h",
        $time, rst, we, waddr, wdata, raddr1, rdata1, raddr2, rdata2);
    $dumpfile("regfile_tb.vcd");
    $dumpvars(0, regfile_tb);
  end

endmodule
