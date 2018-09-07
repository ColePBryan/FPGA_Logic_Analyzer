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


module UART_receiver #(parameter INPUT_CLK_KHZ = 100_000, BAUD_RATE =9600)(
    input input_clk, reset, Rx,
    output logic[7:0]data_received,
    output logic     data_rdy
    );
    
    // localparam real BAUD_HALF_PERIOD_NS = 10**6/( BAUD_RATE * 2 );
    // localparam real INPUT_CLK_HZ = INPUT_CLK_KHZ * 1000 ;
    // localparam integer BAUD_COUNT = BAUD_HALF_PERIOD_NS * INPUT_CLK_HZ;

    localparam real BAUD_RATE_KHZ = BAUD_RATE / 1000.0;
    localparam integer BAUD_COUNT = (INPUT_CLK_KHZ / (BAUD_RATE_KHZ * 2) - 1);




    typedef enum {IDLE, TRANS} uart_state;
    uart_state current_state, next_state;
    
    logic [3:0] bit_counter;
    logic [12:0] baud_counter;
    logic baud_clock;
    logic [7:0] data_received_d;
    logic shift;
    
    
    /*Block Output Until Ready*/
    always @(*)begin
        data_received <= data_rdy? data_received_d : 8'b0 ;
    end
    
    /*Create Baud Clock*/
    always_ff@( posedge input_clk or negedge reset)begin
        if(~reset)begin
            baud_counter<= 14'b0;
            baud_clock <= 1'b0;
        end else begin
            if (baud_counter == BAUD_COUNT) begin
                baud_clock <= ~baud_clock;
                baud_counter <= 14'b0;
            end else begin
                baud_counter <= baud_counter + 14'b1;
            end
        end
    end

    /*Control Data Path*/
    always_ff@( posedge baud_clock or negedge reset) begin
        if(~reset) begin
            bit_counter <= 0;
            data_received_d <= 0;
        end else begin
            if (shift)begin
                bit_counter <= bit_counter + 1;
                data_received_d[bit_counter] <= Rx;
            end else begin 
                bit_counter <= 0;
                data_received_d <= data_received_d;
            end
        end
    end

    /*Control State Logic*/
    always_ff @(posedge baud_clock or negedge reset) begin
        if(~reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    /*Combinational Logic*/
    always_comb begin
        case (current_state)
            IDLE: begin
                if(reset & !Rx)begin
                    shift = 1'b0;
                    data_rdy =1'b0;
                    next_state = TRANS;
                end else begin
                    shift = 1'b0;
                    data_rdy =1'b0;
                    next_state = IDLE;
                end
            end
            TRANS: begin
                if(bit_counter < 4'd8)begin
                    data_rdy =1'b0;
                    next_state = TRANS;
                    shift = 1'b1;
                end else begin
                    next_state = IDLE;
                    shift = 1'b0;
                    data_rdy =1'b1;
                end
            end
            default: begin
                shift = 1'b0;
                data_rdy =1'b0;
                next_state = IDLE;
            end
        endcase
    end
    
endmodule
