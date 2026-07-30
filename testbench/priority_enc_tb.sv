module priority_enc_tb;

  localparam N = 8;
  localparam W = $clog2(N);
  logic [N-1:0] req;
  logic [W-1:0] enc;
  logic         valid;

  int           checks = 0;
  int           errors = 0;



  priority_enc #(
      .N(N),
      .W(W)
  ) dut (
      .req  (req),
      .enc  (enc),
      .valid(valid)
  );



  task automatic check(input logic [N-1:0] req);
    logic [W-1:0] enc_expected;
    logic valid_expt;

    if (req == 8'b00000000) begin
      enc_expected = 3'b000;
      valid_expt   = 1'b0;
    end else if (req[7] == 1'b1) begin
      enc_expected = 3'b111;
      valid_expt   = 1'b1;
    end else if (req[6] == 1'b1) begin
      enc_expected = 3'b110;
      valid_expt   = 1'b1;
    end else if (req[5] == 1'b1) begin
      enc_expected = 3'b101;
      valid_expt   = 1'b1;
    end else if (req[4] == 1'b1) begin
      enc_expected = 3'b100;
      valid_expt   = 1'b1;
    end else if (req[3] == 1'b1) begin
      enc_expected = 3'b011;
      valid_expt   = 1'b1;
    end else if (req[2] == 1'b1) begin
      enc_expected = 3'b010;
      valid_expt   = 1'b1;
    end else if (req[1] == 1'b1) begin
      enc_expected = 3'b001;
      valid_expt   = 1'b1;
    end else if (req[0] == 1'b1) begin
      enc_expected = 3'b000;
      valid_expt   = 1'b1;
    end

    #1;

    if (enc !== enc_expected || valid !== valid_expt) begin
      $display("FAIL: req=%b | dut(enc=%b valid=%b) expected(enc=%b valid=%b)", req, enc, valid,
               enc_expected, valid_expt);
      errors++;
    end else begin
      $display("PASS: req=%b | dut(enc=%b valid=%b) expected(enc=%b valid=%b)", req, enc, valid,
               enc_expected, valid_expt);
    end
    checks++;
  endtask

  initial begin
    for (int i = 0; i < 2 ** N; i++) begin
      req = i;
      check(i);
    end

    if (errors == 0) begin
      $display("All %0d checks passed!", checks);
    end else begin
      $display("%0d of %0d checks failed.", errors, checks);
    end

    $finish;
  end

  initial begin
    #1;
    $dumpfile("priority_enc_tb.vcd");
    $dumpvars(0, priority_enc_tb);
  end





endmodule
