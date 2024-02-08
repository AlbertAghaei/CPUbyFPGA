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
	input wire Done2,
    input wire LCD2SEG,
    input wire SEGoff,
	input wire instruct,
    input wire [7:0]sw,
	output wire [5:0]led,
    output wire g,f,e,d,c,b,a,
	output wire seg0, seg1, seg2, seg3,dp,
    output wire INTENSITY,E,RS,RW,
    output wire [7:0] Data
);
reg [3:0] R0,R1,R2,R3,R4,R5,R6,R7;
reg [7:0] out;

reg [7:0] bin_input;
reg ShowPermission;
reg IsCMP;
reg op,ADD,MUL,SUB,ST,LDT,CMP,NANDT,NORT,XORT;
initial ShowPermission=1'b0;
initial op=1'b0;
initial IsCMP=1'b0;
initial ADD=1'b0;
initial MUL=1'b0;
initial SUB=1'b0;
initial ST=1'b0;
initial CMP=1'b0;
initial NANDT=1'b0;
initial NORT=1'b0;
initial XORT=1'b0;
initial LDT=1'b0;
wire [11:0] bcd;
reg [3:0] temp;
reg [7:0] operation0;
reg [7:0] operation1;
reg [7:0] operation2;
reg [7:0] operation3;
reg [7:0] operation4;
wire [7:0] numDisplay0;
wire [7:0] numDisplay1;
wire [7:0] numDisplay2;
wire [7:0] numDisplay3;

reg new_clk;
integer counter = 0;
   integer m=0;

assign led[0]=instruct;
assign led[1]=Done;
assign led[2]=Done2;
assign led[3]= LCD2SEG;
assign led[4]= reset;
assign led[5]= new_clk;

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
	 CMP=1'b0;
	 NANDT=1'b0;
	 NORT=1'b0;
	 XORT=1'b0;
	 LDT=1'b0;
     IsCMP=1'b0;
	 out=8'b0000_0000;
     bin_input=8'b0000_0000;
     ShowPermission=1'b0;
    end
    else if(instruct & !op)
begin
    op=1'b1;
    case(sw[3:0])
      4'b0001 : begin ADD=1'b1;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                      operation0 = 8'b01000001; // "A"
                      operation1 = 8'b01000100; // "D"
                      operation2 = 8'b01000100; // "D"
                      operation3 = 8'b00111010; // ":"
                      operation4 = 8'b00100000; // " "
                      ShowPermission=0;
                      IsCMP=1'b0;
      end 
      4'b0011 : begin ADD=1'b0;  
                      SUB=1'b1;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                      operation0 = 8'b01010011; // "S"
                      operation1 = 8'b01010101; // "U"
                      operation2 = 8'b01000010; // "B"
                      operation3 = 8'b00111010; // ":"
                      operation4 = 8'b00100000; // " "
                      ShowPermission=0;
                      IsCMP=1'b0;
      end  
      4'b0111 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b1;
                      ST=1'b0; 
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                      operation0 = 8'b01001101; // "M"
                      operation1 = 8'b01010101; // "U"
                      operation2 = 8'b01001100; // "L"
                      operation3 = 8'b00111010; // ":"
                      operation4 = 8'b00100000; // " "
                      ShowPermission=0;
                      IsCMP=1'b0;
      end        
      4'b1111 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b1;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                       operation0 = 8'b01010011; // "S"
                       operation1 = 8'b01010100; // "T"
                       operation2 = 8'b00111010; // ":"
                       operation3 = 8'b00100000; // " "
                       operation4 = 8'b00100000; // " "
                       ShowPermission=0;
                       IsCMP=1'b0;
      end    
      4'b1110 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b1;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                    operation0 = 8'b01001100; // "L"
                    operation1 = 8'b01000100; // "D"
                    operation2 = 8'b00111010; // ":"
                    operation3 = 8'b00100000; // " "
                    operation4 = 8'b00100000; // " "
                    ShowPermission=0;
                    IsCMP=1'b0;
      end  
      4'b1100 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b1;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b0;
                        operation0 = 8'b01000011; // "C"
                        operation1 = 8'b01001101; // "M"
                        operation2 = 8'b01010000; // "P"
                        operation3 = 8'b00111010; // ":"
                        operation4 = 8'b00100000; // " "
                        ShowPermission=0;
                        IsCMP=1'b0;
      end  
      4'b1000 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b1;
                      NORT=1'b0;
                      XORT=1'b0;
                       operation0 = 8'b01001110; // "N"
                       operation1 = 8'b01000001; // "A"
                       operation2 = 8'b01001110; // "N"
                       operation3 = 8'b01000100; // "D"
                       operation4 = 8'b00111010; // ":"
                       ShowPermission=0;
                       IsCMP=1'b0;
      end  
      4'b1001 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b1;
                      XORT=1'b0;
                       operation0 = 8'b01001110; // "N"
                       operation1 = 8'b01001111; // "O"
                       operation2 = 8'b01010010; // "R"
                       operation3 = 8'b00111010; // ":"
                       operation4 = 8'b00100000; // " "
                       ShowPermission=0;
                       IsCMP=1'b0;
      end
      4'b1011 : begin ADD=1'b0;  
                      SUB=1'b0;
                      MUL=1'b0; 
                      ST=1'b0;
                      LDT=1'b0;
                      CMP=1'b0;
                      NANDT=1'b0;
                      NORT=1'b0;
                      XORT=1'b1;
                       operation0 = 8'b01011000; // "X"
                       operation1 = 8'b01001111; // "O"
                       operation2 = 8'b01010010; // "R"
                       operation3 = 8'b00111010; // ":"
                       operation4 = 8'b00100000; // " "
                       ShowPermission=0;
                       IsCMP=1'b0;
      end       
    endcase
