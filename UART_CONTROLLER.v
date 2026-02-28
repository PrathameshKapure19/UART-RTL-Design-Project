
`include "Baud_Rate_Generator.v"
`ifdef UART_TX_ONLY
`include "UART_TX_CONTROLLER.v"
`elsif UART_RX_ONLY
`include "UART_RX_CONTROLLER.v"
`else
`include "UART_TX_CONTROLLER.v"
`include "UART_RX_CONTROLLER.v"
`endif
module UART_CONTROLLER#(parameter CLOCK_RATE = 0,
                        parameter BAUD_RATE  = 0,
                        parameter RX_OVERSAMPLE = 1)(

input clk,
input reset_n,

`ifdef UART_TX_ONLY  // If controller is working as Transmitter only
 input    [7:0] Din, 
 input    tx_ready,  
 output   tx,        
 output   tx_Done,   
 output   tx_Active
  
`elsif UART_RX_ONLY // If controller is working as Recevier only
 input  rx,      
 output rx_Done, 
 output [7:0]Dout 

`else              //  If controller is working as both Transmitter and Receiver

   input[7:0]  Din,
   input       tx_ready,
   output      rx_Done,
   output[7:0] Dout
   
`endif     
    );
    
    wire    tx_clk_tic , rx_clk_tic;
    wire    w_Tx_DATA_to_Rx;
    
   `ifdef UART_TX_ONLY
        assign tx = w_Tx_DATA_to_Rx;
    `elsif UART_RX_ONLY
        assign w_tx_DATA_to_tx = rx;
    `endif

//Instantiate Baud Rate Generator    
    Baud_Rate_Generator #(CLOCK_RATE, BAUD_RATE, RX_OVERSAMPLE) baud_gen
    (
        .clk(clk),            
        .reset_n(reset_n),       
        .tx_clk_tic(tx_clk_tic),
        .rx_clk_tic(rx_clk_tic) 
    );
    
    `ifdef UART_TX_ONLY
    
    //Instantiate UART_Tx_Controller
     UART_TX_CONTROLLER UART_TX(
            .clk(tx_clk_tic),        
            .reset_n(reset_n),    
            .Din(Din),  
            .tx_ready(tx_ready),   
       		.tx(w_Tx_Data_To_Rx),         
            .tx_Done(tx_Done),    
            .tx_Active(tx_Active)   
        );
        
    `elsif UART_RX_ONLY
    //Instantiate UART_RX_Controller
  UART_RX_CONTROLLER#(RX_OVERSAMPLE) UART_RX(
    .clk(rx_clk_tic),     
            .reset_n(reset_n), 
            .rx(w_Tx_Data_To_Rx),      
            .rx_Done(rx_Done), 
            .Dout(Dout)
        );
      `else
        
            UART_TX_CONTROLLER xUART_TX(
                	.clk(tx_clk_tic),        
                   .reset_n(reset_n),    
                   .Din(Din),  
                   .tx_ready(tx_ready),   
              .tx(w_Tx_Data_To_Rx),         
                   .tx_Done(),    
                   .tx_Active()   
               );
               
  UART_RX_CONTROLLER#(RX_OVERSAMPLE) xUART_RX(
    				.clk(rx_clk_tic),         
                    .reset_n(reset_n), 
                    .rx(w_Tx_Data_To_Rx),           
                    .rx_Done(rx_Done), 
                    .Dout(Dout)        
               );
       `endif
        
endmodule
