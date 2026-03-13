module rx(input clk,rdy_clr,rx_enb,rx,rst,output reg rdy,output reg [7:0]data_out);
reg [2:0]count=0;
reg [3:0]sample=0;
reg [7:0] temp;

parameter start=2'b00,dataout=2'b01,stop=2'b10;
reg [1:0] state=start;



always@(posedge clk)
begin

if(rst) begin
    state  <= start;
    sample <= 0;
    count  <= 0;
    temp   <= 0;
    rdy    <= 0;
    data_out <= 0;
end
else begin

if(rdy_clr) rdy<=0;
else begin 
if(rx_enb) begin       
case(state)
start: begin
    if(rx == 0) begin                    // start bit detected
        if(sample == 15) begin            // middle of start bit (16/2 - 1)
            sample <= 0;                 // align for data bits
            state  <= dataout;              // move to data state
        end
        else begin
            sample <= sample + 1;        // keep counting
        end
    end
    else begin
        sample <= 0;                     // line went high again → false start
    end
end


dataout: if(sample==15) begin if(count==7) begin state<=stop; sample<=0;count<=0; end
                           else begin sample<=0; count<=count+1; end
                     end
       else if(sample==8) begin temp[count]<=rx; sample<=sample+1; end
       else sample<=sample+1;  

stop: begin
    if(sample == 15) begin
        if(rx == 1) begin
            data_out <= temp;
            rdy      <= 1'b1;
            
        end
        state  <= start;
        sample <= 0;
    end
    else begin
        sample <= sample + 1;
    end
end                            
endcase
end
end    
end
end
endmodule
