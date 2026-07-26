module alu (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] op,      // operation select
    output logic [3:0] result,
    output logic       zero     // high when result == 0
);



  always_comb begin
    case (op)
      2'b00:   result = a + b;
      2'b01:   result = a - b;
      2'b10:   result = a * b;
      2'b11:   result = a / b;
      default: result = 4'b0000;  // default case to avoid latches
    endcase

    zero = (result == 0);

  end
endmodule
