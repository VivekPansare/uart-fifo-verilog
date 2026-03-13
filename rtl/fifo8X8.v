module FIFO8x8(input clk,rst,wr_enb,rd_enb,input [7:0]data_in_F,output full,empty,almost_full,almost_empty,output reg overflow,underflow,output reg [7:0]data_out_F);

parameter width=8,depth=8,ptrW=3;
localparam COUNT_W = $clog2(depth+1);
reg [COUNT_W-1:0] count;

reg [width-1:0] datal[depth-1:0];
reg [ptrW-1:0]rear,front;

integer i;

always@(posedge clk)
begin
    if(rst) begin 
   for (i=0;i<depth;i=i+1) datal[i]<=0;
        rear<=0;
        data_out_F<=0;
        front<=0;
        count<=0;
        overflow<=0;
        underflow<=0;
            end
     else 
     begin
      
      overflow <= (wr_enb && full);
      underflow <= (rd_enb && empty); 

          case ({wr_enb && !full, rd_enb && !empty})
            2'b10: count <= count + 1; // write only
            2'b01: count <= count - 1; // read only
            2'b11: count <= count;     // both → no change
            default:count<=count;
        endcase

     
     if(wr_enb && !full) begin
                datal[rear]<=data_in_F;
                rear<=rear+1;
        
                end    
     if(rd_enb && !empty) begin
                data_out_F<=datal[front];
                front<=front+1;
               
                end                
     
     end          
end

assign full=(count==depth);
assign empty=(count==0);
assign almost_full  = (count == depth-1);
assign almost_empty = (count == 1);
endmodule
