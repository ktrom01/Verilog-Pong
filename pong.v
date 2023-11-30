`timescale 1ns / 1ps

`define PW (12)//Paddle width 
`define PH (5)//Paddle height
module pong(
    input clock_100Mhz,
    input rst,
    input right,
    input left,
    output reg [3:0] red,
    output reg [3:0] grn,
    output reg [3:0] blu,
    output vertsync,
    output horzsync
    );
    reg clk = 0;//50Mhz clock
    wire bclk;//Button clock
    //wire cclk;//CPU paddle clock
    wire inArea, inScreen;//Boolean outputs for making screen
    reg [9:0] paddlePos = 399;//Middle of paddle
    reg [9:0] cpuPos = 399;
    reg dir = 1;//Right = 1 left = 0
    wire [10:0] horctr, x;
    wire [9:0] verctr, y;
    assign horctr = VGA01.horctr;
    assign verctr = VGA01.verctr;
    
    vga VGA01(//VGA output instantiation
        .clock_100Mhz(clock_100Mhz),
        .vertsyn(vertsync),
        .horzsyn(horzsync),
        .inArea(inArea),
        .inScreen(inScreen)
    );
    
    //Inspiration from https://www.fpga4fun.com/PongGame.html
    
    always@(posedge clock_100Mhz)
        clk <= clk + 1;//Will overflow and reset on its own
    always@(posedge clk)begin//Draw screen with border
        if(inScreen && ~inArea) begin//Border
            red <= 0;
            grn <= 0;
            blu <= 0;
        end
        else if(inArea)begin//Playable area
            if((60-`PH<=verctr && verctr<=60)&&//Height of paddle
            (horctr>=cpuPos-`PW && horctr<=cpuPos+`PW)) begin//Width of paddle 
                red <= 4'h8;//Draw cpu paddle
                grn <= 4'hF;
                blu <= 0;
            end
            else if((540+`PH>=verctr && verctr>=540)&&//Height of paddle
            (horctr>=paddlePos-`PW && horctr<=paddlePos+`PW)) begin//Width of paddle 
                red <= 4'h8;//Draw paddle
                grn <= 0;
                blu <= 4'hF;
            end
            else if((y+4>=verctr && verctr>=y-4)&&
            (horctr>=x-4 && horctr<=x+4)) begin//Draw ball
                red <= 0;
                grn <= 0;
                blu <= 0;
            end
            else begin
                red <= 4'hF;
                grn <= 0;
                blu <= 0;
            end
        end
        else begin//For setting up monitor 
            red <= 0;
            grn <= 4'hF;
            blu <= 0;
        end
        
    end
    
    buttonclk BC00(//Input clock 50mhz output to 500hz
    .clk1(clk),
    .clk2(bclk)
    );
    
    ballmove B0(//outputs the position of the balls center
        .clk(bclk),
        .rst(rst),
        .CounterX(horctr),
        .CounterY(verctr),
        .paddlePos(paddlePos),
        .cpuPos(cpuPos),
        .dir(dir),
        .inArea(inArea),
        .rightB(right),
        .leftB(left),
        .x(x),
        .y(y)
    );
    assign d = B0.ball_inY;
    always@(posedge bclk)begin
        if(rst)begin
            cpuPos <= 399;//Middle of screen
            dir <= 1;
        end
        else if((cpuPos < x) && (cpuPos+`PW < 749) && y <= 540 && d)begin//Right edge
            cpuPos <= cpuPos + 1;
            dir <= 1;
        end
        else if((cpuPos > x) && (cpuPos-`PW > 50) && y <= 540 && d)begin//Left edge
            cpuPos <= cpuPos - 1;
            dir <= 0;
        end
        else
            cpuPos <= cpuPos;
    end
    always@(posedge bclk)begin
        if(rst)
            paddlePos <= 399;//Middle of screen
        else if(!right && left && (paddlePos+`PW < 749))//Right edge
            paddlePos <= paddlePos + 1;
        else if(!left && right && (paddlePos-`PW > 50))//Left edge
            paddlePos <= paddlePos - 1;
        else
            paddlePos <= paddlePos;
    end
endmodule
