
module UART_TB;
parameter C_CLOCK_PERIOD_NS = 20;
parameter C_CLKS_PER_BIT    = 434;
parameter C_BIT_PERIOD      = 8680;

reg clk = 0;
reg reset_n = 0;
`ifdef UART_TX_ONLY
    wire tx_Done;
    reg  tx_ready = 0;
    wire tx_Active;
    wire tx;
  reg  [7:0] Din = 0;

`elsif UART_RX_ONLY
    wire [7:0] Dout;
    reg  rx = 0;
    wire rx_Done;
    
  
 `else
    wire rx_Done;
    wire [7:0] Dout;
    reg  [7:0] Din = 0;
    reg  tx_ready  = 0;
    
  reg [7:0] DatatoSend[0:7] = {8'h01, 8'h10, 8'h22, 8'h32, 8'h55, 8'hAA, 8'hAB, 8'h88};
  reg [7:0] DataToSend_1[0:7] = {8'h21, 8'h11, 8'h32, 8'h77, 8'hA0, 8'h0B, 8'hBB, 8'hFF};
  reg [7:0] DataReceived[0:7];
    integer j;
  `endif
  
  `ifdef UART_TX_ONLY
    UART_CONTROLLER #(.CLOCK_RATE(50_000_000),.BAUD_RATE(115200)) UART_TX(
    .clk(clk),              
    .reset_n(reset_n),      
    .Din(Din),              
    .tx_ready(tx_ready),    
    .tx(tx),                
    .tx_Done(tx_Done),      
    .tx_Active(tx_Active)   
    );
   
   `elsif UART_RX_ONLY
   
        UART_CONTROLLER#(.CLOCK_RATE(50_000_000),.BAUD_RATE(115200),.RX_OVERSAMPLE(16)) UART_RX(
         .clk(clk),         
         .reset_n(reset_n), 
         .rx(rx),           
         .rx_Done(rx_Done), 
         .Dout(Dout)
         );    
         
     `else
        UART_CONTROLLER#(.CLOCK_RATE(50_000_000),.BAUD_RATE(115200),.RX_OVERSAMPLE(16))UART(
        .clk(clk),
        .reset_n(reset_n),
        .Din(Din),
        .tx_ready(tx_ready),

        .rx_Done(rx_Done),
        .Dout(Dout)
        );
        
        `endif
        
       always #(C_CLOCK_PERIOD_NS/2) clk = ~clk;
       
       `ifdef UART_TX_ONLY
        reg [7:0] DataTosend_tx = 8'b0101_0101;
        initial begin
            #5 reset_n = 1;
            @(posedge clk);
            @(posedge clk);
            tx_ready = 1'b1;
            @(posedge clk);
            Din = DataTosend_tx;
            #1_00_000;
            $finish();
        end
        
        `elsif UART_RX_ONLY
            reg [7:0] DataTosend_rx = 8'b1110_1010;
            integer i;
            initial begin
                #5 reset_n = 1;
                @(posedge clk);
                rx = 0;
                for(i = 0 ;i < 8 ;i = i +1)
                begin
                    #(20*435);
                    @(posedge clk)rx = DataTosend_rx[i];
                end
                #85000;
                $finish;
            end
            
            `else// UART TX + RX Controller else
            initial begin
            #5 reset_n = 1;
           @(posedge clk);
           @(posedge clk);
            tx_ready <= 1'b1;
            for(j =0;j < 8 ; j=j+1)
            begin
                Din = DatatoSend[j];
               @(posedge rx_Done);
                DataReceived[j] = Dout;
                if(DatatoSend[j] == DataReceived[j])
                    begin
                        $display("Test Passed - Correct Byte Received:|Tx Data Byte = %h|Rx Data Byte = %h|",DatatoSend[j],DataReceived[j]);
                    end 
                 else
                    begin
                          $display("Test Failed - incorrect Byte Received:|Tx Data Byte = %h|Rx Data Byte = %h|",DatatoSend[j],DataReceived[j]);
                    end
                   
            end
            #800000
            $finish();
            end
         `endif    
        initial
          begin
          $dumpfile("dump.vcd");
          $dumpvars(0,UART_TB);
        end
         
endmodule
