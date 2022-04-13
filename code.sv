module CounterModule (
    clk,
    control,
    initialValue,
    INIT
);
    //*rst
    input clk, initialValue, INIT, control;
    
    int const counterSize = 2;
    typedef bit [counterSize:0] counter_t;

    reg clk;

    bit [1:0] control;
    // reg [7:0] initialValue;
    counter_t initialValue;




    bit WINNER = 1'b0;
    bit LOSSER = 1'b0;
    bit GAMEOVER = 1'b0;
    bit [1:0] WHO = 2'b00;

    bit [3:0] counterWinner = 4'b0000;
    bit [3:0] counterLosser = 4'b0000;

    // * signal holder
    bit rst = 1'b0;




    
endmodule