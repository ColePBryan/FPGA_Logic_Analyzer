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
    
    logic [26:0]    app_addr;
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
    logic           sys_rst;


    //constant
    assign app_sr_req =             1'b0    ; // this input is reserved and should be tied to zero
    assign app_wdf_mask =           8'b0    ;
    
    //needs logic
    assign app_addr =               27'b1   ;
    assign app_cmd =                3'b1    ;
    assign app_en =                 1'b1    ;
    assign app_wdf_data =           64'b1   ;

    assign app_wdf_end =            1'b1    ;
    assign app_wdf_wren =           1'b1    ;
    assign app_ref_req =            1'b1    ;
    assign app_zq_req =             1'b1    ;
    assign sys_rst =                1'b1    ;
     
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

endmodule


/*

module ddr_wrapper(
  input         clk,
  input         wrFlags,
  input [3:0]   config_data,
  input         read,
  input         write,
  input         lastwrite,
  input [63:0]  wrdata,
  
  // outputs...
  output [63:0] rddata,
  output [3:0]  rdvalid);

*/
