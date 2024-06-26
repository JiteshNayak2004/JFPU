
module fp_adder (
    a,
    b,
    out
);
  // port declarations
  input logic [31:0] a;
  input logic [31:0] b;
  output logic [31:0] out;

  // sign exponent and mantissa declaration for all ip and op's

  //ip_1
  logic a_sign;
  logic [7:0] a_exponent;
  logic [23:0] a_mantissa;  // 24 bits to store implicit bit too

  //ip2
  logic b_sign;
  logic [7:0] b_exponent;
  logic [23:0] b_mantissa;

  //out
  logic out_sign;
  logic [7:0] out_exponent;
  logic [24:0]out_mantissa; /* 1 extra bit to handle add overflow as adding 2 24 bit no gives 25 bit o/p */

  //temp intermediate vars
  logic [7:0] diff;
  logic [23:0] tmp_mantissa;
  logic [7:0] tmp_exponent;

  // dummy vars to convert o/p mantissa into 1.Mantissa format using 
  logic [7:0] i_e;
  logic [23:0] i_m;
  logic [7:0] o_e;
  logic [23:0] o_m;

  //basic assigning
  assign a_sign = a[31];
  assign b_sign = b[31];
  //regs to store normalized o/p mantissa and exponent
  logic[23:0] norm_out_mantissa;
  logic[7:0] norm_out_exponent;
  logic[63:0] binary_i; // sformatf returns a 64 bit value
  logic[7:0] binary_eq; // slicing binary_i to contain 8 bits so as to subtract
  int leading_zeros = 0;
  integer i;

  // adding the implicit bit for normalized and denormalized floating point no's
  // 0 for denormalized
  // 1 for normalized

  always @(*) begin
    // for ip a
    if (a_exponent == 8'b0) begin
      a_exponent = 8'h01; // don't get why we doing this have to look on it later
      a_mantissa = {1'b0, a[22:0]};  // storing the implicit bit
    end else begin
      a_exponent = a[30:23];
      a_mantissa = {1'b1, a[22:0]};
    end

    //for ip b
    if (b_exponent == 8'b0) begin
      b_exponent = 8'h01;
      b_mantissa = {1'b0, b[22:0]};
    end else begin
      b_exponent = b[30:23];
      b_mantissa = {1'b1, b[22:0]};
    end

    // computing the out-mantissa and exponent
    // case 1 both exponents equal

    if (a_exponent == b_exponent) begin

      out_exponent = a_exponent;

      if (a_sign == b_sign) begin  //add
        out_mantissa = a_mantissa + b_mantissa;

      end else begin  // sub
        if (a_mantissa > b_mantissa) begin
          out_mantissa = a_mantissa - b_mantissa;
          out_sign = a_sign;
        end else begin
          out_mantissa = b_mantissa - a_mantissa;
          out_sign = b_sign;
        end
      end

    end else begin
      if (a_exponent > b_exponent) begin

        out_exponent = a_exponent;  // as a is bigger
        diff = a_exponent - b_exponent;
        tmp_mantissa = b_mantissa >> diff;  // right shifting mantissa to equalize exponents 

        if (a_sign == b_sign) out_mantissa = a_mantissa + b_mantissa;

        else out_mantissa = a_mantissa - b_mantissa;  // cuz a>b ??

      end else begin
        out_exponent = b_exponent;
        diff = b_exponent - a_exponent;
        tmp_mantissa = a_mantissa >> diff;

        if (a_sign == b_sign) out_mantissa = a_mantissa + b_mantissa;
        else out_mantissa = b_mantissa - a_mantissa;  // cuz b >a ??

      end
    end

    /*overflow if 25th bit is 1 and normalization if 23rd(implicit) bit is 0 
    <but if it is a denormalized no the implicit bit must be 0 > */

    // handling overflow
    if (out_mantissa[24] == 1) begin
      out_exponent = out_exponent + 1;
      out_mantissa = out_mantissa >> 1;

    end

    //checks whether the implicit bit is 0 and exponent non zero this would indicate a non normalized no
    //if exponent was 0 and the implicit bit 1 then it would be denormalized no in which this is permitted

    // Find ignore the implicit bit while assigning final op
    // Count leading zeros for exponent adjustment
    for (i = 1; i < 24; i = i + 1) begin
      if (out_mantissa[23 - i] == 1'b0) begin
        leading_zeros = leading_zeros + 1;
      end
    end

    // Normalize mantissa (conditional shift)
    norm_out_mantissa = out_mantissa << (leading_zeros);
    norm_out_exponent = out_exponent - leading_zeros; // Adjusted exponent

    out = {out_sign, out_exponent, out_mantissa[22:0]};

  end



endmodule



















