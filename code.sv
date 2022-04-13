// test module with x defalut value = 0
// default value for port is 0
module test {
    export var x = 0;
    export function foo() {
        return x;
    }
}


module CounterModule (
    input clk,
    input control,
    input initialValue,
    input INIT,
    input rst,
);
    input clk, initialValue, INIT, control, rst;

    parameter int const counterSize = 2;
    typedef bit [counterSize -1:0] multiCounter_t;

    reg clk;
    // default value is 0

    bit [1:0] control;
    // reg [7:0] initialValue;

    multiCounter_t initialValue;
    // *default value is 0
    multiCounter_t multiCounter =initialValue;


    bit WINNER = 1'b0;
    bit LOSSER = 1'b0;
    bit GAMEOVER = 1'b0;
    bit [1:0] WHO = 2'b00;

    bit [3:0] counterWinner = 4'b0000;
    bit [3:0] counterLosser = 4'b0000;

    // * signal holder
    bit semaphore = 1'b0;

    // counter 00 -> up +1
    // counter 01  -> up +2
    // counter 10 -> down -1
    // counter 11 -> down -2

    // TODO: update counter
    always @(posedge clk) begin
        if (control == 2'b00) begin
            multiCounter <= multiCounter + 1;
        end

        if (control == 2'b01) begin
            multiCounter <= multiCounter + 2;
        end

        if (control == 2'b10) begin
            multiCounter <= multiCounter - 1;
        end

        if (control == 2'b11) begin
            multiCounter <= multiCounter - 2;
        end
    end

    // TODO: update wining and lossing counter
    always @(posedge clk) begin
        // ! multiCounter_t'(multiCounter + 1) == 0
        if (multiCounter == (counterSize-1)) begin
            WINNER = 1'b1;
            counterWinner = counterWinner + 1;
        end

        if (multiCounter == 0) begin
            LOSSER = 1'b1;
            counterLosser = counterLosser + 1;
        end
    end

    // TODO: update gameOver state
    // counter == 15  -> WINNER + = 1'b1
    // counter == 0 -> LOSSER + = 1'b1
    always @(posedge clk) begin
        if (counterWinner == 15) begin
            // Winner
            GAMEOVER = 1'b1;
            WHO = 2'b10;
        end

        if (counterLosser == 15) begin
            // Losser
            GAMEOVER = 1'b1;
            WHO = 2'b01;
        end
    end

    // TODO: rst
    always @(posedge rst) begin
        counter <= 0;
        counterWinner <= 0;
        counterLosser <= 0;
        GAMEOVER <= 1'b0;
        WINNER <= 1'b0;
        LOSSER <= 1'b0;
        WHO <= 2'b00;
    end

endmodule