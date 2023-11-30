`timescale 1ns / 1ps
//72hz @50MHZ 
//Horizontal
//Scanline part	Pixels	Time [µs] Count to @ 100MHZ
//Visible area	800	    16        1600 
//Front porch	56	    1.12      112
//Sync pulse	120	    2.4       240
//Back porch	64	    1.28      128
//Whole line	1040    20.8      2080


//Vertical need to count every time a whole vertical line is completed
//Frame part	Lines Time [ms]  Count to
//Visible area	600	  12.48      1248000
//Front porch	37	  0.7696     76960
//Sync pulse	6	  0.1248     12480
//Back porch	23	  0.4784     47840
//Whole frame	666	  13.8528    1385280

//Counter values for 100MHZ clock frequency
module vga(
    input clock_100Mhz,
    output reg vertsyn,
    output reg horzsyn,
    output inArea,
    output inScreen
    );
    reg clk = 0;//50Mhz clock
    reg [$clog2(1040)-1:0] horctr = 0;
    reg [$clog2(666)-1:0] verctr = 0;
    always@(posedge clock_100Mhz)
        clk <= clk + 1;//Will overflow and reset on its own
    always@(posedge clk)begin
        if(verctr >= 637 && verctr < 643)begin//Count to visible area + front porch
            vertsyn <= 0;                    //Set vertical sync to low
        end
        else if(verctr >= 643 && verctr < 666)begin//Back porch
            vertsyn <= 1;
        end
        else if (verctr == 666)begin//End of screen, reset vertical counter
            vertsyn <= 1;
            verctr <= 0;
        end
        else
            vertsyn <= 1;
        
        if(horctr >= 856 && horctr < 976)begin//Count to visible area + front porch 
            horzsyn <= 0;                    //Set horizontal sync to low
            horctr <= horctr + 1;
        end
        else if (horctr >= 976 && horctr < 1040)begin//Back porch
            horctr <= horctr + 1;
            horzsyn <= 1;
        end
        else if (horctr == 1040)begin//End of line, reset horizontal counter
            horctr <= 0;             //Increment vertical counter
            verctr <= verctr + 1;
            horzsyn <= 1;
        end
        else begin//Increment horizontal counter horizontal sync high
            horctr <= horctr + 1;
            horzsyn <= 1;
        end
    end
    assign inScreen = (horctr<=800 && verctr<=600) ? 1'b1 : 1'b0;
    assign inArea = (horctr>=50 && horctr<750 && verctr<=550 && verctr>=50) ? 1'b1 : 1'b0;
endmodule
