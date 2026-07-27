`timescale 1ns / 1ps

module alu3_tb;
  localparam int W = 4;

  logic [W-1:0] a, b, result;
  logic is_sub;
  logic overflow, carry;

  int checks = 0;
  int errors = 0;

  alu3 #(
      .W(W)
  ) dut (
      .a(a),
      .b(b),
      .result(result),
      .is_sub(is_sub),
      .overflow(overflow),
      .carry(carry)
  );

  // Independent reference model. Computes the TRUE mathematical value in a
  // wide signed integer and just checks whether it fits in W signed bits --
  // deliberately not the sign-bit trick the DUT uses, so a bug there can't
  // cancel out against the same bug here.
  task automatic check(input logic [W-1:0] a_i, input logic [W-1:0] b_i, input logic sub_i);
    longint signed true_val;
    logic [W-1:0] expected_result;
    logic expected_overflow;
    logic [W:0] ext_add, ext_sub;
    logic expected_carry;
    begin
      a = a_i;
      b = b_i;
      is_sub = sub_i;

      true_val = sub_i ? ($signed(a_i) - $signed(b_i)) : ($signed(a_i) + $signed(b_i));
      expected_overflow = (true_val < -(2 ** (W - 1))) || (true_val > (2 ** (W - 1) - 1));

      expected_result = sub_i ? (a_i - b_i) : (a_i + b_i);  // plain W-bit wraparound
      result = expected_result;

      ext_add = {1'b0, a_i} + {1'b0, b_i};
      ext_sub = {1'b0, a_i} - {1'b0, b_i};
      expected_carry = sub_i ? ext_sub[W] : ext_add[W];

      #1;  // let the DUT's combinational logic settle

      checks++;
      if (overflow !== expected_overflow || carry !== expected_carry) begin
        errors++;
        $display(
            "FAIL: a=%0d b=%0d is_sub=%0b result=%0d | dut(ovf=%0b carry=%0b) expected(ovf=%0b carry=%0b) true_val=%0d",
            $signed(a_i), $signed(b_i), sub_i, $signed(expected_result), overflow, carry,
            expected_overflow, expected_carry, true_val);
      end
    end
  endtask

  initial begin
    for (int ai = 0; ai < 2 ** W; ai++) begin
      for (int bi = 0; bi < 2 ** W; bi++) begin
        check(ai[W-1:0], bi[W-1:0], 1'b0);  // add
        check(ai[W-1:0], bi[W-1:0], 1'b1);  // sub
      end
    end

    if (errors == 0) $display("ALL %0d CHECKS PASSED", checks);
    else $display("%0d / %0d CHECKS FAILED", errors, checks);

    $finish;
  end

  initial begin
    $dumpfile("alu3_tb.vcd");
    $dumpvars(0, alu3_tb);
  end

endmodule
