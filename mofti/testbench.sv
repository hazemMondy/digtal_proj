
// Code your testbench here
// or browse Examples
module tb (
    clock,
    control,
    initial_value,
    INIT
);

  output clock, control, initial_value, INIT;
  parameter CYCLE = 10;
  parameter COUNTER_SIZE = 3;
  typedef bit [COUNTER_SIZE - 1 : 0] counter_t;



  bit INIT;
  reg clock;
  counter_t initial_value;  // initial value for counter

  bit [1:0] control;

  // Clock Run
  always #(CYCLE / 2) clock = ~clock;

  initial begin
    clock = 0;
    control = 2'b01;
    INIT = 1'b1;
    initial_value = 3'b011;
    #595 



    INIT = 1'b0;
    control = 2'b00;
    
    
    #595 

    control = 2'b10;
    
    #595 
    // #1155 
    control = 2'b11;

  end

  initial begin

    $dumpfile("waves.vcd");
    $dumpvars;
    #4000 $finish;


  end

  ctr u1 (
      clock,
      control,
      initial_value,
      INIT
  );
endmodule
