`timescale 1ns / 1ps


module buttonclk(
    input clk1,
    output clk2
    );
    reg tmp = 0;
    reg [$clog2(100000)-1:0] counter;
    always@(posedge clk1)begin
        if(counter==100000)begin
            tmp <= tmp + 1;
            counter <= 0;
        end
        else
            counter <= counter + 1;
    end
    assign clk2 = tmp;
endmodule
