`timescale 1ns / 1ps

module clock_tb;
    reg clk,rst;
    wire [3:0] an;
    wire [0:6] seg;
    
  clock UUT(clk,rst,an,seg);
    
    always #5 clk=~clk;
    
    initial begin
      //$monitor("%d%d:%d%d",an3,an2,an1,an0);
        clk=0; rst=1; #10;
               rst=0; #100;  //1 second simulation time
        $finish;            
    end
endmodule


