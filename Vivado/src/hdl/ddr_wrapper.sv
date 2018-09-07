`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2018 09:29:13 PM
// Design Name: 
// Module Name: ddr_wrapper
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


module ddr_wrapper(
        //wrapper
        input write_clock,
        input [63:0] write_data,
        input write_valid,
        input read_req,
        output [63:0] read_data,
        output read_available,

        //ddr 
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
        // Single-ended system clock
        input           clk_200_Mhz,
        input           sys_rst
    );
    
    localparam WR_IDLE = 1;
    localparam WR_WAIT = 2;
    localparam WR_ACTV = 4;
    localparam WR_BACK = 8;
    reg [26:0]      write_addr, read_addr;
    reg [26:0]      app_addr;
    reg [63:0]      write_reg;
    reg [3:0]       write_current_state, write_next_state;
    reg             rd_lap_flag, wr_lap_flag, ddr_read_req;
    wire            ddr_data_avail;
    logic [2:0]     app_cmd;
    logic           app_en;
    logic [63:0]    app_wdf_data;
    logic           app_wdf_end;
    logic [7:0]     app_wdf_mask;
    logic           app_wdf_wren;
    logic  [63:0]   app_rd_data;
    logic           app_rd_data_end;
    logic           app_rd_data_valid;
    logic           app_rdy;
    logic           app_wdf_rdy;
    logic           app_sr_req;
    logic           app_ref_req;
    logic           app_zq_req;
    logic           app_sr_active;
    logic           app_ref_ack;
    logic           app_zq_ack;
    logic           ui_clk;
    logic           ui_clk_sync_rst;
    logic           init_calib_complete;



    //constant
    assign app_sr_req =             1'b0    ; // this input is reserved and should be tied to zero
    assign app_wdf_mask =           8'h0    ; // currently not masking write bytes
    
    //needs logic
    initial begin
        write_addr = 0;
        wr_lap_flag = 0;
        read_addr = 0;
        rd_lap_flag = 0;
    end
//    assign app_cmd =                3'b1    ;//read or write
//    assign app_en =                 1'b1    ;
//    assign app_wdf_data =           64'b1   ;

//    assign app_wdf_end =            1'b1    ;
//    assign app_wdf_wren =           1'b1    ;
    assign app_ref_req =            1'b0    ;
    assign app_zq_req =             1'b0    ;
//    assign sys_rst =                1'b1    ;
    // assign read_data = app_rd_data;
    // assign read_valid = app_rd_data_valid;

     
    mig_7series_0 ddr2(
        // Inputs
        .sys_clk_i(clk_200_Mhz),
        .sys_rst(sys_rst),
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
        // user interface outputs
        .ui_clk(ui_clk),
        .ui_clk_sync_rst(ui_clk_sync_rst),
        .init_calib_complete(init_calib_complete),
        //app inputs
        .app_addr(app_addr),
        .app_cmd(app_cmd),
        .app_en(app_en),
        .app_wdf_data(app_wdf_data),
        .app_wdf_end(app_wdf_end),
        .app_wdf_mask(app_wdf_mask),
        .app_wdf_wren(app_wdf_wren),
        .app_sr_req(app_sr_req),
        .app_ref_req(app_ref_req),
        .app_zq_req(app_zq_req),
        //app outputs
        .app_rd_data(app_rd_data),
        .app_rd_data_end(app_rd_data_end),
        .app_rd_data_valid(app_rd_data_valid),
        .app_rdy(app_rdy),
        .app_ref_ack(app_ref_ack),
        .app_sr_active(app_sr_active),
        .app_wdf_rdy(app_wdf_rdy),
        .app_zq_ack(app_zq_ack)
    );

    async_fifo #( .ASYNC_FIFO_MAXDATA(64-1) ) wr_fifo (//TODO update async fifo so ASYNC_FIFOMAXDATA can be input as 64 bits
        .wrclk(write_clock), 
        .wrreset(!sys_rst), 
        .rdclk(ui_clk), 
        .rdreset(ui_clk_sync_rst),
        // write path
        .space_avail(), 
        .wrenb(write_valid), 
        .wrdata(write_data),
        // read path
        //.read_req(data_avail & app_rdy & app_wdf_rdy),
        .read_req(ddr_read_req),
        .data_avail(ddr_data_avail), 
        .data_valid(), //TODO this should have logic, wait until data is valid
        .data_out(app_wdf_data)
    );

    async_fifo #( .ASYNC_FIFO_MAXDATA(64-1) ) rd_fifo (//TODO update async fifo so ASYNC_FIFOMAXDATA can be input as 64 bits
        .wrclk(ui_clk), 
        .wrreset(ui_clk_sync_rst),
        .rdclk(write_clock), 
        .rdreset(!sys_rst),
        // write path
        .space_avail(),
        .wrenb(app_rd_data_valid & !app_rd_data_end), 
        .wrdata(app_rd_data),
        // read path
        //.read_req(data_avail & app_rdy & app_wdf_rdy),
        .read_req(read_req),
        .data_avail(read_available), 
        .data_valid(), //TODO this should have logic, wait until data is valid
        .data_out(read_data)
    );
    always @(posedge ui_clk) begin
        write_current_state <= write_next_state;

    end

    always @(*) begin
        case (write_current_state)
            WR_IDLE: begin
                if(write_valid) begin 
                    write_next_state = WR_WAIT;
                    ddr_read_req = 1'b0;
                    app_cmd = 3'b0;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b0;
                    app_wdf_end = 1'b0;
                end else begin
                    ddr_read_req = 1'b0;
                    app_cmd = 3'b0;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b0;
                    app_wdf_end = 1'b0;
                    write_next_state = WR_IDLE;
                end
            end
            WR_WAIT: begin
                if(app_rdy === 1'b1 & app_wdf_rdy === 1'b1 & ddr_data_avail === 1'b1)begin
                    ddr_read_req = 1'b1;
                    app_cmd = 3'b0;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b0;
                    app_wdf_end = 1'b0;
                    write_next_state = WR_ACTV;
                end else begin
                    ddr_read_req = 1'b0;
                    app_cmd = 3'b0;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b0;
                    app_wdf_end = 1'b0;
                    write_next_state = WR_WAIT;
                end
            end
            WR_ACTV: begin
                ddr_read_req = 1'b0;
                app_cmd = 3'b0;
                app_addr = 27'b0;
                app_wdf_wren = 1'b1;
                app_en = 1'b1;
                app_wdf_end = 1'b1;
                write_next_state = WR_BACK;
            end
            WR_BACK: begin
                if(app_rdy === 1'b1)begin
                    ddr_read_req = 1'b0;
                    app_cmd = 3'b1;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b1;
                    app_wdf_end = 1'b0;
                    write_next_state = WR_IDLE;
                end else begin
                    ddr_read_req = 1'b0;
                    app_cmd = 3'b0;
                    app_addr = 27'b0;
                    app_wdf_wren = 1'b0;
                    app_en = 1'b0;
                    app_wdf_end = 1'b0;
                    write_next_state = WR_BACK;
                end
            end
            default : begin 
                ddr_read_req = 1'b0;
                app_cmd = 3'b0;
                app_addr = 27'b0;
                app_wdf_wren = 1'b0;
                app_en = 1'b0;
                app_wdf_end = 1'b0;
                write_next_state = WR_IDLE;
            end
        endcase
    end
endmodule