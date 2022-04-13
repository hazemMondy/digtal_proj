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
    input INIT
);
    input clk, initialValue, INIT, control;
    
    parameter int const counterSize = 2;
    typedef bit [counterSize -1:0] counter_t;

    reg clk;
    // default value is 0


    bit [1:0] control;
    // reg [7:0] initialValue;
    
    counter_t initialValue;
    // *default value is 0
    counter_t counter =initialValue;


    bit WINNER = 1'b0;
    bit LOSSER = 1'b0;
    bit GAMEOVER = 1'b0;
    bit [1:0] WHO = 2'b00;

    bit [3:0] counterWinner = 4'b0000;
    bit [3:0] counterLosser = 4'b0000;

    // * signal holder
    bit semaphore = 1'b0;

endmodule