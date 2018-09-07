// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Aug  7 20:50:34 2018
// Host        : DESKTOP-IFHBQH0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/bryan/Documents/verilog_projects/ddr2_memory_driver/ddr2_memory_driver.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_out_200_Mhz, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out_200_Mhz,resetn,locked,clk_in1" */;
  output clk_out_200_Mhz;
  input resetn;
  output locked;
  input clk_in1;
endmodule
