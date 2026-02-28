
module UART_RX_CONTROLLER #(parameter RX_OVERSAMPLE = 0)(

input  clk,
input  reset_n,
input  rx,
output rx_Done, // Asserted for 1 clk cycle after receving one byte of data
output [7:0]Dout
);
localparam IDLE  =  2'd0,
           START =  2'd1,
           DATA  =  2'd2,
           STOP  =  2'd3;
           
  reg [7:0] rx_Data;
  reg [2:0] index;
  reg [4:0] counter;
  reg r_rx_Done;
  reg [1:0]state;

always@(posedge clk or negedge reset_n)
begin
    if(!reset_n)
    begin
        state     <= IDLE;
        rx_Data   <= 8'd0;
        index     <= 3'd0;
        counter   <= 5'd0;
        r_rx_Done <= 1'b0;
         
    end
    
    else
    begin
        case(state)
        IDLE:
        begin
            index     <= 3'd0;
            counter   <= 5'd0;
            r_rx_Done <= 1'b0;
            
            if(rx == 1'b0)
                begin
                    state <= START;
                end
            else
                begin
                    state <= IDLE;
                end
         end
        START:
        begin
            if(counter == RX_OVERSAMPLE/2)
                begin
                    if(rx == 1'b0)
                        begin
                            state <= DATA;
                            counter <= 0;
                        end
                    else
                        begin
                            state <= IDLE;
                        end
                end
             else
                 begin
                    state   <= START;
                    counter <= counter + 1;
                 end
        end
        DATA:
        begin
            if(counter < (RX_OVERSAMPLE))
                begin
                    state   <= DATA;
                    counter <= counter + 1;
                end
            else
                begin
                    rx_Data[index] <= rx;
                    counter <= 5'd0;
                    if(index < 7)
                        begin
                            index <= index + 1;
                            state <= DATA;
                        end 
                     else
                        begin
                            index <= 3'd0;
                            state <= STOP;
                        end
                end
        end
        STOP:
        begin
            if(counter < (RX_OVERSAMPLE))
                begin
                    state   <= STOP;
                    counter <= counter + 1;
                end
            else
                begin
                    state   <= IDLE;
                    counter <= 5'd0;
                    r_rx_Done <= 1'b1;
                end
           end
        default:
         begin
            state <= IDLE;
        end
      endcase
 end
end 
 assign rx_Done = r_rx_Done; 
 assign Dout = (r_rx_Done) ? rx_Data : 8'h00;
  
endmodule
