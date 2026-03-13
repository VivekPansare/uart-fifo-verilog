module tx(input clk,input wr_enb,input tx_enb,input rst,input [7:0]data_in,output reg tx,output busy);

reg [2:0]count;
reg [7:0]temp;
parameter idle=2'b00,start=2'b01,data=2'b10,stop=2'b11;
reg [1:0]state=idle;


always@(posedge clk)
begin
     if(rst)   begin   state <= idle;
        tx    <= 1'b1;
        count <= 0;
        temp<= 0;
end
else begin
    case(state)
    idle:if(wr_enb) begin state<=start; count<=0;temp<=data_in; end
        
    start:begin  
           if(tx_enb) begin state<=data;tx<=1'b0; end
           end
    data:if(tx_enb)begin if(count==7) begin tx<=temp[count]; state<=stop;  end
                         else begin count<=count+1; tx<=temp[count];end
                    end
                  
    stop:if(tx_enb)begin tx<=1'b1; state<=idle ; end
        
    endcase
end
end
assign busy=(state!=idle);

endmodule
