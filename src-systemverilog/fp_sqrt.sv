// needed submodules

`include "fp_adder.sv"
`include "fp_multiplier.sv"



module divider (a,out);

// port declarations
input logic [31:0]a;
output logic [31:0]out;

// sign exponent and mantissa declaration for all ip and op's



// internal signals

logic [31:0] value_root2;
assign value_root2 = 32'h3FB4FDF4; // binary equivalent for root 2

logic [31:0]biased_float; // equivalent to calculating X

logic [31:0] value_half;
assign value_half=32'h3F000000;

// iteration vars

logic [31:0] x0; // initial seed
assign x0=32'h3F5A827A; // value is 0.853553414345
logic [31:0] x1; 
logic [31:0] x2;
logic [31:0] x3; 
logic [31:0] x3; 


// intermediate var in iterations
logic [31:0]d1; // iteration 1 division
logic [31:0]a1; // iteration 1 addition

logic [31:0]d2; // iteration 2 division
logic [31:0]a2; // iteration 2 addition

logic [31:0]d3; // iteration 3 division
logic [31:0]a3; // iteration 3 addition

always_comb begin 

    biased_float=a;
    biased_float[30:23]=8'b10000101; // making exponent as 126 so mantissa is biases b/w 0.5 to 1

    // calculation of Y now

    // iteration 1
    divider div1 (X,x0,d1); // calc X/xo
    adder add1 (x0,d1,a1);
    multiplier mul1 (value_half,a1,x1); 


    // iteration 2
    divider div2 (X,x1,d2); // calc X/xo
    adder add2 (x1,d2,a2);
    multiplier mul2 (value_half,a1,x2); 


    // iteration 3
    divider div3 (X,x2,d3); // calc X/xo
    adder add3 (x2,a3);
    multiplier mul3 (value_half,a3,x3); 

    // calculation of X that is Y*C now c happens to be root2

    multiplier m4 (x3,value_root2,x4);


    




    
end







endmodule
