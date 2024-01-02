`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:46 12/26/2023 
// Design Name: 
// Module Name:    q1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module project (
    input wire clk,
    input wire reset,
    input wire Done,
    input wire [7:0]sw,
	 output wire [1:0]led,
    output wire g,f,e,d,c,b,a,
	 output wire seg0, seg1, seg2, seg3,dp
);
reg [3:0] R0,R1,R2,R3,R4,R5,R6,R7;
reg op,ADD,MUL,SUB,ST,LD,CMP,NANDT,NORT,XORT;
reg [7:0] out;
wire [11:0] bcd;
reg [1:0] counter1;
reg [3:0] temp;

reg new_clk;
integer counter = 0;
always @(posedge clk)begin
    counter= counter+1;
    if(counter == 5000000) begin
    	new_clk = ~new_clk;
    	counter =0;
    end	 
end

always @(posedge new_clk) begin 
    if(reset)
    begin
    R0=4'b0000;
    R1=4'b0000;
    R2=4'b0000;
    R3=4'b0000;
    R4=4'b0000;
    R5=4'b0000;
    R6=4'b0000;
    R7=4'b0000;
    op=1'b0;
    ADD=1'b0;
    SUB=1'b0;
    MUL=1'b0;
    ST=1'b0;
    end
    else if(Done & !op)
    begin
        op=1'b1;
        case(sw[3:0])
          4'b0001 : begin ADD=1'b1;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end 
          4'b0011 : begin ADD=1'b0;  
                          SUB=1'b1;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end  
          4'b0111 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b1;
                          ST=1'b0; 
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end        
          4'b1111 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b1;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end    
          4'b1110 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b1;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end  
          4'b1100 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b1;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b0;
          end  
          4'b1000 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b1;
                          NORT=1'b0;
                          XORT=1'b0;
          end  
          4'b1001 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b1;
                          XORT=1'b0;
          end
          4'b1011 : begin ADD=1'b0;  
                          SUB=1'b0;
                          MUL=1'b0; 
                          ST=1'b0;
                          LD=1'b0;
                          CMP=1'b0;
                          NANDT=1'b0;
                          NORT=1'b0;
                          XORT=1'b1;
          end       
        endcase
    end
       else if (Done && ADD)
       begin
           if(counter1==2'b00)
           begin
            R0=sw[7:4];
            counter1 = counter1 + 2'b01;
           end
           else if(counter1==2'b01)
           begin
            R1=sw[7:4];
            {R3,R2} = {{4{R1[3]}},R1} + {{4{R0[3]}},R0};
            out={R3,R2};
            counter1=2'b00;
            ADD=1'b0;
            op=1'b0;
           end

           end

        else if (Done && SUB)
        begin
            if(counter1==2'b00)
            begin
             R0=sw[7:4];
             counter1 = counter1 + 2'b01;
            end
            else if(counter1==2'b01)
            begin
             R1=sw[7:4];
             temp = ~R1+1;
             {R3,R2} = {{4{R0[3]}},R0} + temp;
             out= {R3,R2};
              counter1=2'b00;
              SUB=1'b0;
              op=1'b0;
            end
            end


            else if (Done && MUL)
            begin
                if(counter1==2'b00)
                begin
                 R0=sw[7:4];
                 counter1 = counter1 + 2'b01;
                end
                else if(counter1==2'b01)
                begin
                 R1=sw[7:4];
                 counter1 = counter1 + 2'b01;
                {R3,R2} = {{4{R1[3]}},R1} * {{4{R0[3]}},R0};
                 counter1=2'b00;
                 MUL=1'b0;
                 op=1'b0;
                end
                end
           else if (Done && ST)
           begin
            R4=sw[7:4];
              ST=1'b0;
              op=1'b0;
           end
            else if (Done && LD)
           begin
            case(sw[7:4])
            4'b0000:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0001:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0010:
            begin
            LD=1'b0;
            op=1'b0;
            end 
            4'b0011:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0100:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0101:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0110:
            begin
            LD=1'b0;
            op=1'b0;
            end
            4'b0111:
            begin
            LD=1'b0;
            op=1'b0;
            end
            endcase
           end
           else if (Done && CMP)
           begin
            if(counter1==2'b00)
           begin
            R5=sw[7:4];
            counter1 = counter1 + 2'b01;
           end
            else if(counter1==2'b01)
           begin
            R6=sw[7:4];
            if(R5>R6)
            #show g
            else if(R5<R6)
            #show l
            else if(R5==R6)
            #show e

            counter1=2'b00;
            CMP=1'b0;
            op=1'b0;
           end
           end
           else if (Done && NANDT)
           begin
            if(counter1==2'b00)
           begin
            R5=sw[7:4];
            counter1 = counter1 + 2'b01;
           end
            else if(counter1==2'b01)
           begin
            R6=sw[7:4];
            R7=(R5 ~& R6);
            counter1=2'b00;
            NANDT=1'b0;
            op=1'b0;
           end
            else if (Done && NORT)
           begin
            if(counter1==2'b00)
           begin
            R5=sw[7:4];
            counter1 = counter1 + 2'b01;
           end
            else if(counter1==2'b01)
           begin
            R6=sw[7:4];
            R7=(R5 ~| R6);
            counter1=2'b00;
            NORT=1'b0;
            op=1'b0;
           end
           end
            else if (Done && XORT)
           begin
            if(counter1==2'b00)
           begin
            R5=sw[7:4];
            counter1 = counter1 + 2'b01;
           end
            else if(counter1==2'b01)
           begin
            R6=sw[7:4];
            R7=(R5 ^ R6);
            counter1=2'b00;
            XORT=1'b0;
            op=1'b0;
           end
end
  end
end


    seg_display2  test(
    .clk(clk),
    .N1(bcd[3:0]),
    .N2(bcd[7:4]),
    .N3(bcd[11:8]),
    .N4(R3[4]),
    .g(g),
    .f(f),
    .e(e),
    .d(d),
    .c(c),
    .b(b),
    .a(a),
    .dp(dp),
    .seg0(seg0),
    .seg1(seg1),
    .seg2(seg2),
    .seg3(seg3)
);

bin2bcd t(
    .bin((R3[3]==1'b1)?~{R3,R1}+1'b1:{R3,R1}),
    .bcd(bcd)
);











endmodule






module seg_display2 (
    input wire clk,
    input wire [3:0]N1,
    input wire [3:0]N2,
    input wire [3:0]N3,
    input wire N4,
    output reg g,f,e,d,c,b,a,
	output reg seg0, seg1 ,seg2,seg3,dp
);
integer counter = 0;
reg [1:0]cc = 2'b00;
reg new_clk ;

always @(posedge clk)begin
    counter= counter+1;
	if(counter == 10000) begin
	  new_clk = ~new_clk;
	  counter =0;
	 end	 
end
always @(posedge new_clk) begin
		dp = 0;
    if(cc == 2'b00) begin
			cc=2'b01;
        case(N1)
            0 : {g,f,e,d,c,b,a} = 7'b0111111;
            1 : {g,f,e,d,c,b,a} = 7'b0000110;
            2 : {g,f,e,d,c,b,a} = 7'b1011011;
            3 : {g,f,e,d,c,b,a} = 7'b1001111;
            4 : {g,f,e,d,c,b,a} = 7'b1100110;
            5 : {g,f,e,d,c,b,a} = 7'b1101101;
            6 : {g,f,e,d,c,b,a} = 7'b1111101;
            7 : {g,f,e,d,c,b,a} = 7'b0000111;
            8 : {g,f,e,d,c,b,a} = 7'b1111111;
            9 : {g,f,e,d,c,b,a} = 7'b1101111;
            10: {g,f,e,d,c,b,a} = 7'b1110111;
            11: {g,f,e,d,c,b,a} = 7'b1111100;
            12: {g,f,e,d,c,b,a} = 7'b0111001;
            13: {g,f,e,d,c,b,a} = 7'b1011110;
            14: {g,f,e,d,c,b,a} = 7'b1111001;
            15: {g,f,e,d,c,b,a} = 7'b1110001;
        endcase
        seg0 = 1;
        seg1 = 1;
        seg2 = 1;
        seg3 = 0;
    end else if(cc == 2'b01) begin
			cc=2'b10;
        case(N2)
            0 : {g,f,e,d,c,b,a} = 7'b0111111;
            1 : {g,f,e,d,c,b,a} = 7'b0000110;
            2 : {g,f,e,d,c,b,a} = 7'b1011011;
            3 : {g,f,e,d,c,b,a} = 7'b1001111;
            4 : {g,f,e,d,c,b,a} = 7'b1100110;
            5 : {g,f,e,d,c,b,a} = 7'b1101101;
            6 : {g,f,e,d,c,b,a} = 7'b1111101;
            7 : {g,f,e,d,c,b,a} = 7'b0000111;
            8 : {g,f,e,d,c,b,a} = 7'b1111111;
            9 : {g,f,e,d,c,b,a} = 7'b1101111;
            10: {g,f,e,d,c,b,a} = 7'b1110111;
            11: {g,f,e,d,c,b,a} = 7'b1111100;
            12: {g,f,e,d,c,b,a} = 7'b0111001;
            13: {g,f,e,d,c,b,a} = 7'b1011110;
            14: {g,f,e,d,c,b,a} = 7'b1111001;
            15: {g,f,e,d,c,b,a} = 7'b1110001;
        endcase
        seg0 = 1;
        seg1 = 1;
        seg2 = 0;
        seg3 = 1;
    end else if(cc == 2'b10) begin
		cc=2'b11;
        case(N3)
            0 : {g,f,e,d,c,b,a} = 7'b0111111;
            1 : {g,f,e,d,c,b,a} = 7'b0000110;
            2 : {g,f,e,d,c,b,a} = 7'b1011011;
            3 : {g,f,e,d,c,b,a} = 7'b1001111;
            4 : {g,f,e,d,c,b,a} = 7'b1100110;
            5 : {g,f,e,d,c,b,a} = 7'b1101101;
            6 : {g,f,e,d,c,b,a} = 7'b1111101;
            7 : {g,f,e,d,c,b,a} = 7'b0000111;
            8 : {g,f,e,d,c,b,a} = 7'b1111111;
            9 : {g,f,e,d,c,b,a} = 7'b1101111;
            10: {g,f,e,d,c,b,a} = 7'b1110111;
            11: {g,f,e,d,c,b,a} = 7'b1111100;
            12: {g,f,e,d,c,b,a} = 7'b0111001;
            13: {g,f,e,d,c,b,a} = 7'b1011110;
            14: {g,f,e,d,c,b,a} = 7'b1111001;
            15: {g,f,e,d,c,b,a} = 7'b1110001;
        endcase
        seg0 = 1;
        seg1 = 0;
        seg2 = 1;
        seg3 = 1;
    end else if(cc == 2'b11) begin
		cc=2'b00;
        if(N4 == 0)
            {g,f,e,d,c,b,a} = 7'b0000000;
        else
            {g,f,e,d,c,b,a} = 7'b1000000;
        seg0 = 0;
        seg1 = 1;
        seg2 = 1;
        seg3 = 1;
    end
end
endmodule


module bin2bcd(
   input [7:0] bin,
   output reg [11:0] bcd
   );
   
integer i;
	
always @(bin) begin
    bcd=0;		 	
    for (i=0;i<8;i=i+1) begin					//Iterate once for each bit in input number
        if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;		//If any BCD digit is >= 5, add three
	    if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	    if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
	bcd = {bcd[10:0],bin[7-i]};				//Shift one bit, and shift in proper bit from input 
    end
end
endmodule
