`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018 06:18:47 PM
// Design Name: 
// Module Name: UART_transmitter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_transmitter(
    input input_clk, reset, trans_en,
    input [7:0]     data_out,
    output logic          Tx
    );
    typedef enum {IDLE, TRANS} uart_state;
    uart_state current_state, next_state;
    
    logic [3:0] bit_counter;
    logic [12:0] baud_counter;
    logic [9:0] data_packet;
    logic baud_clock;
    
    logic shift, load, clear;
    
    always_ff@( posedge input_clk or negedge reset)begin
        if(!reset)begin
            baud_counter<= 14'b0;
            baud_clock <= 1'b0;
        end else begin
            if (baud_counter == 14'd5207) begin
                baud_clock <= ~baud_clock;
                baud_counter <= 14'b0;
            end else begin
                baud_counter <= baud_counter + 14'b1;
            end
        end
    end
    always_ff@( posedge baud_clock or negedge reset) begin
        if(!reset) begin
            current_state <= IDLE;
            data_packet <= 10'b0;
            bit_counter <= 0;
        end else begin
            current_state <= next_state;
            if (shift)begin
                data_packet <= data_packet >> 1;
                bit_counter <= bit_counter - 1;
            end else begin
                bit_counter <= 4'd10;
                data_packet <= {1'b1,data_out,1'b0};
            end
        end
    end
    
    always_comb begin
        case (current_state)
            IDLE: begin
                if(reset & trans_en)begin
                    next_state <= TRANS;
                    shift <= 1'b0;
                    Tx <= 1'b1;
                end else begin
                    next_state <= IDLE;
                    shift <= 1'b0;
                    Tx <= 1'b1;
                end
            end
            TRANS: begin
                if(bit_counter > 4'b0)begin
                    shift <= 1'b1;
                    Tx <= data_packet[0];
                    next_state <= TRANS;
                end else begin
                    next_state <= IDLE;
                    shift <= 1'b0;
                    Tx <= 1'b1;
                end
            end
            default: begin
                next_state <= IDLE;
                Tx <= 1'b1;
                shift <= 1'b0;
            end
        endcase
    end
    
endmodule
