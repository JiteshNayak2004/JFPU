
// approach 1 using for loop

module addition_normalizer(in_e, in_m, out_e, out_m);
  input logic [7:0] in_e;  
  input logic [23:0] in_m;  
  output logic [23:0] out_m;
  output logic [7:0] out_e;

  integer i;
  logic[63:0] binary_i; // sformatf returns a 64 bit value
  logic[7:0] binary_eq; // slicing binary_i to contain 8 bits so as to subtract   

  always_comb begin  
    
    for (i = 0 ;i<23 ;i++ ) begin

        if (in_m[23-i]==1'b1) begin

            out_m=in_m<<i;
            binary_i=$sformatf("%0d", i);
            binary_eq=binary_i[7:0];
            out_e=in_e-binary_eq;

        end
        
    end
    
  end

endmodule





