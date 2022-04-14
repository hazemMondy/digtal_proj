
module CounterModule (
     clk,
     control,
     initialValue,
     INIT,
     rst,
);

    //* declaration section
    input clk, initialValue, INIT, control;
    input rst;

    // constants
    parameter int counterSize = 2;
    parameter int maxScore = 15;
    typedef bit [counterSize -1:0] multiCounter_t;


    reg clk;
  	reg rst;
    bit [1:0] control;

    multiCounter_t initialValue;
    // *default value is 0
    multiCounter_t multiCounter =0;


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
    initial begin

        if (INIT) begin
        multiCounter = initialValue;
        end
    end


    // TODO: init the copunter to initialValue
    always @(posedge clk) begin
        
        // if INIT is asserted, then init the counter
        if (INIT) begin
            // and this is the first time
            if(semaphore) begin
                multiCounter = initialValue;
                semaphore = 0;
            end
        end

        // if not INIT, then reset the semaphore
        else begin
            semaphore = 1;
        end
    end

    // TODO: update counter
    always @(posedge clk) begin

        // counter 00 -> up +1
        if (control == 2'b00) begin
            multiCounter = multiCounter + 1;
        end

        // counter 01  -> up +2
        if (control == 2'b01) begin
            multiCounter = multiCounter + 2;
        end

        // counter 10 -> down -1
        if (control == 2'b10) begin
            multiCounter = multiCounter - 1;
        end

        // counter 11 -> down -2
        if (control == 2'b11) begin
            multiCounter = multiCounter - 2;
        end
    end

    // TODO: signals semaphore
    always @(posedge clk) begin
        if (semaphoreSignal) begin
            WINNER = 1'b0;
            LOSER = 1'b0;
            WHO = 2'b00;
            semaphoreSignal = 0;
        end
    end

    // TODO: update wining and lossing counter
    always @(posedge clk) begin

        // if the counter is == the all bits ones, then it is a winner
        if (multiCounter == multiCounter_t'(12'hf)) begin
            WINNER = 1'b1;
            counterWinner = counterWinner + 1;
            LOSER = 1'b0;
            semaphoreSignal = 1;
        end

        if (multiCounter == 0) begin
            LOSER = 1'b1;
            counterLosser = counterLosser + 1;
            WINNER = 1'b0;
            semaphoreSignal = 1;
        end
    end

    // TODO: if gameOver == 1'b1 reset all
  always @(posedge clk) begin
        if (GAMEOVER == 1'b1) begin
            multiCounter = 0;
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
    always @(posedge clk) begin

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
  always @(negedge rst) begin
    	multiCounter = 0;
        counterWinner = 0;
        counterLosser = 0;
        GAMEOVER = 1'b0;
        WINNER = 1'b0;
        LOSER = 1'b0;
        WHO = 2'b00;
        semaphoreSignal = 1;
    end

endmodule