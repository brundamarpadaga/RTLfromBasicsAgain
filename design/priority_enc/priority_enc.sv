module priority_enc #(
    parameter int N = 8,
    parameter int W = $clog2(N)
) (
    input  logic [N-1:0] req,
    output logic [W-1:0] enc,
    output logic         valid
);

  always_comb begin


    casez (req)

      8'b1???????: begin
        enc   = 3'b111;
        valid = 1'b1;
      end
      8'b01??????: begin
        enc   = 3'b110;
        valid = 1'b1;
      end
      8'b001?????: begin
        enc   = 3'b101;
        valid = 1'b1;
      end
      8'b0001????: begin
        enc   = 3'b100;
        valid = 1'b1;
      end
      8'b00001???: begin
        enc   = 3'b011;
        valid = 1'b1;
      end
      8'b000001??: begin
        enc   = 3'b010;
        valid = 1'b1;
      end
      8'b0000001?: begin
        enc   = 3'b001;
        valid = 1'b1;
      end
      8'b00000001: begin
        enc   = 3'b000;
        valid = 1'b1;
      end
      default: begin
        enc   = 3'b000;
        valid = 1'b0;
      end

    endcase
  end

endmodule
