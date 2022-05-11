  interface ctr_if(input clock);

    parameter COUNTER_SIZE = 3;
    typedef bit [COUNTER_SIZE - 1:0] counter_t;

    bit INIT;
    counter_t initial_value;  // initial value for counter
    bit [1:0] control;

    counter_t counter;

    clocking cb_dut @(posedge clock);
      input control, initial_value;
      inout counter, INIT;
    endclocking


    clocking cb_tb @(posedge clock);
      output control;
      inout counter, INIT,initial_value;
      
    endclocking  


    modport dut(clocking cb_dut);
    modport tb(clocking cb_tb); 

  endinterface //ctr_if







  program test (
      ctr_if.tb tbIntf
  );

    parameter CYCLE = 10;

    parameter COUNTER_SIZE = 3;
    typedef bit [COUNTER_SIZE - 1:0] counter_t;


    initial begin
      tbIntf.cb_tb.INIT <= 1'b1;
      tbIntf.cb_tb.initial_value <= 3'b011;
      tbIntf.cb_tb.control <= 2'b00;
      #595 



      tbIntf.cb_tb.control <= 2'b01;
      
      
      #595 

      tbIntf.cb_tb.control <= 2'b10;
      
      #595 
      // #1155 
      tbIntf.cb_tb.control <= 2'b11;

    end

    property check;
      @(tbIntf.cb_tb) disable iff (!tbIntf.cb_tb.INIT) 
      tbIntf.cb_tb.counter == tbIntf.cb_tb.initial_value;
    endproperty

    myAssertion:
    assert property (check) $display("SUCCESS");
    else $display("ERROR");

  endprogram
