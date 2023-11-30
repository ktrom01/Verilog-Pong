`timescale 1ns / 1ps

module vga_tb;
//Signals
reg clk, rst;
wire [3:0] red, grn, blu;
wire vertsync, horzsync;
reg right, left;

wire [$clog2(1040)-1:0] horctr ;
wire [$clog2(666)-1:0] verctr ;
assign horctr = VGA00.VGA01.horctr;
assign verctr = VGA00.VGA01.verctr;

wire inArea, inScreen; 
assign inArea = VGA00.inArea;
assign inScreen = VGA00.inScreen;

wire [$clog2(700)-1:0] paddlePos;
assign paddlePos = VGA00.paddlePos;


pong VGA00(//Module instantiation
    .clock_100Mhz(clk),
    .rst(rst),
    .right(right),
    .left(left),
    .red(red),
    .grn(grn),
    .blu(blu),
    .vertsync(vertsync),
    .horzsync(horzsync)
    );
always begin
    clk = 1; #1;
    clk = 0; #1;
end

initial begin
    rst = 0; right = 1; left = 0;
    @(posedge clk); @(posedge clk);
    right = 1; left = 0; rst = 0;
    repeat(2800000) @(posedge clk);//Enough clocks for two frames
    $finish;
end

endmodule
