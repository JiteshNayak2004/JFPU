
`include "/home/jitesh/Desktop/JFPU/src-systemverilog/fp_adder.sv"
`include "/home/jitesh/Desktop/JFPU/src-systemverilog/fp_multiplier.sv"


// using newton raphson method for division

module divider (a,b,out);

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

// internal signals
logic [31:0]d; // adjusted divisor whose exponent is changed

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


// instantiations



logic [31:0] x0; // initial seed
logic [31:0] x1; 
logic [31:0] x2;
logic [31:0] x3;  
always_comb begin
    // assigning sign 
    assign out_sign=a_sign^b_sign;

    // assigning implicit bit for normalized and denormalized numbers
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
    // computing output exponent
    if (a_exponent>b_exponent) 
        out_exponent=a_exponent-b_exponent;
    else
        out_exponent=b_exponent-a_exponent;

    // division operation on mantissa's

    // approach is to find reciprocal of b using newton raphson's method and then multiply a with the reciprocal to get division

    d=b;// making d same as b
    d[30:23]=8'd126; // exp=126 to make value b/w 0.5 to 1 <kaise hota hei pata nahi check maar later>
    x0=C1-C2*d; //  initial seed value

    // iteration 1

    multiplier m1 (
        .a(d),
        .b(x0),
        .out(intermediate_op1)
    );

    adder a1 (
        .a(C3),
        .b(-intermediate_op1),
        .out(intermediate_op2)
    ); // 2-D*x0


    multiplier m2 (
        .a(x0),
        .b(intermediate_op2),
        .out(x1)
    ); // x1=x0*(2-D*x0)

    
    
    
    
    
    
    
    // iteration 2

    multiplier m3 (
        .a(d),
        .b(x1),
        .out(intermediate_op3)
    ); // d*x1

    adder a2 (
        .a(C3),
        .b(-intermediate_op3),
        .out(intermediate_op4)
    ); // 2-D*x1


    multiplier m4 (
        .a(x1),
        .b(intermediate_op4),
        .out(x2)
    ); // x2=x1*(2-D*x1)

    
    
    

    
    // iteration 3

    multiplier m5 (
        .a(d),
        .b(x2),
        .out(intermediate_op5)
    ); // D*x2

    adder a3 (
        .a(C3),
        .b(-intermediate_op5),
        .out(intermediate_op6)
    ); // 2-D*x0


    multiplier m6 (
        .a(x2),
        .b(intermediate_op6),
        .out(x3)
    ) // x3=x2*(2-D*x2)





end
    



    
endmodule







