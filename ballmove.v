`timescale 1ns / 1ps
`define PW (12)//Paddle width 

module ballmove(
    input clk,
    input rst,
    input [10:0] CounterX,
    input [9:0] CounterY,
    input [9:0] paddlePos,
    input [9:0] cpuPos,
    input dir,//Right = 1 left = 0
    input inArea,
    input rightB,
    input leftB,
    output [10:0] x,
    output [9:0] y
    );
    localparam straight = 2'b00, right = 2'b01, left = 2'b10, down = 1'b0, up = 1'b1;
    reg [10:0] ballX = 399;//
    reg [9:0] ballY = 300;//
    reg [1:0] ball_inX = straight;
    reg ball_inY = down;
    assign x = ballX;
    assign y = ballY;
        
    always @(posedge clk) begin
        if(rst)begin//Reset
            ballX <= 399;
            ballY <= 300;
            ball_inX <= straight;
            ball_inY <= down;
        end
        else if(ball_inY == down)begin//Traveling down 
            if(ballY+4==550)begin//Lose life + reset
                ballX <= 399;
                ballY <= 300;
                ball_inX <= straight;
            end
            else begin
                case(ball_inX)
                    straight : begin//Traveling straight down
                        if((ballY+4==540 && ballX-4<=paddlePos+`PW && ballX+4>=paddlePos-`PW)) begin
                            if(!rightB && leftB)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= up;
                                ballY <= ballY - 1;
                                ballX <= ballX - 1;
                            end
                            else if(rightB && !leftB)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= up;
                                ballY <= ballY - 1;
                                ballX <= ballX + 1;
                            end
                            else begin//Bounce straight
                                ball_inY <= up;
                                ballY <= ballY - 1;
                            end
                        end
                        else//Continue down
                            ballY <= ballY + 1;
                    end
                    right : begin//Traveling down and right 
                        if(ballY+4==540 && ballX-4<=paddlePos+`PW && ballX+4>=paddlePos-`PW) begin
                            if(!rightB && leftB)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= up;
                                ballX <= ballX - 1;
                                ballY <= ballY - 1;
                            end
                            else if(rightB && !leftB)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= up;
                                ballX <= ballX + 1;
                                ballY <= ballY - 1;
                            end
                            else begin//Bounce up continue right
                                ball_inY <= up;
                                ballY <= ballY - 1;
                            end
                        end
                        else if(ballX+4==749)begin//Hits right wall
                            ball_inX <= left;
                            ballX <= ballX - 1;
                            ballY <= ballY + 1;
                        end
                        else begin//Continue down and right
                            ballX <= ballX + 1;
                            ballY <= ballY + 1;
                        end
                    end
                    left : begin//Traveling down and left 
                        if(ballY+4==540 && ballX-4<=paddlePos+`PW && ballX+4>=paddlePos-`PW) begin//Hits paddle
                            if(!rightB && leftB)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= up;
                                ballX <= ballX - 1;
                                ballY <= ballY - 1;
                            end
                            else if(rightB && !leftB)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= up;
                                ballX <= ballX + 1;
                                ballY <= ballY - 1;
                            end
                            else begin//Paddle not moving
                                ball_inY <= up;
                                ballY <= ballY - 1;
                                ballY <= ballY - 1;
                            end
                        end
                        else if(ballX-4==50)begin//Hits left wall
                            ball_inX <= right;
                            ballX <= ballX + 1;
                            ballY <= ballY + 1;
                        end
                        else begin//Continue down and left
                            ballX <= ballX - 1;
                            ballY <= ballY + 1;
                        end
                    end
                endcase
            end
        end
        else begin //ball_inY == up Traveling up
            if(ballY-4==50)begin//Lose life + reset
                ballX <= 399;
                ballY <= 300;
                ball_inX <= straight;
            end
            else begin
                case(ball_inX)
                    straight : begin//Traveling straight up
                        if((ballY-4==60 && ballX-4<=cpuPos+`PW && ballX+4>=cpuPos-`PW)) begin
                            if(dir==1)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= down;
                                ballY <= ballY + 1;
                                ballX <= ballX - 1;
                            end
                            else if(dir==0)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= down;
                                ballY <= ballY + 1;
                                ballX <= ballX + 1;
                            end
                            else begin//Bounce straight
                                ball_inY <= down;
                                ballY <= ballY + 1;
                            end
                        end
                        else//Continue up
                            ballY <= ballY - 1;
                    end
                    right : begin//Traveling up and right
                        if((ballY-4==60 && ballX-4<=cpuPos+`PW && ballX+4>=cpuPos-`PW)) begin
                            if(dir==1)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= down;
                                ballX <= ballX - 1;
                                ballY <= ballY + 1;
                            end
                            else if(dir==0)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= down;
                                ballX <= ballX + 1;
                                ballY <= ballY + 1;
                            end
                            else begin//Bounce down continue right
                                ball_inY <= down;
                                ballY <= ballY + 1;
                            end
                        end
                        else if(ballX+4==749)begin//Hits right wall
                            ball_inX <= left;
                            ballX <= ballX - 1;
                        end
                        else begin//Continue Right and up
                            ballY <= ballY - 1;
                            ballX <= ballX + 1;
                        end
                    end
                    left : begin//Traveling up and left
                        if((ballY-4==60 && ballX-4<=cpuPos+`PW && ballX+4>=cpuPos-`PW)) begin
                            if(dir==1)begin//Bounce right
                                ball_inX <= right;
                                ball_inY <= down;
                                ballX <= ballX - 1;
                                ballY <= ballY + 1;
                            end
                            else if(dir==0)begin//Bounce left
                                ball_inX <= left;
                                ball_inY <= down;
                                ballX <= ballX + 1;
                                ballY <= ballY + 1;
                            end
                            else begin//Bounce down continue left
                                ball_inY <= down;
                                ballY <= ballY - 1;
                            end
                        end
                        else if(ballX-4==50)begin//hits left wall
                            ball_inX <= right;
                            ballX <= ballX + 1;
                        end
                        else begin//Continue left and up 
                            ballX <= ballX - 1;
                            ballY <= ballY - 1;
                        end
                    end
                endcase
            end
        end
    end  
endmodule