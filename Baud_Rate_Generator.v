module Baud_Rate_Generator#(
parameter CLOCK_RATE    = 50000000,
parameter BAUD_RATE     = 115200,
parameter RX_OVERSAMPLE = 16
)(
//Global signals
input clk,
input reset_n,
//RX and TX Baud rates
output reg tx_clk_tic,
output reg rx_clk_tic
);

parameter TX_CNT_value = CLOCK_RATE / (2* BAUD_RATE);
parameter RX_CNT_value = CLOCK_RATE / (2*BAUD_RATE*RX_OVERSAMPLE);
parameter TX_CNT_WIDTH = $clog2(TX_CNT_value);
parameter RX_CNT_WIDTH = $clog2(RX_CNT_value);

reg [TX_CNT_WIDTH - 1: 0] tx_counter;
reg [RX_CNT_WIDTH - 1: 0] rx_counter;

//RX Baudrate
always @(posedge clk or negedge reset_n)
begin
    if(!reset_n)
       begin
           rx_counter <= 0; 
           rx_clk_tic <= 1'b0;
       end
    else if(rx_counter == RX_CNT_value - 1)
        begin
            rx_clk_tic <= ~rx_clk_tic;
            rx_counter <= 0;
        end
    else
        begin
            rx_counter <= rx_counter + 1'b1;
        end
end
// TX Baudrate
always @(posedge clk or negedge reset_n)
begin
    if(!reset_n)
       begin
           tx_counter <= 0; 
           tx_clk_tic <= 1'b0;
       end
    else if(tx_counter == TX_CNT_value - 1)
        begin
            tx_clk_tic <= ~tx_clk_tic;
            tx_counter <= 0;
        end
    else
        begin
            tx_counter <= tx_counter + 1'b1;
        end
end

endmodule
