`timescale 1ns / 1ps

module memory_control(
    input clk,
    input [31:0] M_AXI_DP_AWADDR,
    input [31:0] M_AXI_DP_ARADDR,
    input [31:0] M_AXI_DP_WDATA,
    input [15:0] FRdata,
    input [7:0] SRdata,
    input M_AXI_DP_AWVALID,//Write ready Flash
    input M_AXI_DP_ARVALID,//Read ready Flash 
    input M_AXI_DP_WVALID, //Write ready SRAM 
    input M_AXI_DP_RVALID, //Read ready SRAM
    output reg [31:0] M_AXI_DP_RDATA,//Back to microblaze
    output CE, CE1,//To memory
    output reg OE, OE1,
    output reg WE, WE1,
    output reg [15:0]Faddr,
    output reg [14:0]Saddr,
    output [15:0] FWdata,
    output [7:0] SWdata
    );
    //[31:16] addr for flash [13:0] addr for SRAM
    //[23:8] data for flash [7:0] data for SRAM
    assign FWdata = M_AXI_DP_WDATA[31:16];//Splits the input data so both memories 
    assign SWdata = M_AXI_DP_WDATA[13:0]; //can be accessed at the same time
    
    assign CE = 0;//Active low
    assign CE1 = 0;//Set as always enabled
    
    always@* begin//Will always give the correct address to the external memories
        if(M_AXI_DP_RVALID)//SRAM
            Saddr = M_AXI_DP_ARADDR[13:0];
        else if(M_AXI_DP_WVALID)
            Saddr = M_AXI_DP_AWADDR[13:0];
        else//Need else or creates latch
            Saddr = 0;
        if(M_AXI_DP_ARVALID)//Flash
            Faddr = M_AXI_DP_ARADDR[31:16];
        else if(M_AXI_DP_AWVALID)
            Faddr = M_AXI_DP_AWADDR[31:16];
        else//Need else or creates latch
            Faddr = 0;
    end 
    
    always@(posedge clk)begin
        M_AXI_DP_RDATA[31:24] <= 8'h00;//Zero pad output
        if(M_AXI_DP_RVALID)begin//SRAM
            OE1 <= 0;//Active low
            WE1 <= 1;//Read
            M_AXI_DP_RDATA[7:0] <= SRdata;
        end
        else if(M_AXI_DP_WVALID)begin
            OE1 <= 0;//Active low
            WE1 <= 0;//Write
        end
        else//Set output to Z
            OE1 <= 1;
        if(M_AXI_DP_ARVALID)begin//Flash
            OE <= 0;//Active low
            WE <= 1;//Read
            M_AXI_DP_RDATA[23:8] <= FRdata;
        end
        else if(M_AXI_DP_AWVALID)begin
            OE <= 0;//Active low
            WE <= 0;//Write
        end
        else//Set output to Z
            OE <= 1;
    end
endmodule