end
       else if (Done && ADD)
       begin
            R0=sw[7:4];
				out={{4{R0[3]}},R0};
                bin_input=(out[7]==1'b1)? (~out+1'b1):out;
		 end	

           else if(Done2 && ADD)
           begin
            R1=sw[7:4];
            {R3,R2} = {{4{R1[3]}},R1} + {{4{R0[3]}},R0};
			out={R3,R2};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ADD=1'b0;
            op=1'b0;
             ShowPermission=1'b1;
           end


        else if (Done && SUB)
        begin
             R0=sw[7:4];
				 out={{4{R0[3]}},R0};
                 bin_input=(out[7]==1'b1)? (~out+1'b1):out;
        end
        else if(Done2 && SUB)
            begin
             R1=sw[7:4];
             temp = ~R1+4'b0001;
             {R3,R2} = {{4{R0[3]}},R0} + {{4{temp[3]}},temp};
				 out={R3,R2};
                 bin_input=(out[7]==1'b1)? (~out+1'b1):out;
             SUB=1'b0;
             op=1'b0;
              ShowPermission=1'b1;
            end
      


            else if (Done && MUL)
            begin
                     R0=sw[7:4];
					  out={{4{0}},R0};
                       bin_input=out;
            end
             
                else if(Done2 && MUL)
                begin
                 R1=sw[7:4];
              
               {R3,R2} = {{4{0}},R1} * {{4{0}},R0};
               // for (m = 0; m < 4; m = m + 1) begin
                 //           if (R0[m] == 1) begin
                   //             {R3,R2} = {R3,R2} + (R1<< m);
                     //       end
                       // end
                     bin_input={R3,R2};

            
                 MUL=1'b0;
                 op=1'b0;
                 ShowPermission=1'b1;
                end
              
           else if (Done && ST)
           begin
            R4=sw[7:4];
				out={{4{R4[3]}},R4};
                bin_input=(out[7]==1'b1)? (~out+1'b1):out;
              ST=1'b0;
              op=1'b0;
              ShowPermission=1'b1;
           end
			  
			else if (Done && LDT)
		  begin
			case(sw[7:4])
			4'b0000:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R0[3]}},R0};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0001:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R1[3]}},R1};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0010:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R2[3]}},R2};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end 
			4'b0011:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R3[3]}},R3};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0100:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R4[3]}},R4};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0101:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R5[3]}},R5};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0110:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R6[3]}},R6};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			4'b0111:
			begin
			LDT=1'b0;
			op=1'b0;
			out={{4{R7[3]}},R7};
            bin_input=(out[7]==1'b1)? (~out+1'b1):out;
            ShowPermission=1'b1;
			end
			endcase
		  end
			 else if (Done && XORT)
			begin
			 R5=sw[7:4];
			end
			 else if(Done2 && XORT)
			begin
			 R6=sw[7:4];
			 R7=R5 ^ R6;
             out={4'b0000,R7};
             bin_input=(out[7]==1'b1)? (~out+1'b1):out;
			 XORT=1'b0;
			 op=1'b0;
             ShowPermission=1'b1;
			end		  

             else if (Done && CMP)
            begin
             R5=sw[7:4];
            end
             else if(Done2 && CMP)
            begin
             R6=sw[7:4];
                if(R5>R6)
                R7=4'b0001;
                if(R5<R6)
                R7=4'b0000;
                if(R5==R6)
                R7=4'b0010;
             out={4'b0000,R7};
             bin_input=(out[7]==1'b1)? (~out+1'b1):out;
             IsCMP=1'b1;
             CMP=1'b0;
             op=1'b0;
				  ShowPermission=1'b1;
            end		  


			 else if (Done && NANDT)
			begin
			 R5=sw[7:4];
			end
			 else if(Done2 && NANDT)
			begin
			 R6=sw[7:4];
			 R7= ~(R5 & R6);
             out={4'b0000,R7};
             bin_input=(out[7]==1'b1)? (~out+1'b1):out;
			 NANDT=1'b0;
			 op=1'b0;
             ShowPermission=1'b1;
			end		  
			
		 else if (Done && NORT)
			begin
			 R5=sw[7:4];
			end
			 else if(Done2 && NORT)
			begin
			 R6=sw[7:4];
			 R7= ~(R5 | R6);
				out={4'b0000,R7};
             bin_input=(out[7]==1'b1)? (~out+1'b1):out;
             
			 NORT=1'b0;
			 op=1'b0;
             ShowPermission=1'b1;
			end		  
    end
	 
	


seg_display2  test(
    .clk(clk),
    .IsCMP(IsCMP),
    .LCD2SEG(LCD2SEG),
    .SEGoff(SEGoff),
    .N1(bcd[3:0]),
    .N2(bcd[7:4]),
    .N3(bcd[11:8]),
    .N4(out[7]),
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

bin2bcd testc(
    .bin(bin_input),
    .bcd(bcd)
);

bcdtoChar testb(
    .sign(out[7]),
    .bcd(bcd),
    .IsCMP(IsCMP),
    .numDisplay0(numDisplay0),
	.numDisplay1(numDisplay1),
	.numDisplay2(numDisplay2),
	.numDisplay3(numDisplay3)
);

LCDcontroller testa(
  .clk(clk),
  .INTENSITY(INTENSITY),
  .E(E),
  .RS(RS),
  .RW(RW),
  .ShowPermission(ShowPermission),
  .operation0(operation0),
  .operation1(operation1),
  .operation2(operation2),
  .operation3(operation3),
  .operation4(operation4),
  .numDisplay0(numDisplay0),
  .numDisplay1(numDisplay1),
  .numDisplay2(numDisplay2),
  .numDisplay3(numDisplay3),
  .Data(Data)
);

endmodule


module seg_display2 (
    input wire clk,
    input wire [3:0]N1,
    input wire [3:0]N2,
    input wire [3:0]N3,
    input wire N4,
    input wire IsCMP,
    input wire SEGoff,
    input wire LCD2SEG,
    output reg g,f,e,d,c,b,a,
	output reg seg0, seg1 ,seg2,seg3,dp
);
integer counter = 0;
integer cnt=0;
reg [1:0]cc = 2'b00;
reg new_clk ;
reg Run7segment;
initial Run7segment=1'b0;
always @(posedge clk)begin
    counter= counter+1;
	if(counter == 10000) begin
	  new_clk = ~new_clk;
	  counter =0;
	 end	 
end
always @(posedge new_clk) begin
		dp = 0;
if(LCD2SEG)
     Run7segment=1'b1;
if(SEGoff)
begin
 Run7segment=1'b0;
  seg0 = 1;
        seg1 = 1;
        seg2 = 1;
        seg3 = 1;
 end

    if(Run7segment)
    begin
    if(!IsCMP)
    begin    
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
              default:begin 
        {g,f,e,d,c,b,a} =0;
    end
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
              default:begin 
        {g,f,e,d,c,b,a} =0;
    end
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
              default:begin 
        {g,f,e,d,c,b,a} =0;
    end
        endcase
        seg0 = 1;
        seg1 = 0;
        seg2 = 1;
        seg3 = 1;
    end else if(cc == 2'b11) begin
		cc=2'b00;
        if( N4==1)
            {g,f,e,d,c,b,a} = 7'b1000000;
        else
            {g,f,e,d,c,b,a} = 7'b0000000;
        
        seg0 = 0;
        seg1 = 1;
        seg2 = 1;
        seg3 = 1;
    end
    end
    else
    begin
    case(N1)
            0 : {g,f,e,d,c,b,a} = 7'b0111000;  //L
            1 : {g,f,e,d,c,b,a} = 7'b1110110;  //H
            2 : {g,f,e,d,c,b,a} = 7'b1111001;  //E
            default:begin 
        {g,f,e,d,c,b,a} =0;
    end
    endcase
        seg0 = 1;
        seg1 = 1;
        seg2 = 1;
        seg3 = 0;
    end

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

module bcdtoChar (
    input [11:0] bcd,
    input sign,
    input wire IsCMP,
   output reg [7:0] numDisplay0,
	output reg [7:0] numDisplay1,
	output reg [7:0] numDisplay2,
	output reg [7:0] numDisplay3 	 
);

always @(bcd,sign,IsCMP) begin
    if(!IsCMP)
    begin
    case (sign)
    0: numDisplay0=8'b00101011;
    1: numDisplay0=8'b00101101;
    default:begin 
        numDisplay0=0;
    end
    endcase

    case (bcd[11:8])
        0: numDisplay1 = 8'b00110000;
        1: numDisplay1 = 8'b00110001;
        2: numDisplay1 = 8'b00110010;
        3: numDisplay1 = 8'b00110011;
        4: numDisplay1 = 8'b00110100;
        5: numDisplay1 = 8'b00110101;
        6: numDisplay1 = 8'b00110110;
        7: numDisplay1 = 8'b00110111;
        8: numDisplay1 = 8'b00111000;
        9: numDisplay1 = 8'b00111001;
        default:begin 
        numDisplay1=0;
    end
  
    endcase

   
    case (bcd[7:4])
        0: numDisplay2 = 8'b00110000;
        1: numDisplay2 = 8'b00110001;
        2: numDisplay2 = 8'b00110010;
        3: numDisplay2 = 8'b00110011;
        4: numDisplay2 = 8'b00110100;
        5: numDisplay2 = 8'b00110101;
        6: numDisplay2 = 8'b00110110;
        7: numDisplay2 = 8'b00110111;
        8: numDisplay2 = 8'b00111000;
        9: numDisplay2 = 8'b00111001;
        default:begin 
        numDisplay2=0;
		  end
    endcase
   

    case (bcd[3:0])
        0: numDisplay3 = 8'b00110000;
        1: numDisplay3 = 8'b00110001;
        2: numDisplay3 = 8'b00110010;
        3: numDisplay3 = 8'b00110011;
        4: numDisplay3 = 8'b00110100;
        5: numDisplay3 = 8'b00110101;
        6: numDisplay3 = 8'b00110110;
        7: numDisplay3 = 8'b00110111;
        8: numDisplay3 = 8'b00111000;
        9: numDisplay3 = 8'b00111001;
        default:begin 
        numDisplay3=0;
    end
  
    endcase
    end
    else
    begin
    case (bcd[3:0])
    0: numDisplay0=8'b01001100;
    1: numDisplay0=8'b01000111;
    2: numDisplay0=8'b01000101;
    default:begin 
        numDisplay0=0;
    end
  
    endcase
    end
end
endmodule

module LCDcontroller (
    input wire clk,
    output reg E,RS,
	output wire RW,INTENSITY,
    input wire ShowPermission,
    input wire [7:0] operation0,
	input wire [7:0] operation1,
	input wire [7:0] operation2,
	input wire [7:0] operation3,
	input wire [7:0] operation4,
    input wire [7:0] numDisplay0,
	input wire [7:0] numDisplay1,
	input wire [7:0] numDisplay2,
	input wire [7:0] numDisplay3,
    output reg [7:0]Data
);
reg new_clk;
assign RW=1'b0;
assign INTENSITY=1'b1;
integer counter = 0;
reg [5:0] State=6'b000000;
reg Stop;
initial Stop=1'b0;
always @(posedge clk)begin
    counter= counter+1;
	if(counter == 100000) begin //50hz frequency
	  new_clk = ~new_clk;
	  counter =0;
	 end	 
end

wire [7:0] Functionset;
wire [7:0] Clear;
wire [7:0] Display;
wire [7:0] Returnhome;
wire [7:0] Line1;
wire [7:0] Line2;


assign Functionset=8'b0011_1100;
assign Clear= 8'b0000_0001;
assign Display= 8'b0000_1100;
assign Returnhome= 8'b0000_0010;
assign Line1= 8'b1000_0000;
assign Line2= 8'b1100_0000;



always @(posedge new_clk) begin
  if(ShowPermission )
  begin
     case (State)
    0: begin E<=0;
       RS<=0;
       State=State+1;
    end
    1: begin E<=1;
      State=State+1;
    end
    2: begin Data <= Functionset; 
       State=State+1;
    end
    3: begin E<=0;
      State=State+1;
    end
    4: begin
        E<=1;
        State=State+1;
    end
    5: begin Data <= Returnhome; 
       State=State+1;
    end
    6: begin E<=0;
      State=State+1;
    end
    7: begin
        E<=1;
        State=State+1;
    end
    8: begin Data <= Clear; 
       State=State+1;
    end
    9: begin E<=0;
      State=State+1;
    end
    10: begin
        E<=1;
        State=State+1;
    end
    11: begin Data <= Display; 
       State=State+1;
    end
    12: begin E<=0;
      State=State+1;
    end
    13: begin
        RS<=1;
		   State=State+1;
    end
    14: begin
        E<=1;
        State=State+1;
    end
    15: begin Data <= operation0; 
        State=State+1;
        end
    16: begin
        E<=0;
        State=State+1;
    end
    17: begin
        E<=1;
        State=State+1;
    end
    18: begin Data <= operation1; 
        State=State+1;
        end
    19: begin
        E<=0;
        State=State+1;
    end
    20: begin
        E<=1;
        State=State+1;
    end
    21: begin Data <= operation2; 
        State=State+1;
        end
    22: begin
        E<=0;
        State=State+1;
    end
    23: begin
        E<=1;
        State=State+1;
    end
    24: begin Data <= operation3; 
        State=State+1;
        end
    25: begin
        E<=0;
        State=State+1;
    end
    26: begin
        E<=1;
        State=State+1;
    end
    27: begin Data <= operation4; 
        State=State+1;
        end
    28: begin
        E<=0;
        State=State+1;
    end
    29: begin
         RS<=0;
        State=State+1;
    end
    30: begin E<=1;
      State=State+1;
    end
    31: begin Data <= Line2; 
       State=State+1;
    end
    32: begin E<=0;
      State=State+1;
    end
    33: begin
        RS<=1;
         State=State+1;
    end
    34: begin
        E<=1;
        State=State+1;
    end
    35: begin Data <= numDisplay0; 
        State=State+1;
        end
    36: begin
        E<=0;
        State=State+1;
    end
    37: begin
        E<=1;
        State=State+1;
    end
    38: begin Data <= numDisplay1; 
        State=State+1;
        end
    39: begin
        E<=0;
        State=State+1;
    end
    40: begin
        E<=1;
        State=State+1;
    end
    41: begin Data <= numDisplay2; 
        State=State+1;
        end
    42: begin
        E<=0;
        State=State+1;
    end
    43: begin
        E<=1;
        State=State+1;
    end
    44: begin Data <= numDisplay3; 
        State=State+1;
        end
    45: begin
        E<=0;
        State=State+1;
    end
    46: begin
        RS<=0;
		  State=State+1;
    end
	 47: begin
        E<=1;
		  State=State+1;
    end
	 48: begin
        Data <= 8'b10000000;
		  State=State+1;
    end
	 49: begin
        RS<=0;
		  State=State+1;
    end
	 50: begin
        E<=0;
		  State=State+1;
    end
	 51: begin
        RS<=0;
		  State=6'b00001101;
    end
    default:begin E<=0;
       RS<=0;
    end
 endcase   
  end
  end
endmodule
