`timescale 1ns/1ps
module UARTtoptb;
wire [7:0]data_out;
wire rdy;
reg [7:0]data_in;
reg clk,rst,rdy_clr;
wire busy,ftwr,ftrd,frwr,frrd,full;

top t(rst,data_in,clk,rdy_clr,full,ftwr,ftrd,frwr,frrd,rdy,busy,data_out);

integer i;


task clrReady ;
begin
    @(negedge clk);
    rdy_clr=1'b1;
    @(negedge clk);
    rdy_clr=1'b0;
end endtask    
always #5 clk=~clk;


initial begin

    clk     = 0;
    rst     = 1;
    data_in = 0;
    rdy_clr = 0;
   
    
    #50 rst = 0;   // release reset after some time

for(i=0;i<25;i=i+1) begin
    wait(!full);
    @(negedge clk);
    data_in = $random;
end
// for(i=0;i<25;i=i+1) begin
// @(negedge clk)
// data_in= $urandom_range(0,255);
// end

end


initial 
#50
begin
for(i=0;i<25;i=i+1) begin
@(posedge rdy)
clrReady;
end

    #10000 $finish;

end


 
 initial begin
   
     $monitor("time=%0t rst=%b data_in=%h tx=%b busy=%b intx=%h  rdy=%b outrx=%h txemp=%b data_out=%h ", $time,rst,data_in,t.tx,t.s.busy,t.data_out_F,t.r.rdy,t.data_out_r,t.tx_empty,data_out);
 ends
endmodule


