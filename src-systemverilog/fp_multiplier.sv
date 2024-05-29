
module fp_multiplier (a,b,out);
// port declarations
input logic [31:0]a;
input logic [31:0]b;
output logic [31:0]out;

// sign exponent and mantissa declaration for all ip and op's

//ip_1
logic a_sign;
logic [7:0]a_exponent;
logic [23:0]a_mantissa; // 24 bits to store implicit bit too

//ip2
logic b_sign;
logic [7:0]b_exponent;
logic [23:0]b_mantissa;

//out
logic out_sign;
logic [7:0]out_exponent;
logic [23:0]out_mantissa; 

// intermediate vars

logic [47:0]product; // product is 48 bits as each i/p mantissa is 24 bit wide including implicit bit

// dummy vars to convert o/p mantissa into 1.Mantissa format using add_normalizer
logic [7:0] norm_out_exponent;
logic [47:0] norm_product; 
integer i;
logic[63:0] binary_i; // sformatf returns a 64 bit value
logic[7:0] binary_eq; // slicing binary_i to contain 8 bits so as to subtract 

//basic assigning

assign a_sign=a[31];
assign b_sign=b[31];



always@(*) begin

    // adding the implicit bit for normalized and denormalized floating point no's
    // 0 for denormalized
    // 1 for normalized

    // for ip a

    if(a[30:23]==0) begin
        a_exponent=8'b00000001;
        a_mantissa={1'b0,a[22:0]}; // denormalized no thus implicit bit 0 appended 
    end
    else begin
        a_exponent=a[30:23];
        a_mantissa={1'b1,a[22:0]}; // normalized no thus implicit bit 1 appended
    end

    // for ip b
    if(b[30:23]==0) begin
        b_exponent=8'b00000001;
        b_mantissa={1'b0,b[22:0]}; 
    end
    else begin
        b_exponent=b[30:23];
        b_mantissa={1'b1,a[22:0]}; 
    end

    // sign,mantissa produc and exp calc
    out_sign=a_sign^b_sign;
    out_exponent=a_exponent+b_exponent;
    product=a_mantissa*b_mantissa;

    // normalization making 1.M format
    // 47th bit is the implicit check bit
    // 46:23 are the 24 bits

    // implicit bit is 1 so store off the 24 bits as already normalized
    if (product[47]==1) begin
        out_mantissa=product[47:24]; // we are storing implicit bit also in mantissa
    end

    //If product[47](implicit bit) is 0 and o_exponent is non zero 
    //(indicates a non-zero value but not normalized)
    else if ((product[47] != 1) && (out_exponent != 0)) begin
      if(product[47-i]==1'b1) begin
        norm_product=product<<i;
        binary_i=$sformatf("%0d", i);
        binary_eq=binary_i[7:0];
        norm_out_exponent=out_exponent-binary_eq;
      end
    end
    out_mantissa=product[47:24];

    // final out we ignore implicit bit
    out={out_sign,out_exponent,out_mantissa[22:0]};
    

end

endmodule
