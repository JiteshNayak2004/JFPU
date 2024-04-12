
module multiplication_normaliser(in_e, in_m, out_e, out_m);
input  logic [7:0] in_e;
input  logic [47:0] in_m; // as the product of two 24 bit no's is 48 bit wide
output  logic [7:0] out_e;
output  logic [47:0] out_m;


integer i;
logic[63:0] binary_i; // sformatf returns a 64 bit value
logic[7:0] binary_eq; // slicing binary_i to contain 8 bits so as to subtract 


always@(*) begin

    for (i = 0 ;i<48 ; i++ ) begin

        if(in_m[i]==1'b1) begin
            out_m=in_m<<i;
            binary_i=$sformatf("%0d", i); // converts integer i to 64 bit binary
            binary_eq=binary_i[7:0]; // slicing the 8 bits needed
            out_e=in_e-binary_eq;
        end

        break;
        
    end

end

endmodule



