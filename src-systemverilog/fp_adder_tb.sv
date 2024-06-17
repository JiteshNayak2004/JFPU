module fp_adder_tb();

  // Input signals
  logic [31:0] a;
  logic [31:0] b;

  // Output signal
  logic [31:0] out;

  // DUT instantiation
  fp_adder dut (a, b, out);

  initial begin
    // Test cases with expected results
    $dumpfile("adder.vcd");  
    $dumpvars(0,fp_adder_tb);

    $display("Test case 1: Positive + Positive");
    a = 32'b0_10000000_10111111111111111111111; // +12.375
    b = 32'b0_10000000_10000000000000000000000; // +5.0

    // Wait for simulation to settle
    #10;

    // Display computed output
    $display("  Computed output: %h", out);

    // Display expected output
    $display("  Expected output: 409FFFFF");

    $display("Test case 2: Positive + Negative");
    a = 32'b0_10000000_10111111111111111111111; // +12.375
    b = 32'b1_01111111_00010000000000000000000; // -5.25

    #10; // Wait for simulation to settle

    // Display computed output
    $display("  Computed output: %h", out);

    // Display expected output
    $display("  Expected output:40580000");

    // ... Add more test cases here

    $finish;
  end

endmodule

