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
	output [15:0] LED,
	
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
    output  [0:0]   ddr2_ck_p,
    output  [0:0]   ddr2_ck_n,
    output  [0:0]   ddr2_cke,
    output  [0:0]   ddr2_cs_n,
    output  [1:0]   ddr2_dm,
    output  [0:0]   ddr2_odt,
    //*** end mem controller

    //*** UART Communication
	input UART_TXD_IN,
	output UART_RXD_OUT,
	//*** end UART Com
	output [8:1] JD,JC
    );
	logic [7:0] data_in, data_in_q;
	logic data_ready;
    logic [13:0] baud_counter;
    logic baud_clock, clk_out_200_Mhz;
    reg [63:0] ddr_read_q;
    wire [63:0]ddr_read;
    // wire read_valid;
    // reg read_valid_q;
    reg read_request, trans_en;
    logic read_available;
    
	assign LED[4:0] = data_in_q;
	assign LED[5] = data_ready;
    assign LED[9:6] = ddr_wrapper_i.write_current_state;
    assign LED[13]	= ddr_wrapper_i.read_available ;
    assign LED[14]	= ddr_wrapper_i.app_wdf_rdy ;
    assign LED[15]	= ddr_wrapper_i.app_rdy ;
    assign LED[11]  = UART_com_i.UART_transmitter_i.trans_en;





    always @(posedge baud_clock)begin 
    	if(data_ready) begin
    		data_in_q <= data_in;
    	end else begin 
    		data_in_q <= data_in_q;
    	end
    end
	always @(posedge baud_clock)begin
	    if(read_available)
            read_request <= 1'b1;
        else
        	read_request <= 1'b0;
	end
	always @(posedge baud_clock) begin 
		if(read_request)
			trans_en <= 1'b1;
		else
			trans_en <= 1'b0;
	end
	
	UART_com UART_com_i(
			.input_clk(sys_clk_i), .reset(CPU_RESETN), .trans_en(trans_en), .Rx(UART_TXD_IN),
			.data_out(ddr_read[7:0]),
			.data_rdy(data_ready), .Tx(UART_RXD_OUT),
			.data_received(data_in)
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
    // always@(posedge read_valid or posedge baud_clock) begin 
    // 	if(read_valid) begin 
    // 		ddr_read_q <= ddr_read;
    // 		read_valid_q <= 1'b1;
    // 	end else begin
    // 		ddr_read_q <= ddr_read_q;
    // 		read_valid_q <= read_valid_q;
    //     end
    		
    // end

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
    	////wrapper
    	// Inputs
    	.write_clock(baud_clock),
    	.write_data({{56{1'b0}},data_in}),
    	.write_valid(data_ready),
        .read_req(read_request),
    	// Outputs
    	.read_data(ddr_read),
        .read_available(read_available),
    	////ddr 
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
        .clk_200_Mhz(clk_out_200_Mhz),
        .sys_rst(CPU_RESETN)
    );
    
    // assign JD[1] = ddr_wrapper_i.app_wdf_data[0];//0
    // assign JD[2] = ddr_wrapper_i.app_wdf_data[1];//1
    // assign JD[3] = ddr_wrapper_i.app_wdf_data[2];//2
    // assign JD[4] = ddr_wrapper_i.app_wdf_data[3];//3
    // assign JD[5] = ddr_wrapper_i.wr_fifo.wrclk;//4
    // assign JD[6] = ddr_wrapper_i.wr_fifo.rdclk;//5
    // assign JD[7] = ddr_wrapper_i.wr_fifo.wrreset;//6
    // assign JD[8] = ddr_wrapper_i.wr_fifo.rdreset;//7

    // assign JC[1] = ddr_wrapper_i.wr_fifo.space_avail;//8
    // assign JC[2] = ddr_wrapper_i.wr_fifo.wrenb;//9
    // assign JC[3] = ddr_wrapper_i.wr_fifo.read_req;//10
    // assign JC[4] = ddr_wrapper_i.wr_fifo.data_avail;//11
    // assign JC[5] = ddr_wrapper_i.wr_fifo.data_valid;//12
    // assign JC[6] = ddr_wrapper_i.app_rdy;//13
    // assign JC[7] = ddr_wrapper_i.app_wdf_rdy;//14
    // assign JC[8] = data_ready;//15
endmodule