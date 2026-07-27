// ============================================================
// Signed Addition/Subtraction Overflow Detection (TEMPLATE)
// ============================================================
// Overflow for two's complement add/sub depends on operand/result sign relationships;
// carry is tracked separately.

module alu3 #(
    parameter int W = 32
) (
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    input  logic [W-1:0] result,
    input  logic         is_sub,
    output logic         overflow,
    output logic         carry
);

  // TODO: Compute carry. Hint: extend the operands by one bit so the
  //       carry-out of the W-bit add/sub becomes visible.
  logic [W:0] a_t, b_t, result_t;
  assign a_t = {1'b0, a};
  assign b_t = {1'b0, b};
  always_comb begin
    if (!is_sub) begin
      result_t = a_t + b_t;
    end else begin
      result_t = a_t - b_t;
    end
  end
  // TODO: Compute overflow. Think about which combinations of operand
  //       sign bits and result sign bit can only occur when the true
  //       result doesn't fit in W bits — the add and sub cases differ.
  //       (The Requirements section has the derivation if you're stuck.)
  //
  // TODO: Use is_sub to select between the add and sub behavior.
  // TODO: Keep everything parameterized on W and purely combinational
  //       (assign or always_comb).

  assign overflow = is_sub? (a[W-1] != b[W-1]) && ( result[W-1]!= a[W-1] ):(a[W-1] == b[W-1]) && (result[W-1]!= a[W-1]);

  assign carry = result_t[W];

endmodule

