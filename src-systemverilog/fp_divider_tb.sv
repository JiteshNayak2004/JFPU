module fp_divider_tb();

  // Input signals
  logic [31:0] a;
  logic [31:0] b;

  // Output signal
  logic [31:0] out;

  // DUT instantiation
  fp_divider dut (a, b, out);

  initial begin
    // Test cases with expected results
    $dumpfile("divider.vcd");  
    $dumpvars(0,fp_divider_tb);

    $display("Test case 1: Positive + Positive");
    a = 32'b0_10000000_10111111111111111111111; // +12.375
    b = 32'b0_10000000_10000000000000000000000; // +5.0

    // Wait for simulation to settle
    #10;

    // Display computed output
    $display("  Computed output: %b", out);

    // Display expected output
    $display("  Expected output:32'b0100_0000_0001_1110_0110_0110_0110_0110");

    $display("Test case 2: Positive + Negative");
    a = 32'b0_10000000_10111111111111111111111; // +12.375
    b = 32'b01000000000000000000000000000000; // 2

    #10;// Wait for simulation to settle

    // Display computed output
    $display("  Computed output: %b", out);

    // Display expected output
    $display("  Expected output: 32'b0100_0000_1100_0101_1100_0010_1000_1111");


    $finish;
  end

endmodule

