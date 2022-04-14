module test (
    clk,
    control,
    initialValue,
    init,
  	rst
);

  output clk, control, initialValue, init, rst;
  parameter CYCLE = 8;
  parameter counterSize = 2;
  typedef bit [counterSize - 1 : 0] multiCounter_t;

  bit init;
  reg clk;
  multiCounter_t initialValue;  // initial value for counter

  bit [1:0] control;
  reg rst ;

  always #(CYCLE / 2) clk = ~clk;

  initial begin
    clk = 0;
    rst= 0;
    control = 2'b01;
    init = 1'b1;
    initialValue = 3'b011;
    
    #210

    init = 1'b0;
    control = 2'b00;
    
    #210
    // reset
    rst= 1;
    #10
    rst= 0;
    
    #20
    // reset count down -1
    init = 1'b1;
    initialValue = 3'b011;
    control = 2'b10;
    
  end

  initial begin

    $dumpfile("testOut.vcd");
    $dumpvars;
    #1000 $finish;


  end

  CounterModule Counter (
      clk,
      control,
      initialValue,
      init,
      rst,
  );
endmodule




module test3 (
    clk,
    control,
    initialValue,
    init,
  	rst
);

  output clk, control, initialValue, init, rst;
  parameter CYCLE = 8;
  parameter counterSize = 2;
  typedef bit [counterSize - 1 : 0] multiCounter_t;



  bit init;
  reg clk;
  multiCounter_t initialValue;  // initial value for counter

  bit [1:0] control;
  reg rst ;

  always #(CYCLE / 2) clk = ~clk;

  initial begin
    clk = 0;
    rst= 0;
    control = 2'b11;
    init = 1'b1;
    initialValue = 3'b111;
    
  end

  initial begin

    $dumpfile("waves.vcd");
    $dumpvars;
    #500 $finish;


  end

  CounterModule Counter (
      clk,
      control,
      initialValue,
      init,
      rst,
  );
endmodule
