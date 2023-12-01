# Verilog-Pong
Pong game play on a Basys 3 FPGA board, displays to a monitor using the VGA port
The paddle is controlled by using the left and right buttons BTNL(W19) and BTNR(T17).
You can reset the ball to the middle by pressing the top button BTNU(T18).
To play you need to add all of the files(except the vga_tb.v) to a project in Vivado. In settings the project device needs to match your Basys-3. The Pong.v file is the top module and needs to be set as top under Design sources. Next generate bitstream, when that is done open harware manager and select auto connect. With the board plugged in click program device, if the Basys is connected to a monitor via the VGA port it will start the game immediately. 
