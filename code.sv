
module CounterModule (
     clk,
     control,
     initialValue,
     INIT,
     rst,
);
    input clk, initialValue, INIT, control;
    input rst;

    // constants
    parameter int counterSize = 3;
    parameter int maxScore = 15;
    typedef bit [counterSize -1:0] multiCounter_t;


    reg clk;
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

    // TODO: intial counter value
    initial begin

        if (INIT) begin
        multiCounter = initialValue;
        end
    end


    // counter 00 -> up +1
    // counter 01  -> up +2
    // counter 10 -> down -1
    // counter 11 -> down -2
    // TODO: init the copunter to initialValue
    always @(posedge clk) begin

        if (INIT) begin
            if(semaphore) begin
                multiCounter = initialValue;
                semaphore = 0;
            end
        end

        else begin
            semaphore = 1;
        end
    end

    // TODO: update counter
    always @(posedge clk) begin

        if (control == 2'b00) begin
            multiCounter = multiCounter + 1;
        end

        if (control == 2'b01) begin
            multiCounter = multiCounter + 2;
        end

        if (control == 2'b10) begin
            multiCounter = multiCounter - 1;
        end

        if (control == 2'b11) begin
            multiCounter = multiCounter - 2;
        end
    end

    // TODO: update wining and lossing counter
    always @(posedge clk) begin

        if (multiCounter == multiCounter_t'(6'hf)) begin
            WINNER = 1'b1;
            counterWinner = counterWinner + 1;
            LOSER = 1'b0;
        end

        if (multiCounter == 0) begin
            LOSER = 1'b0;
            counterLosser = counterLosser + 1;
            WINNER = 1'b0;
        end
    end

    // TODO: update gameOver state
    // counter == 15  -> WINNER + = 1'b1
    // counter == 0 -> LOSER + = 1'b1
    always @(posedge clk) begin

        if (counterWinner == maxScore) begin
            // Winner
            GAMEOVER = 1'b1;
            WHO = 2'b10;
        end

        if (counterLosser == maxScore) begin
            // Losser
            GAMEOVER = 1'b1;
            WHO = 2'b01;
        end
    end

    // TODO: if gameOver == 1'b1 reset all
    always @(negedge clk) begin
        if (GAMEOVER == 1'b1) begin
            multiCounter = 0;
            WINNER = 1'b0;
            LOSER = 1'b0;
            GAMEOVER = 1'b0;
            counterWinner = 4'b0000;
            counterLosser = 4'b0000;
            WHO = 2'b00;
        end
    end
    // every two cycles reset the signals to 0
    // always @(posedge clk) begin
    //     if (GAMEOVER == 1'b1) begin
    //         semaphore = 1'b1;
    //     end else begin
    //         semaphore = 1'b0;
    //     end
    // end

    // every negative clks reset the signals to 0
    // always @(posedge clk) begin
    //     if (semaphore == 1'b1) begin
    //         WINNER = 1'b0;
    //         LOSER = 1'b0;
    //         GAMEOVER = 1'b0;
    //         WHO = 2'b00;
    //     end
    // end



    // TODO: rst signal
    always @(posedge rst) begin
        counter = 0;
        counterWinner = 0;
        counterLosser = 0;
        GAMEOVER = 1'b0;
        WINNER = 1'b0;
        LOSER = 1'b0;
        WHO = 2'b00;
    end

endmodule