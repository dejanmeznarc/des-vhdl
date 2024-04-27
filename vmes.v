module vmes //vmesnik za 12 tipk
( 
  input clk,
  input sdata,
  output reg clk1,
  output reg shld,
  output reg [11:0] tipka 
);

reg [3:0] d;
reg [3:0] e;
reg [15:0] g;

always @(posedge clk) begin
 e <= e+1;
 if (e==0) begin
   clk1 <= ~clk1;
   if (clk1==1) begin
	  g <= {g[14:0],sdata}; 
	  d <= d+1;
     if (d==15) shld <= 0;
	  else shld <= 1;     
     if (shld==0) tipka<=g[11:0];
   end       
 end
end
  
endmodule
