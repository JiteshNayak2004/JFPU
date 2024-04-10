

module adder(a,b,out);
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
logic [24:0]out_mantissa; // extra bit to handle overflows when adding or subtracting

//temp intermediate vars
logic [7:0] diff;
logic [23:0] tmp_mantissa;
logic [7:0] tmp_exponent;

// dummy vars to convert o/p mantissa into 1.Mantissa format using add_normalizer
  logic [7:0] i_e;
  logic [24:0] i_m;
  logic [7:0] o_e;
  logic [24:0] o_m;

//basic assigning

assign a_sign=a[31];
assign b_sign=b[31];

// intializing add_normalizer
  addition_normaliser norm
  (
    .in_e(i_e),
    .in_m(i_m),
    .out_e(o_e),
    .out_m(o_m)
  );

// adding the implicit bit for normalized and denormalized floating point no's
// 0 for denormalized
// 1 for normalized

always @(*) begin
    // for ip a
    if(a_exponent==8'b0) begin
        a_exponent=8'h01;
        a_mantissa={1'b0,a[22:0]};// storing the implicit bit
    end
    else begin
        a_exponent=a[30:23];
        a_mantissa={1'b1,a[22:0]};
    end

    //for ip b
    if(b_exponent==8'b0) begin
        b_exponent=8'h01;
        b_mantissa={1'b0,b[22:0]};
    end
    else begin
        b_exponent=b[30:23];
        b_mantissa={1'b1,b[22:0]};
    end

    // case 1 both exponents equal

    if(a_exponent==b_exponent) begin
        
        out_exponent=a_exponent;
        
        if(a_sign==b_sign) begin //add
            out_mantissa=a_mantissa+b_mantissa;

        end 
        else begin  // sub
            if (a_mantissa>b_mantissa) begin
                out_mantissa=a_mantissa-b_mantissa;
                out_sign=a_sign;
            end
            else begin
                out_mantissa=b_mantissa-a_mantissa;
                out_sign=b_sign;
            end
        end

    end

    else begin
        if(a_exponent>b_exponent) begin
            
            out_exponent=a_exponent; // as a is bigger
            diff=a_exponent-b_exponent;
            tmp_mantissa=b_mantissa>>diff; // right shifting mantissa to equalize exponents ??? mostly

            if(a_sign==b_sign) 
            out_mantissa=a_mantissa+b_mantissa;
            
            else 
            out_mantissa=a_mantissa-b_mantissa; // cuz a>b ??
            
        end

        else begin
            out_exponent=b_exponent;
            diff=b_exponent-a_exponent;
            tmp_mantissa=a_mantissa>>diff;

            if(a_sign==b_sign) 
            out_mantissa=a_mantissa+b_mantissa;
            else 
            out_mantissa=b_mantissa-a_mantissa; // cuz b >a ??
            
        end
    end

    //overflow check and normalization if 23rd(implicit) bit is 0

    // handling overflow
    if(out_mantissa[24]==1) begin
        out_exponent=out_exponent+1;
        out_mantissa=out_mantissa>>1;
    
    end

    //checks whether the implicit bit is 0 and exponent non zero this would indicate a non normalized no
    // if exponent was 0 then it would be denormalized no which is ok
    if((out_mantissa[23]!=1)&&(out_exponent!=0)) begin
      i_e = out_exponent;
      i_m = out_mantissa;
      out_exponent = o_e;
      out_mantissa = o_m;

    end

    // we ignore the implicit bit while assigning final op
    out={out_sign,out_exponent,out_mantissa[22:0]};
     
end



endmodule


// return's a 5 bit count and takes a 25 bit i/p

function automatic logic [4:0] clog2 (input logic [23:0] val);
  logic [4:0] count;
  for (count = 0; val > 0; count = count + 1) begin
    val = val >> 1;
  end
  return count;
endfunction


// addition normaliser

// approach 1 getting some circular dependency error with out_m

// module addition_normaliser(in_e, in_m, out_e, out_m);
//   input logic [7:0] in_e;  
//   input logic [23:0] in_m; // as overflow is checked and corrected before we don't need 24th bit
//   output logic [23:0] out_m;
//   output logic [7:0] out_e;


//   logic [23:0] mask = 'h7FFFFF; 
//   logic [23:0]temp=in_m & mask;
//   logic [4:0]shift_amount = clog2(temp);

//   /*
//   shift_amount = clog2(in_m & mask); using this stmt inside always causes a circular 
//   dependency because the current implementation subtracts shift_amount from in_e. 
//   However, shift_amount is derived from the shifted in_m value within the same always @(*) block. 
//   */ 
//   assign out_m = in_m << shift_amount;
//   assign out_e = in_e - {3'b0,shift_amount};



// endmodule

// approach 2 basic if statement

module addition_normaliser(in_e, in_m, out_e, out_m);
  input logic [7:0] in_e;  
  input logic [23:0] in_m; // as overflow is checked and corrected before we don't need 24th bit
  output logic [23:0] out_m;
  output logic [7:0] out_e;


always@(*) begin

    if(in_m[23:0]==24'b0000_0000__0000_0000_0000_0001) begin
      out_m=in_m<<23;
      out_e=in_e-23;
    end
    if(in_m[23:1]==23'b0000_0000_0000_0000_0000_001) begin
      out_m=in_m<<22;
      out_e=in_e-22;
    end
    if(in_m[23:2]==22'b0000_0000_0000_0000_0000_01) begin
      out_m=in_m<<21;
      out_e=in_e-21;
    end
    if(in_m[23:3]==21'b0000_0000_0000_0000_0000_1) begin
      out_m=in_m<<20;
      out_e=in_e-20;
    end
    if(in_m[23:4]==20'b0000_0000_0000_0000_0001) begin
      out_m=in_m<<19;
      out_e=in_e-19;
    end
    if(in_m[23:5]==19'b0000_0000_0000_0000_001) begin
      out_m=in_m<<18;
      out_e=in_e-18;
    end
    if(in_m[23:6]==18'b0000_0000_0000_0000_01) begin
      out_m=in_m<<17;
      out_e=in_e-17;
    end
    if(in_m[23:7]==17'b0000__0000_0000_0000_1) begin
      out_m=in_m<<16;
      out_e=in_e-23;
    end
    if(in_m[23:8]==16'b0000_0000_0000_0001) begin
      out_m=in_m<<25;
      out_e=in_e-15;
    end
    if(in_m[23:9]==15'b0000_0000_0000_001) begin
      out_m=in_m<<14;
      out_e=in_e-14;
    end
    if(in_m[23:10]==14'b0000_0000_0000_01) begin
      out_m=in_m<<13;
      out_e=in_e-13;
    end
    if(in_m[23:11]==13'b0000_0000_0000_1) begin
      out_m=in_m<<12;
      out_e=in_e-12;
    end
    if(in_m[23:12]==12'b0000_0000_0001) begin
      out_m=in_m<<11;
      out_e=in_e-11;
    end
    if(in_m[23:13]==11'b0000_0000_001) begin
      out_m=in_m<<10;
      out_e=in_e-10;
    end
    if(in_m[23:14]==10'b0000_0000_01) begin
      out_m=in_m<<9;
      out_e=in_e-9;
    end
    if(in_m[23:15]==9'b0000_0000_1) begin
      out_m=in_m<<8;
      out_e=in_e-8;
    end
    if(in_m[23:16]==8'b0000_0001) begin
      out_m=in_m<<7;
      out_e=in_e-6;
    end
    if(in_m[23:17]==7'b0000_001) begin
      out_m=in_m<<6;
      out_e=in_e-6;
    end
    if(in_m[23:18]==6'b0000_01) begin
      out_m=in_m<<5;
      out_e=in_e-5;
    end
    if(in_m[23:19]==5'b0000_1) begin
      out_m=in_m<<4;
      out_e=in_e-4;
    end
    if(in_m[23:20]==4'b0001) begin
      out_m=in_m<<3;
      out_e=in_e-3;
    end
    if(in_m[23:21]==3'b001) begin
      out_m=in_m<<2;
      out_e=in_e-22;
    end
    if(in_m[23:22]==2'b01) begin
      out_m=in_m<<1;
      out_e=in_e-1;
    end

    end


  

   
endmodule













