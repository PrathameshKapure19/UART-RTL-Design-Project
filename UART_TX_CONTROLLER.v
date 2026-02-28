module UART_TX_CONTROLLER(

input  clk,
input  reset_n,
input  [7:0] Din,
input  tx_ready,
output tx,
output tx_Done,
output tx_Active

    );
    
  localparam IDLE  = 2'd0,
             START = 2'd1,
             DATA  = 2'd2,
             STOP  = 2'd3;
             
 reg [2:0] index;
 reg [1:0] state;
 reg r_tx_Done;
 reg r_tx_Data;
 reg r_tx_Active;  
 
 //UART Tx Logic Implementation
 always@(posedge clk or negedge reset_n)
 begin
    if(!reset_n)
    begin
        state       <= IDLE;
        index       <= 0;
        r_tx_Done   <= 1'b0;
        r_tx_Data   <= 1'b1;
        r_tx_Active <= 1'b0;
    end
    else
    begin
        case(state)
        IDLE:
            begin
                index       <= 0;
                r_tx_Done   <= 0;
                r_tx_Data   <= 1'b1;
                r_tx_Active <= 1'b0;
                
                if(tx_ready == 1)
                    begin
                        state       <= START;
                        r_tx_Active <= 1'b1;
                    end
                else
                    begin
                        state <= IDLE;
                    end
           end
        START:
            begin
                r_tx_Data <= 1'b0;
                state     <= DATA;
            end
         DATA:
            begin
                r_tx_Data <= Din[index];
                if(index < 7)
                    begin
                        index <= index + 1;
                        state <= DATA;
                    end
                else
                    begin
                        index <= 0;
                        state <= STOP;
                    end
            end
         STOP:
            begin
                state       <= IDLE;
                r_tx_Done   <= 1'b1;
                r_tx_Active <= 1'b0;
                r_tx_Data   <= 1'b1;
            end
         default:
         begin
                state <= IDLE;
         end
        endcase
    end
 end    
  
  assign tx_Done    = r_tx_Done;
  assign tx_Active  = r_tx_Active;
  assign tx       = r_tx_Data;            
endmodule
