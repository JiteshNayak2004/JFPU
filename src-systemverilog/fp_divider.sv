`include "fp_adder.sv"
`include "fp_multiplier.sv"




module fp_divider (
    input logic[31:0]a,
    input logic[31:0]b,
    output logic[31:0]out
);

// internal signals
logic [31:0]d; // adjusted divisor whose exponent is changed

logic [31:0]reciprocal_b;

logic [31:0]C1; // C1= 48/17
assign C1 = 32'h4034B4B5;

logic [31:0] C2; //C2 = 32/17
assign C2 = 32'h3FF0F0F1;

logic [31:0] C3; //C3 = 2.0
assign C3 = 32'h40000000;

logic [31:0] intermediate_op1;
logic [31:0] intermediate_op2;
logic [31:0] intermediate_op3;
logic [31:0] intermediate_op4;
logic [31:0] intermediate_op5;
logic [31:0] intermediate_op6;


// instantiations

logic [31:0] x0; // initial seed
logic [31:0] x1; 
logic [31:0] x2;
logic [31:0] x3;  

assign d=b;// making d same as b
assign d[30:23]=8'd126; // exp=126 to make value b/w 0.5 to 1 <kaise hota hei pata nahi check maar later>
assign x0=C1-C2*d; //  initial seed value

// iteration 1
fp_multiplier m1 (
    .a(d),
    .b(x0),
    .out(intermediate_op1)
);
fp_adder a1 (
    .a(C3),
    .b(-intermediate_op1),
    .out(intermediate_op2)
); // 2-D*x0
fp_multiplier m2 (
    .a(x0),
    .b(intermediate_op2),
    .out(x1)
); // x1=x0*(2-D*x0)



// iteration 2
fp_multiplier m3 (
    .a(d),
    .b(x1),
    .out(intermediate_op3)
); // d*x1
fp_adder a2 (
    .a(C3),
    .b(-intermediate_op3),
    .out(intermediate_op4)
); // 2-D*x1
fp_multiplier m4 (
    .a(x1),
    .b(intermediate_op4),
    .out(x2)
); // x2=x1*(2-D*x1)



// iteration 3
fp_multiplier m5 (
    .a(d),
    .b(x2),
    .out(intermediate_op5)
); // D*x2
fp_adder a3 (
    .a(C3),
    .b(-intermediate_op5),
    .out(intermediate_op6)
); // 2-D*x0
fp_multiplier m6 (
    .a(x2),
    .b(intermediate_op6),
    .out(x3)
); // x3=x2*(2-D*x2)


// the x3 we have now is the adjusted value D we need to compute final value
logic [31:0]temp;
assign reciprocal_b = {b[31],x3[30:23]+8'd126-b[30:23],x3[22:0]};
assign temp=a*reciprocal_b;
assign temp=out;


    
endmodule
