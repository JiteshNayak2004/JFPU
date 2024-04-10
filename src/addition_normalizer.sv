
// approach 1 using for loop

module addition_normaliser(in_e, in_m, out_e, out_m);
  input logic [7:0] in_e;  
  input logic [23:0] in_m; // as overflow is checked and corrected before we don't need 24th bit
  output logic [23:0] out_m;
  output logic [7:0] out_e;

  integer i;
  logic[63:0] binary_i; // sformatf returns a 64 bit value
  logic[7:0] binary_eq; // slicing binary_i to contain 8 bits so as to subtract   

  always_comb begin 
    
    for (i = 0 ;i<48 ;i++ ) begin

        if (in_m[i]==1'b1) begin

            out_m=in_m<<i;
            binary_i=$sformatf("%0d", i);
            binary_eq=binary_i[7:0];
            out_e=in_e-binary_eq;

        end
        
    end
    
  end

endmodule




// approach 2 using if stmts

// module addition_normaliser(in_e, in_m, out_e, out_m);
//   input logic [7:0] in_e;  
//   input logic [23:0] in_m; // as overflow is checked and corrected before we don't need 24th bit
//   output logic [23:0] out_m;
//   output logic [7:0] out_e;


// always@(*) begin

//     if(in_m[23:0]==24'b0000_0000__0000_0000_0000_0001) begin
//       out_m=in_m<<23;
//       out_e=in_e-23;
//     end
//     if(in_m[23:1]==23'b0000_0000_0000_0000_0000_001) begin
//       out_m=in_m<<22;
//       out_e=in_e-22;
//     end
//     if(in_m[23:2]==22'b0000_0000_0000_0000_0000_01) begin
//       out_m=in_m<<21;
//       out_e=in_e-21;
//     end
//     if(in_m[23:3]==21'b0000_0000_0000_0000_0000_1) begin
//       out_m=in_m<<20;
//       out_e=in_e-20;
//     end
//     if(in_m[23:4]==20'b0000_0000_0000_0000_0001) begin
//       out_m=in_m<<19;
//       out_e=in_e-19;
//     end
//     if(in_m[23:5]==19'b0000_0000_0000_0000_001) begin
//       out_m=in_m<<18;
//       out_e=in_e-18;
//     end
//     if(in_m[23:6]==18'b0000_0000_0000_0000_01) begin
//       out_m=in_m<<17;
//       out_e=in_e-17;
//     end
//     if(in_m[23:7]==17'b0000__0000_0000_0000_1) begin
//       out_m=in_m<<16;
//       out_e=in_e-23;
//     end
//     if(in_m[23:8]==16'b0000_0000_0000_0001) begin
//       out_m=in_m<<25;
//       out_e=in_e-15;
//     end
//     if(in_m[23:9]==15'b0000_0000_0000_001) begin
//       out_m=in_m<<14;
//       out_e=in_e-14;
//     end
//     if(in_m[23:10]==14'b0000_0000_0000_01) begin
//       out_m=in_m<<13;
//       out_e=in_e-13;
//     end
//     if(in_m[23:11]==13'b0000_0000_0000_1) begin
//       out_m=in_m<<12;
//       out_e=in_e-12;
//     end
//     if(in_m[23:12]==12'b0000_0000_0001) begin
//       out_m=in_m<<11;
//       out_e=in_e-11;
//     end
//     if(in_m[23:13]==11'b0000_0000_001) begin
//       out_m=in_m<<10;
//       out_e=in_e-10;
//     end
//     if(in_m[23:14]==10'b0000_0000_01) begin
//       out_m=in_m<<9;
//       out_e=in_e-9;
//     end
//     if(in_m[23:15]==9'b0000_0000_1) begin
//       out_m=in_m<<8;
//       out_e=in_e-8;
//     end
//     if(in_m[23:16]==8'b0000_0001) begin
//       out_m=in_m<<7;
//       out_e=in_e-6;
//     end
//     if(in_m[23:17]==7'b0000_001) begin
//       out_m=in_m<<6;
//       out_e=in_e-6;
//     end
//     if(in_m[23:18]==6'b0000_01) begin
//       out_m=in_m<<5;
//       out_e=in_e-5;
//     end
//     if(in_m[23:19]==5'b0000_1) begin
//       out_m=in_m<<4;
//       out_e=in_e-4;
//     end
//     if(in_m[23:20]==4'b0001) begin
//       out_m=in_m<<3;
//       out_e=in_e-3;
//     end
//     if(in_m[23:21]==3'b001) begin
//       out_m=in_m<<2;
//       out_e=in_e-22;
//     end
//     if(in_m[23:22]==2'b01) begin
//       out_m=in_m<<1;
//       out_e=in_e-1;
//     end

//     end


  

   
// endmodule

