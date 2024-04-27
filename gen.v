module gen (
   input clk,
   input en,
   input [3:0] ton,
   output signed [7:0] data
);

reg [15:0] st = 0;
reg [2:0] adr;
reg [15:0] korak;
reg signed [7:0] tab[0:7];

initial begin
 tab[0]=8'hc;
 tab[1]=8'h25;
 tab[2]=8'h3c;
 tab[3]=8'h51;
 tab[4]=8'h62;
 tab[5]=8'h70;
 tab[6]=8'h7a;
 tab[7]=8'h7e;
end

assign data = (st[15] == 0)? tab[adr] : ( ~tab[adr]);

always @* begin
  korak = 0;
  if (ton==1) korak=16'd172;  

  if (st[14] == 1)
     adr = ~st[13:11];
  else
     adr = st[13:11];  
end

always @(posedge clk)
 begin
  if (en) begin
     st <= st + korak;
  end
 end

endmodule
