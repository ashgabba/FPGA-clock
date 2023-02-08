`timescale 1ns / 1ps

module clock(
    input clk,rst,
    output reg [3:0] an,
    output reg [0:6] seg
    );
    
    reg count_state;
  	reg alrm_state;
  	reg cnt_alrm_state;
  	reg alrm_activated;
    reg [1:0] digit_select;
    reg [3:0] sel,an0,an1,an2,an3;
    reg [18:0] digSelCnt;
    reg [26:0] count;
    
    //Counting up every 1 second
    always @(posedge clk) begin
        if(rst) begin
            	count_state <= 1;	//Initial states
  		    	alrm_state <= 0;
  		    	cnt_alrm_state <= 0;
          		alrm_activated <= 0;
            	count <= 0;
            	an0 <= 0; //Resets to 12:00 when rst button is pushed
        		an1 <= 0;
          		an2 <= 2;
          		an3 <= 1; 
                end
      else if(count_state || cnt_alrm_state) begin
          		if(count==999 && an3==1 && an2==2 && an1==5 && an0==9) begin	//If 12:59, go to 01:00
                	count <= 0;
                	an0 <= 0; 
                	an1 <= 0;
                	an2 <= 1;
                	an3 <= 0; end
          		else if(count==999 && an3==0 && an2==9 && an1==5 && an0==9) begin	//If 09:59, go to 10:00					
                	count <= 0;
              		an0 <= 0;
              		an1 <= 0;
              		an2 <= 0;
              		an3 <= 1; end
          		else if(count==999 && an1==5 && an0==9) begin  //If hour is not special case, increment an2 + 1 (hours + 1)
            		count <= 0;
            		an0 <= 0;
            		an1 <= 0;
                	an2 <= an2 + 1; end		//hour gets incremented, hourten stays the same
          		else if(count==999 && an1<5 && an0==9) begin	//MINUTES cases 
                	count <= 0;
            		an0 <= 0;
            		an1 <= an1 + 1; end	//Increment minten digit by one
          		else if(count==999 && an0<9) begin
                	count <= 0;
            		an0 <= an0 + 1; end	//Increment minutes digit by one
          		else
            		count <= count + 1;	//If none of these cases, increment count + 1 
           end //end of else if(count_state)
      end //end of always block
        
        //Selecting which of 4 digits to dislay, switches every 4ms
        always @(posedge clk) begin
            if(rst) begin
                digSelCnt <= 0;
                digit_select <= 0; end
            else if(!rst) begin
                if(digSelCnt==3) begin
                    digSelCnt <= 0;
                    digit_select <= digit_select + 1; end
                else 
                    digSelCnt <= digSelCnt + 1;
            end //end of else if
        end //end of always
    
    //Selecting which of 4 digits to display, switches every 4ms
    always @(digit_select) begin
        case(digit_select)
            2'b00: begin an <= 4'b1110;    //Turn on min digit
                         sel <= an0; end
            2'b01: begin an <= 4'b1101;    //Turn on minten digit
              			 sel <= an1; end
            2'b10: begin an <= 4'b1011;    //Turn on hour digit
              			 sel <= an2; end
            2'b11: begin an <= 4'b0111;    //Turn on hourten digit
              			 sel <= an3; end
        endcase
    end	//end of always
    
    //Selecting which digit 0-9 to display
    always @(sel) begin
      case(sel)
        4'b0000: seg <= 7'b000_0001; //0
        4'b0001: seg <= 7'b100_1111; //1
        4'b0010: seg <= 7'b001_0010; //2
        4'b0011: seg <= 7'b000_0110; //3
        4'b0100: seg <= 7'b100_1100; //4
        4'b0101: seg <= 7'b010_0100; //5
        4'b0110: seg <= 7'b010_0000; //6
        4'b0111: seg <= 7'b000_1111; //7
        4'b1000: seg <= 7'b000_0000; //8
        4'b1001: seg <= 7'b000_0100; //9
        default: seg <= 7'b000_0001; //default 0
      endcase
    end
    
endmodule
