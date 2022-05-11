module ctr (
    ctr_if.dut dutIntf
);

  parameter COUNTER_SIZE = 3;
  typedef bit [COUNTER_SIZE - 1:0] counter_t;



  // #### Winner and loser signals & variables ####
  bit LOSER = 1'b0, WINNER = 1'b0, GAMEOVER = 1'b0;
  bit [3:0] winner_counter = 0, loser_counter = 0;
  bit [1:0] WHO = 2'b00;

  // signal_holder ensures that WINNER or LOSER are high for only one cycle
  bit signal_holder = 1'b0;




  // #### Periodic Actions ####
  always @(dutIntf.cb_dut) begin

    if (dutIntf.cb_dut.INIT) begin
      dutIntf.cb_dut.counter <= dutIntf.cb_dut.initial_value;
      // Disabling INIT because counter is initialized successfully
      dutIntf.cb_dut.INIT <= 0;

    end else begin
      
      // Performing count
      if (!GAMEOVER && !dutIntf.cb_dut.INIT) begin
        case (dutIntf.cb_dut.control)
          // Counting Up
          2'b00: dutIntf.cb_dut.counter <= dutIntf.cb_dut.counter + 1;
          2'b01: dutIntf.cb_dut.counter <= dutIntf.cb_dut.counter + 2;

          // Counting Down
          2'b10: dutIntf.cb_dut.counter <= dutIntf.cb_dut.counter - 1;
          2'b11: dutIntf.cb_dut.counter <= dutIntf.cb_dut.counter - 2;
        endcase

      end
      // $display("Counter: %0d", counter);


      // if it's GAMEOVER, then we reset all counters and start over 
      if (GAMEOVER) begin
        dutIntf.cb_dut.counter <= 0;
        winner_counter = 0;
        loser_counter = 0;
        signal_holder = 1'b0;
        WINNER = 1'b0;
        LOSER = 1'b0;
        GAMEOVER = 1'b0;
        WHO = 2'b00;

        // $display("All Reset. Starting Over...!");
      end


      // Handling WINNER & LOSER signals
      if (signal_holder) begin
        // then we ensured that WINNER or LOSER have completed one cycle
        // Shutting down these signals

        signal_holder = 1'b0;
        WINNER = 1'b0;
        LOSER = 1'b0;

        // $display("Signal Released!");
      end


      // Here, we check if counter is Zeros or Ones and take action
      if (dutIntf.cb_dut.counter == 0) begin
        LOSER = 1'b1;
        loser_counter += 1'b1;
        signal_holder = 1'b1;

        // $display("loser_counter: %0d", loser_counter);

      end else begin
        if (counter_t'(dutIntf.cb_dut.counter + 1) == 0) begin
          // if counter all ones (adding 1 means overflow)
          WINNER = 1'b1;
          winner_counter += 1'b1;
          signal_holder = 1'b1;

          // $display("winner_counter: %0d", winner_counter);
        end
      end


      // GAMEOVER STATE

      if (loser_counter == 15) begin
        GAMEOVER = 1'b1;
        WHO = 2'b01;

        // $display("-------------------");
        // $display("GAMEOVER LOSER");
        // $display(WHO);
        // $display("-------------------");

      end else if (winner_counter == 15) begin
        GAMEOVER = 1'b1;
        WHO = 2'b10;

        // $display("-------------------");
        // $display("GAMEOVER WINNER");
        // $display(WHO);
        // $display("-------------------");

      end

    end

  end

endmodule


module top;

  bit clock;
  parameter CYCLE = 10;
  parameter COUNTER_SIZE = 3;
  typedef bit [COUNTER_SIZE - 1:0] counter_t;

  always #(CYCLE / 2) clock = ~clock;

  ctr_if intf_1 (clock);
  ctr ctr_1 (intf_1.dut);
  test tb_1 (intf_1.tb);

  initial begin

    $dumpfile("waves.vcd");
    $dumpvars;

  end

endmodule
