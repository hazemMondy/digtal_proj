module CounterModule (
    counter_if.dut dutIntf
);

    //* declaration section
    // input clk, initialValue, INIT, control;
    // input rst;

    // constants
    parameter int counterSize = 2;
    parameter int maxScore = 15;
    typedef bit [counterSize -1:0] multiCounter_t;


    bit WINNER = 1'b0;
    bit LOSER = 1'b0;
    bit GAMEOVER = 1'b0;
    bit [1:0] WHO = 2'b00;

    bit [3:0] counterWinner = 4'b0000;
    bit [3:0] counterLosser = 4'b0000;

    // * for initial counter value
    bit semaphore = 1'b0;
    // * for winner and loser
    bit semaphoreSignal = 1'b1;
    bit semaphoreGame = 1'b1;

    // TODO: intial counter value
    // initial begin

    //     if (INIT) begin
    //     multiCounter = initialValue;
    //     end
    // end

    // TODO: init the copunter to initialValue
    always @(dutIntf.clockBlock_dut) begin
        
        // if INIT is asserted, then init the counter
        if (dutIntf.clockBlock_dut.init) begin
            // and this is the first time
            if(semaphore) begin
                dutIntf.clockBlock_dut.counter <= dutIntf.clockBlock_dut.initialValue;
                semaphore = 0;
            end
        end

        // if not INIT, then reset the semaphore
        else begin
            semaphore = 1;
        end
    end

    // TODO: update counter
    always @(dutIntf.clockBlock_dut) begin

        // counter 00 -> up +1
        if (dutIntf.clockBlock_dut.control == 2'b00) begin
            dutIntf.clockBlock_dut.counter <= dutIntf.clockBlock_dut.counter + 1;
        end

        // counter 01  -> up +2
        if (dutIntf.clockBlock_dut.control == 2'b01) begin
            dutIntf.clockBlock_dut.counter <= dutIntf.clockBlock_dut.counter + 2;
        end

        // counter 10 -> down -1
        if (dutIntf.clockBlock_dut.control == 2'b10) begin
            dutIntf.clockBlock_dut.counter <= dutIntf.clockBlock_dut.counter - 1;
        end

        // counter 11 -> down -2
        if (dutIntf.clockBlock_dut.control == 2'b11) begin
            dutIntf.clockBlock_dut.counter <= dutIntf.clockBlock_dut.counter - 2;
        end
    end

    // TODO: signals semaphore
    always @(dutIntf.clockBlock_dut) begin
        if (semaphoreSignal) begin
            WINNER = 1'b0;
            LOSER = 1'b0;
            WHO = 2'b00;
            semaphoreSignal = 0;
        end
    end

    // TODO: update wining and lossing counter
    always @(dutIntf.clockBlock_dut) begin

        // if the counter is == the all bits ones, then it is a winner
        if (dutIntf.clockBlock_dut.counter == multiCounter_t'(12'hf)) begin
            WINNER = 1'b1;
            counterWinner = counterWinner + 1;
            LOSER = 1'b0;
            semaphoreSignal = 1;
        end

        if (dutIntf.clockBlock_dut.counter == 0) begin
            LOSER = 1'b1;
            counterLosser = counterLosser + 1;
            WINNER = 1'b0;
            semaphoreSignal = 1;
        end
    end

    // TODO: if gameOver == 1'b1 reset all
  always @(dutIntf.clockBlock_dut) begin
        if (GAMEOVER == 1'b1) begin
            dutIntf.clockBlock_dut.counter <= 0;
            WINNER = 1'b0;
            LOSER = 1'b0;
            GAMEOVER = 1'b0;
            counterWinner = 4'b0000;
            counterLosser = 4'b0000;
            WHO = 2'b00;
            semaphoreSignal = 1;
        end
    end

    // TODO: update gameOver state
    always @(dutIntf.clockBlock_dut) begin

        // counter == 15  -> WINNER + = 1'b1
        if (counterWinner == maxScore) begin
            // Winner
            GAMEOVER = 1'b1;
            WHO = 2'b10;
            semaphoreSignal = 1;
        end

        // counter == 15 -> LOSER + = 1'b1
        if (counterLosser == maxScore) begin
            // Losser
            GAMEOVER = 1'b1;
            WHO = 2'b01;
            semaphoreSignal = 1;
        end
    end

    // every postive clks reset the signals to 0
    // always @(posedge clk) begin
    //     if (semaphore == 1'b1) begin
    //         WINNER = 1'b0;
    //         LOSER = 1'b0;
    //         GAMEOVER = 1'b0;
    //         WHO = 2'b00;
    //     end
    // end

    // TODO: rst signal
  always @(negedge dutIntf.clockBlock_dut.rst) begin
    	dutIntf.clockBlock_dut.counter <= 0;
        counterWinner = 0;
        counterLosser = 0;
        GAMEOVER = 1'b0;
        WINNER = 1'b0;
        LOSER = 1'b0;
        WHO = 2'b00;
        semaphoreSignal = 1;
    end

endmodule

module top;

  bit clock;
  parameter CYCLE = 8;
  parameter COUNTER_SIZE = 2;
  typedef bit [COUNTER_SIZE - 1:0] multiCounter_t;

  always #(CYCLE / 2) clock = ~clock;

  counter_if intf_1 (clock);
  CounterModule ctr_1 (intf_1.dut);
  TestBench tb_1 (intf_1.tb);

  initial begin

    $dumpfile("waves.vcd");
    $dumpvars;

  end

endmodule



  interface counter_if(input clk);

    parameter COUNTER_SIZE = 2;
    typedef bit [COUNTER_SIZE - 1:0] multiCounter_t;

    bit init, rst;
    multiCounter_t initialValue;  // initial value for counter
    bit [1:0] control;

    multiCounter_t counter;

    clocking clockBlock_dut @(posedge clk);
      input control, initialValue, rst, init;
      inout counter;
    endclocking


    clocking clockBlock_tb @(posedge clk);
      output control;
      inout counter, init, initialValue, rst;
      
    endclocking  


    modport dut(clocking clockBlock_dut);
    modport tb(clocking clockBlock_tb); 

  endinterface

program TestBench (
  counter_if.tb tbIntf
);

  // output clk, control, initialValue, init, rst;
  parameter CYCLE = 8;
  parameter counterSize = 2;
  typedef bit [counterSize - 1 : 0] multiCounter_t;


  initial begin
    tbIntf.clockBlock_tb.rst<= 0;
    tbIntf.clockBlock_tb.control <= 2'b11;
    tbIntf.clockBlock_tb.init <= 1'b1;
    tbIntf.clockBlock_tb.initialValue <= 3'b111;

    #400
    tbIntf.clockBlock_tb.control <= 2'b10;
    
  end

//   initial begin
//     $dumpfile("waves.vcd");
//     $dumpvars;
//     #500 $finish;
//   end

endprogram
