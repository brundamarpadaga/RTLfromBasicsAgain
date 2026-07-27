// Register file: the block that sits between the ALU and the rest of a CPU
// datapath. Every register-register instruction reads its two operands out
// of here and writes its result back in here.
//
// 2 read ports (combinational/asynchronous) + 1 write port (synchronous),
// with register 0 hardwired to zero -- same convention RISC-V/MIPS use for
// x0/$zero: it always reads as 0, and writes to it are silently discarded.

module regfile #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 3   // 2**ADDR_WIDTH registers
) (
    input logic clk,
    input logic rst,  // active-low, async (mirrors counter.sv)

    // write port
    input logic                  we,
    input logic [ADDR_WIDTH-1:0] waddr,
    input logic [DATA_WIDTH-1:0] wdata,

    // two read ports
    input  logic [ADDR_WIDTH-1:0] raddr1,
    input  logic [ADDR_WIDTH-1:0] raddr2,
    output logic [DATA_WIDTH-1:0] rdata1,
    output logic [DATA_WIDTH-1:0] rdata2
);

  // TODO: declare the register array.
  logic [DATA_WIDTH-1:0] registers[(2**ADDR_WIDTH-1):0];

  // TODO: synchronous write block (always_ff), active-low async reset like
  // counter.sv's `always_ff @(posedge clk, negedge rst)`.
  //   - on reset: clear every register to 0
  //   - on posedge clk: if (we) write wdata into regs[waddr]
  //   - register 0 must never change -- guard the write so waddr == 0 is a
  //     no-op even when we == 1

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (int i = 0; i < 2 ** ADDR_WIDTH; i++) begin
        registers[i] <= '0;
      end
    end else if (we) begin
      if (waddr != 0) begin
        registers[waddr] <= wdata;
      end
    end else begin
      for (int i = 0; i < 2 ** ADDR_WIDTH; i++) begin
        registers[i] <= registers[i];
      end
    end

  end

  // TODO: combinational reads (always_comb or continuous assign).
  //   rdata1 = regs[raddr1], rdata2 = regs[raddr2], no clock involved.
  //   (register 0 will already read 0 here as long as regs[0] is never
  //   written above)
  always_comb begin
    rdata1 = registers[raddr1];
    rdata2 = registers[raddr2];
  end

endmodule
