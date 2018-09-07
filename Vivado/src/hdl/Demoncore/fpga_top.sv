`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AC-1
// Engineer: Bryan Cole
// 
// Create Date: 08/10/2018 06:09:04 PM
// Module Name: fpga_top
// Project Name: AC-1
// Target Devices: 
// Tool Versions: 
// Description: Design Top connecting all major mocules
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module fpga_top(
	input sys_clk_i,
	input CPU_RESETN,
	output [10:0] LED,
	
	//*** ddr mem controller
    // Inouts
    inout   [15:0]  ddr2_dq,
    inout   [1:0]   ddr2_dqs_n,
    inout   [1:0]   ddr2_dqs_p,
    // Outputs
    output  [12:0]  ddr2_addr,
    output  [2:0]   ddr2_ba,
    output  [0:0]   ddr2_ras_n,
    output  [0:0]   ddr2_cas_n,
    output          ddr2_we_n,
    output          ddr2_ck_p,
    output          ddr2_ck_n,
    output  [0:0]   ddr2_cke,
    output  [0:0]   ddr2_cs_n,
    output  [1:0]   ddr2_dm,
    output  [0:0]   ddr2_odt,
    //*** end mem controller

    //*** UART Communication
	input UART_TXD_IN,
	output UART_RXD_OUT
	//*** end UART Com
    );
	logic [7:0] data_in, data_in_q;
	logic data_ready;
    logic [13:0] baud_counter;
    logic baud_clock, clk_out_200_Mhz;
    
	assign LED[7:0] = data_in_q;

	always_ff @(posedge sys_clk_i)begin
	    if(data_ready)
            data_in_q <= data_in;
        else
            data_in_q <= data_in_q;
	end
	
	UART_com UART_com_i(
			.clock_100_Mhz(sys_clk_i), .reset(CPU_RESETN), .trans_en(baud_clock & data_ready), .Rx(UART_TXD_IN),
			.data_out(data_in_q),
			.data_rdy(data_ready), .Tx(UART_RXD_OUT),
			.data_in(data_in)
	    );
	    
    always_ff@( posedge sys_clk_i or negedge CPU_RESETN)begin
        if(!CPU_RESETN)begin
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

    clk_wiz_0 clock_gen_200Mhz 
     (
      // Clock out ports
      .clk_out_200_Mhz(clk_out_200_Mhz),
      // Status and control signals
      .resetn(CPU_RESETN),
      .locked(), //TODO create logic to ensure this is not used when it is locked
     // Clock in ports
      .clk_in1(sys_clk_i)
     );


    ddr_wrapper ddr_wrapper_i(
        // Inouts
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_n(ddr2_dqs_n),
        .ddr2_dqs_p(ddr2_dqs_p),
        // Outputs
        .ddr2_addr(ddr2_addr),
        .ddr2_ba(ddr2_ba),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_cke(ddr2_cke),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_odt(ddr2_odt),
        // Single-ended 200 Mhz clock
        .clk_200_Mhz(clk_out_200_Mhz)
    );
endmodule
