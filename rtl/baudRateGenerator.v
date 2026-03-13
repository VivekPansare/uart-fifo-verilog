module baudRateGenerator(input clk,output reg tx_enb,output reg rx_enb);

reg [12:0]count1=0;
reg [9:0]count2=0;

always @(posedge clk) begin
    tx_enb <= 1'b0;
    rx_enb <= 1'b0;

    if (count1 == 5207) begin
        count1 <= 0;
        tx_enb <= 1'b1;
    end
    else begin
        count1 <= count1 + 1;
    end

    if (count2 == 324) begin
        count2 <= 0;
        rx_enb <= 1'b1;
    end
    else begin
        count2 <= count2 + 1;
    end
end
endmodule 
