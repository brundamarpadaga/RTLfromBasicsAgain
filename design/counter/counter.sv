module counter #(
    parameter int WIDTH = 8
) (
    input logic clk,
    input logic rst,
    input logic en,
    output logic [WIDTH-1:0] count
);
  always_ff @(posedge clk, negedge rst) begin
    if (!rst) begin
      count <= 0;
    end else if (en) begin
      count <= count + 1'b1;
    end

  end

endmodule

