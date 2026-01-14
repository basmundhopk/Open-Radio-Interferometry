// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
 `timescale 1ns/1ps


`define AUTOTB_DUT      correlator
`define AUTOTB_DUT_INST AESL_inst_correlator
`define AUTOTB_TOP      apatb_correlator_top
`define AUTOTB_LAT_RESULT_FILE "correlator.result.lat.rb"
`define AUTOTB_PER_RESULT_TRANS_FILE "correlator.performance.result.transaction.xml"
`define AUTOTB_TOP_INST AESL_inst_apatb_correlator_top
`define AUTOTB_MAX_ALLOW_LATENCY  15000000
`define AUTOTB_CLOCK_PERIOD_DIV2 5.00

`define AESL_DEPTH_din_data_0 1
`define AESL_DEPTH_din_data_1 1
`define AESL_DEPTH_din_data_2 1
`define AESL_DEPTH_din_data_3 1
`define AESL_DEPTH_dout_data_00 1
`define AESL_DEPTH_dout_data_11 1
`define AESL_DEPTH_dout_data_22 1
`define AESL_DEPTH_dout_data_33 1
`define AESL_DEPTH_dout_data_01 1
`define AESL_DEPTH_dout_data_02 1
`define AESL_DEPTH_dout_data_03 1
`define AESL_DEPTH_dout_data_12 1
`define AESL_DEPTH_dout_data_13 1
`define AESL_DEPTH_dout_data_23 1
`define AESL_DEPTH_integration_time_frames 1
`define AUTOTB_TVIN_din_data_0  "../tv/cdatafile/c.correlator.autotvin_din_data_0.dat"
`define AUTOTB_TVIN_din_data_1  "../tv/cdatafile/c.correlator.autotvin_din_data_1.dat"
`define AUTOTB_TVIN_din_data_2  "../tv/cdatafile/c.correlator.autotvin_din_data_2.dat"
`define AUTOTB_TVIN_din_data_3  "../tv/cdatafile/c.correlator.autotvin_din_data_3.dat"
`define AUTOTB_TVIN_integration_time_frames  "../tv/cdatafile/c.correlator.autotvin_integration_time_frames.dat"
`define AUTOTB_TVIN_din_data_0_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvin_din_data_0.dat"
`define AUTOTB_TVIN_din_data_1_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvin_din_data_1.dat"
`define AUTOTB_TVIN_din_data_2_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvin_din_data_2.dat"
`define AUTOTB_TVIN_din_data_3_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvin_din_data_3.dat"
`define AUTOTB_TVIN_integration_time_frames_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvin_integration_time_frames.dat"
`define AUTOTB_TVOUT_dout_data_00  "../tv/cdatafile/c.correlator.autotvout_dout_data_00.dat"
`define AUTOTB_TVOUT_dout_data_11  "../tv/cdatafile/c.correlator.autotvout_dout_data_11.dat"
`define AUTOTB_TVOUT_dout_data_22  "../tv/cdatafile/c.correlator.autotvout_dout_data_22.dat"
`define AUTOTB_TVOUT_dout_data_33  "../tv/cdatafile/c.correlator.autotvout_dout_data_33.dat"
`define AUTOTB_TVOUT_dout_data_01  "../tv/cdatafile/c.correlator.autotvout_dout_data_01.dat"
`define AUTOTB_TVOUT_dout_data_02  "../tv/cdatafile/c.correlator.autotvout_dout_data_02.dat"
`define AUTOTB_TVOUT_dout_data_03  "../tv/cdatafile/c.correlator.autotvout_dout_data_03.dat"
`define AUTOTB_TVOUT_dout_data_12  "../tv/cdatafile/c.correlator.autotvout_dout_data_12.dat"
`define AUTOTB_TVOUT_dout_data_13  "../tv/cdatafile/c.correlator.autotvout_dout_data_13.dat"
`define AUTOTB_TVOUT_dout_data_23  "../tv/cdatafile/c.correlator.autotvout_dout_data_23.dat"
`define AUTOTB_TVOUT_dout_data_00_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_00.dat"
`define AUTOTB_TVOUT_dout_data_11_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_11.dat"
`define AUTOTB_TVOUT_dout_data_22_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_22.dat"
`define AUTOTB_TVOUT_dout_data_33_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_33.dat"
`define AUTOTB_TVOUT_dout_data_01_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_01.dat"
`define AUTOTB_TVOUT_dout_data_02_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_02.dat"
`define AUTOTB_TVOUT_dout_data_03_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_03.dat"
`define AUTOTB_TVOUT_dout_data_12_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_12.dat"
`define AUTOTB_TVOUT_dout_data_13_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_13.dat"
`define AUTOTB_TVOUT_dout_data_23_out_wrapc  "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_23.dat"
module `AUTOTB_TOP;

parameter AUTOTB_TRANSACTION_NUM = 5;
parameter PROGRESS_TIMEOUT = 10000000;
parameter LATENCY_ESTIMATION = 22544;
parameter LENGTH_din_data_0 = 1024;
parameter LENGTH_din_data_1 = 1024;
parameter LENGTH_din_data_2 = 1024;
parameter LENGTH_din_data_3 = 1024;
parameter LENGTH_dout_data_00 = 1024;
parameter LENGTH_dout_data_01 = 1024;
parameter LENGTH_dout_data_02 = 1024;
parameter LENGTH_dout_data_03 = 1024;
parameter LENGTH_dout_data_11 = 1024;
parameter LENGTH_dout_data_12 = 1024;
parameter LENGTH_dout_data_13 = 1024;
parameter LENGTH_dout_data_22 = 1024;
parameter LENGTH_dout_data_23 = 1024;
parameter LENGTH_dout_data_33 = 1024;
parameter LENGTH_integration_time_frames = 1;

task read_token;
    input integer fp;
    output reg [279 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end
endtask

reg AESL_clock;
reg rst;
reg dut_rst;
reg start;
reg ce;
reg tb_continue;
wire AESL_start;
wire AESL_reset;
wire AESL_ce;
wire AESL_ready;
wire AESL_idle;
wire AESL_continue;
wire AESL_done;
reg AESL_done_delay = 0;
reg AESL_done_delay2 = 0;
reg AESL_ready_delay = 0;
wire ready;
wire ready_wire;
wire [4 : 0] control_AWADDR;
wire  control_AWVALID;
wire  control_AWREADY;
wire  control_WVALID;
wire  control_WREADY;
wire [31 : 0] control_WDATA;
wire [3 : 0] control_WSTRB;
wire [4 : 0] control_ARADDR;
wire  control_ARVALID;
wire  control_ARREADY;
wire  control_RVALID;
wire  control_RREADY;
wire [31 : 0] control_RDATA;
wire [1 : 0] control_RRESP;
wire  control_BVALID;
wire  control_BREADY;
wire [1 : 0] control_BRESP;
wire  control_INTERRUPT;
wire [31 : 0] din_data_0_TDATA;
wire  din_data_0_TVALID;
wire  din_data_0_TREADY;
wire [31 : 0] din_data_1_TDATA;
wire  din_data_1_TVALID;
wire  din_data_1_TREADY;
wire [31 : 0] din_data_2_TDATA;
wire  din_data_2_TVALID;
wire  din_data_2_TREADY;
wire [31 : 0] din_data_3_TDATA;
wire  din_data_3_TVALID;
wire  din_data_3_TREADY;
wire [127 : 0] dout_data_00_TDATA;
wire  dout_data_00_TVALID;
wire  dout_data_00_TREADY;
wire [127 : 0] dout_data_11_TDATA;
wire  dout_data_11_TVALID;
wire  dout_data_11_TREADY;
wire [127 : 0] dout_data_22_TDATA;
wire  dout_data_22_TVALID;
wire  dout_data_22_TREADY;
wire [127 : 0] dout_data_33_TDATA;
wire  dout_data_33_TVALID;
wire  dout_data_33_TREADY;
wire [127 : 0] dout_data_01_TDATA;
wire  dout_data_01_TVALID;
wire  dout_data_01_TREADY;
wire [127 : 0] dout_data_02_TDATA;
wire  dout_data_02_TVALID;
wire  dout_data_02_TREADY;
wire [127 : 0] dout_data_03_TDATA;
wire  dout_data_03_TVALID;
wire  dout_data_03_TREADY;
wire [127 : 0] dout_data_12_TDATA;
wire  dout_data_12_TVALID;
wire  dout_data_12_TREADY;
wire [127 : 0] dout_data_13_TDATA;
wire  dout_data_13_TVALID;
wire  dout_data_13_TREADY;
wire [127 : 0] dout_data_23_TDATA;
wire  dout_data_23_TVALID;
wire  dout_data_23_TREADY;
integer done_cnt = 0;
integer AESL_ready_cnt = 0;
integer ready_cnt = 0;
reg ready_initial;
reg ready_initial_n;
reg ready_last_n;
reg ready_delay_last_n;
reg done_delay_last_n;
reg interface_done = 0;
wire control_write_data_finish;
wire AESL_slave_start;
reg AESL_slave_start_lock = 0;
wire AESL_slave_write_start_in;
wire AESL_slave_write_start_finish;
reg AESL_slave_ready;
wire AESL_slave_output_done;
wire AESL_slave_done;
reg ready_rise = 0;
reg start_rise = 0;
reg slave_start_status = 0;
reg slave_done_status = 0;
reg ap_done_lock = 0;


wire ap_clk;
wire ap_rst_n;
wire ap_rst_n_n;

`AUTOTB_DUT `AUTOTB_DUT_INST(
    .s_axi_control_AWADDR(control_AWADDR),
    .s_axi_control_AWVALID(control_AWVALID),
    .s_axi_control_AWREADY(control_AWREADY),
    .s_axi_control_WVALID(control_WVALID),
    .s_axi_control_WREADY(control_WREADY),
    .s_axi_control_WDATA(control_WDATA),
    .s_axi_control_WSTRB(control_WSTRB),
    .s_axi_control_ARADDR(control_ARADDR),
    .s_axi_control_ARVALID(control_ARVALID),
    .s_axi_control_ARREADY(control_ARREADY),
    .s_axi_control_RVALID(control_RVALID),
    .s_axi_control_RREADY(control_RREADY),
    .s_axi_control_RDATA(control_RDATA),
    .s_axi_control_RRESP(control_RRESP),
    .s_axi_control_BVALID(control_BVALID),
    .s_axi_control_BREADY(control_BREADY),
    .s_axi_control_BRESP(control_BRESP),
    .interrupt(control_INTERRUPT),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .din_data_0_TDATA(din_data_0_TDATA),
    .din_data_0_TVALID(din_data_0_TVALID),
    .din_data_0_TREADY(din_data_0_TREADY),
    .din_data_1_TDATA(din_data_1_TDATA),
    .din_data_1_TVALID(din_data_1_TVALID),
    .din_data_1_TREADY(din_data_1_TREADY),
    .din_data_2_TDATA(din_data_2_TDATA),
    .din_data_2_TVALID(din_data_2_TVALID),
    .din_data_2_TREADY(din_data_2_TREADY),
    .din_data_3_TDATA(din_data_3_TDATA),
    .din_data_3_TVALID(din_data_3_TVALID),
    .din_data_3_TREADY(din_data_3_TREADY),
    .dout_data_00_TDATA(dout_data_00_TDATA),
    .dout_data_00_TVALID(dout_data_00_TVALID),
    .dout_data_00_TREADY(dout_data_00_TREADY),
    .dout_data_11_TDATA(dout_data_11_TDATA),
    .dout_data_11_TVALID(dout_data_11_TVALID),
    .dout_data_11_TREADY(dout_data_11_TREADY),
    .dout_data_22_TDATA(dout_data_22_TDATA),
    .dout_data_22_TVALID(dout_data_22_TVALID),
    .dout_data_22_TREADY(dout_data_22_TREADY),
    .dout_data_33_TDATA(dout_data_33_TDATA),
    .dout_data_33_TVALID(dout_data_33_TVALID),
    .dout_data_33_TREADY(dout_data_33_TREADY),
    .dout_data_01_TDATA(dout_data_01_TDATA),
    .dout_data_01_TVALID(dout_data_01_TVALID),
    .dout_data_01_TREADY(dout_data_01_TREADY),
    .dout_data_02_TDATA(dout_data_02_TDATA),
    .dout_data_02_TVALID(dout_data_02_TVALID),
    .dout_data_02_TREADY(dout_data_02_TREADY),
    .dout_data_03_TDATA(dout_data_03_TDATA),
    .dout_data_03_TVALID(dout_data_03_TVALID),
    .dout_data_03_TREADY(dout_data_03_TREADY),
    .dout_data_12_TDATA(dout_data_12_TDATA),
    .dout_data_12_TVALID(dout_data_12_TVALID),
    .dout_data_12_TREADY(dout_data_12_TREADY),
    .dout_data_13_TDATA(dout_data_13_TDATA),
    .dout_data_13_TVALID(dout_data_13_TVALID),
    .dout_data_13_TREADY(dout_data_13_TREADY),
    .dout_data_23_TDATA(dout_data_23_TDATA),
    .dout_data_23_TVALID(dout_data_23_TVALID),
    .dout_data_23_TREADY(dout_data_23_TREADY));

// Assignment for control signal
assign ap_clk = AESL_clock;
assign ap_rst_n = dut_rst;
assign ap_rst_n_n = ~dut_rst;
assign AESL_reset = rst;
assign AESL_start = start;
assign AESL_ce = ce;
assign AESL_continue = tb_continue;
  assign AESL_slave_write_start_in = slave_start_status  & control_write_data_finish;
  assign AESL_slave_start = AESL_slave_write_start_finish;
  assign AESL_done = slave_done_status ;

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
    begin
        slave_start_status <= 1;
    end
    else begin
        if (AESL_start == 1 ) begin
            start_rise = 1;
        end
        if (start_rise == 1 && AESL_done == 1 ) begin
            slave_start_status <= 1;
        end
        if (AESL_slave_write_start_in == 1 && AESL_done == 0) begin 
            slave_start_status <= 0;
            start_rise = 0;
        end
    end
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
    begin
        AESL_slave_ready <= 0;
        ready_rise = 0;
    end
    else begin
        if (AESL_ready == 1 ) begin
            ready_rise = 1;
        end
        if (ready_rise == 1 && AESL_done_delay == 1 ) begin
            AESL_slave_ready <= 1;
        end
        if (AESL_slave_ready == 1) begin 
            AESL_slave_ready <= 0;
            ready_rise = 0;
        end
    end
end

always @ (posedge AESL_clock)
begin
    if (AESL_done == 1) begin
        slave_done_status <= 0;
    end
    else if (AESL_slave_output_done == 1 ) begin
        slave_done_status <= 1;
    end
end















reg [31:0] ap_c_n_tvin_trans_num_din_data_0;

reg din_data_0_ready_reg; // for self-sync

wire din_data_0_ready;
wire din_data_0_done;
wire [31:0] din_data_0_transaction;
wire axi_s_din_data_0_TVALID;
wire axi_s_din_data_0_TREADY;

AESL_axi_s_din_data_0 AESL_AXI_S_din_data_0(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_din_data_0_TDATA(din_data_0_TDATA),
    .TRAN_din_data_0_TVALID(axi_s_din_data_0_TVALID),
    .TRAN_din_data_0_TREADY(axi_s_din_data_0_TREADY),
    .ready(din_data_0_ready),
    .done(din_data_0_done),
    .transaction(din_data_0_transaction));

assign din_data_0_ready = din_data_0_ready_reg | ready_initial;
assign din_data_0_done = 0;

assign din_data_0_TVALID = axi_s_din_data_0_TVALID;

assign axi_s_din_data_0_TREADY = din_data_0_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_din_data_1;

reg din_data_1_ready_reg; // for self-sync

wire din_data_1_ready;
wire din_data_1_done;
wire [31:0] din_data_1_transaction;
wire axi_s_din_data_1_TVALID;
wire axi_s_din_data_1_TREADY;

AESL_axi_s_din_data_1 AESL_AXI_S_din_data_1(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_din_data_1_TDATA(din_data_1_TDATA),
    .TRAN_din_data_1_TVALID(axi_s_din_data_1_TVALID),
    .TRAN_din_data_1_TREADY(axi_s_din_data_1_TREADY),
    .ready(din_data_1_ready),
    .done(din_data_1_done),
    .transaction(din_data_1_transaction));

assign din_data_1_ready = din_data_1_ready_reg | ready_initial;
assign din_data_1_done = 0;

assign din_data_1_TVALID = axi_s_din_data_1_TVALID;

assign axi_s_din_data_1_TREADY = din_data_1_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_din_data_2;

reg din_data_2_ready_reg; // for self-sync

wire din_data_2_ready;
wire din_data_2_done;
wire [31:0] din_data_2_transaction;
wire axi_s_din_data_2_TVALID;
wire axi_s_din_data_2_TREADY;

AESL_axi_s_din_data_2 AESL_AXI_S_din_data_2(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_din_data_2_TDATA(din_data_2_TDATA),
    .TRAN_din_data_2_TVALID(axi_s_din_data_2_TVALID),
    .TRAN_din_data_2_TREADY(axi_s_din_data_2_TREADY),
    .ready(din_data_2_ready),
    .done(din_data_2_done),
    .transaction(din_data_2_transaction));

assign din_data_2_ready = din_data_2_ready_reg | ready_initial;
assign din_data_2_done = 0;

assign din_data_2_TVALID = axi_s_din_data_2_TVALID;

assign axi_s_din_data_2_TREADY = din_data_2_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_din_data_3;

reg din_data_3_ready_reg; // for self-sync

wire din_data_3_ready;
wire din_data_3_done;
wire [31:0] din_data_3_transaction;
wire axi_s_din_data_3_TVALID;
wire axi_s_din_data_3_TREADY;

AESL_axi_s_din_data_3 AESL_AXI_S_din_data_3(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_din_data_3_TDATA(din_data_3_TDATA),
    .TRAN_din_data_3_TVALID(axi_s_din_data_3_TVALID),
    .TRAN_din_data_3_TREADY(axi_s_din_data_3_TREADY),
    .ready(din_data_3_ready),
    .done(din_data_3_done),
    .transaction(din_data_3_transaction));

assign din_data_3_ready = din_data_3_ready_reg | ready_initial;
assign din_data_3_done = 0;

assign din_data_3_TVALID = axi_s_din_data_3_TVALID;

assign axi_s_din_data_3_TREADY = din_data_3_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_00;

reg dout_data_00_ready_reg; // for self-sync

wire dout_data_00_ready;
wire dout_data_00_done;
wire [31:0] dout_data_00_transaction;
wire axi_s_dout_data_00_TVALID;
wire axi_s_dout_data_00_TREADY;

AESL_axi_s_dout_data_00 AESL_AXI_S_dout_data_00(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_00_TDATA(dout_data_00_TDATA),
    .TRAN_dout_data_00_TVALID(axi_s_dout_data_00_TVALID),
    .TRAN_dout_data_00_TREADY(axi_s_dout_data_00_TREADY),
    .ready(dout_data_00_ready),
    .done(dout_data_00_done),
    .transaction(dout_data_00_transaction));

assign dout_data_00_ready = 0;
assign dout_data_00_done = AESL_done;

assign axi_s_dout_data_00_TVALID = dout_data_00_TVALID;

reg reg_dout_data_00_TREADY;
initial begin : gen_reg_dout_data_00_TREADY_process
    integer proc_rand;
    reg_dout_data_00_TREADY = axi_s_dout_data_00_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_00_TREADY);
        reg_dout_data_00_TREADY = axi_s_dout_data_00_TREADY;
    end
end


assign dout_data_00_TREADY = reg_dout_data_00_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_11;

reg dout_data_11_ready_reg; // for self-sync

wire dout_data_11_ready;
wire dout_data_11_done;
wire [31:0] dout_data_11_transaction;
wire axi_s_dout_data_11_TVALID;
wire axi_s_dout_data_11_TREADY;

AESL_axi_s_dout_data_11 AESL_AXI_S_dout_data_11(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_11_TDATA(dout_data_11_TDATA),
    .TRAN_dout_data_11_TVALID(axi_s_dout_data_11_TVALID),
    .TRAN_dout_data_11_TREADY(axi_s_dout_data_11_TREADY),
    .ready(dout_data_11_ready),
    .done(dout_data_11_done),
    .transaction(dout_data_11_transaction));

assign dout_data_11_ready = 0;
assign dout_data_11_done = AESL_done;

assign axi_s_dout_data_11_TVALID = dout_data_11_TVALID;

reg reg_dout_data_11_TREADY;
initial begin : gen_reg_dout_data_11_TREADY_process
    integer proc_rand;
    reg_dout_data_11_TREADY = axi_s_dout_data_11_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_11_TREADY);
        reg_dout_data_11_TREADY = axi_s_dout_data_11_TREADY;
    end
end


assign dout_data_11_TREADY = reg_dout_data_11_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_22;

reg dout_data_22_ready_reg; // for self-sync

wire dout_data_22_ready;
wire dout_data_22_done;
wire [31:0] dout_data_22_transaction;
wire axi_s_dout_data_22_TVALID;
wire axi_s_dout_data_22_TREADY;

AESL_axi_s_dout_data_22 AESL_AXI_S_dout_data_22(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_22_TDATA(dout_data_22_TDATA),
    .TRAN_dout_data_22_TVALID(axi_s_dout_data_22_TVALID),
    .TRAN_dout_data_22_TREADY(axi_s_dout_data_22_TREADY),
    .ready(dout_data_22_ready),
    .done(dout_data_22_done),
    .transaction(dout_data_22_transaction));

assign dout_data_22_ready = 0;
assign dout_data_22_done = AESL_done;

assign axi_s_dout_data_22_TVALID = dout_data_22_TVALID;

reg reg_dout_data_22_TREADY;
initial begin : gen_reg_dout_data_22_TREADY_process
    integer proc_rand;
    reg_dout_data_22_TREADY = axi_s_dout_data_22_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_22_TREADY);
        reg_dout_data_22_TREADY = axi_s_dout_data_22_TREADY;
    end
end


assign dout_data_22_TREADY = reg_dout_data_22_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_33;

reg dout_data_33_ready_reg; // for self-sync

wire dout_data_33_ready;
wire dout_data_33_done;
wire [31:0] dout_data_33_transaction;
wire axi_s_dout_data_33_TVALID;
wire axi_s_dout_data_33_TREADY;

AESL_axi_s_dout_data_33 AESL_AXI_S_dout_data_33(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_33_TDATA(dout_data_33_TDATA),
    .TRAN_dout_data_33_TVALID(axi_s_dout_data_33_TVALID),
    .TRAN_dout_data_33_TREADY(axi_s_dout_data_33_TREADY),
    .ready(dout_data_33_ready),
    .done(dout_data_33_done),
    .transaction(dout_data_33_transaction));

assign dout_data_33_ready = 0;
assign dout_data_33_done = AESL_done;

assign axi_s_dout_data_33_TVALID = dout_data_33_TVALID;

reg reg_dout_data_33_TREADY;
initial begin : gen_reg_dout_data_33_TREADY_process
    integer proc_rand;
    reg_dout_data_33_TREADY = axi_s_dout_data_33_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_33_TREADY);
        reg_dout_data_33_TREADY = axi_s_dout_data_33_TREADY;
    end
end


assign dout_data_33_TREADY = reg_dout_data_33_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_01;

reg dout_data_01_ready_reg; // for self-sync

wire dout_data_01_ready;
wire dout_data_01_done;
wire [31:0] dout_data_01_transaction;
wire axi_s_dout_data_01_TVALID;
wire axi_s_dout_data_01_TREADY;

AESL_axi_s_dout_data_01 AESL_AXI_S_dout_data_01(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_01_TDATA(dout_data_01_TDATA),
    .TRAN_dout_data_01_TVALID(axi_s_dout_data_01_TVALID),
    .TRAN_dout_data_01_TREADY(axi_s_dout_data_01_TREADY),
    .ready(dout_data_01_ready),
    .done(dout_data_01_done),
    .transaction(dout_data_01_transaction));

assign dout_data_01_ready = 0;
assign dout_data_01_done = AESL_done;

assign axi_s_dout_data_01_TVALID = dout_data_01_TVALID;

reg reg_dout_data_01_TREADY;
initial begin : gen_reg_dout_data_01_TREADY_process
    integer proc_rand;
    reg_dout_data_01_TREADY = axi_s_dout_data_01_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_01_TREADY);
        reg_dout_data_01_TREADY = axi_s_dout_data_01_TREADY;
    end
end


assign dout_data_01_TREADY = reg_dout_data_01_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_02;

reg dout_data_02_ready_reg; // for self-sync

wire dout_data_02_ready;
wire dout_data_02_done;
wire [31:0] dout_data_02_transaction;
wire axi_s_dout_data_02_TVALID;
wire axi_s_dout_data_02_TREADY;

AESL_axi_s_dout_data_02 AESL_AXI_S_dout_data_02(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_02_TDATA(dout_data_02_TDATA),
    .TRAN_dout_data_02_TVALID(axi_s_dout_data_02_TVALID),
    .TRAN_dout_data_02_TREADY(axi_s_dout_data_02_TREADY),
    .ready(dout_data_02_ready),
    .done(dout_data_02_done),
    .transaction(dout_data_02_transaction));

assign dout_data_02_ready = 0;
assign dout_data_02_done = AESL_done;

assign axi_s_dout_data_02_TVALID = dout_data_02_TVALID;

reg reg_dout_data_02_TREADY;
initial begin : gen_reg_dout_data_02_TREADY_process
    integer proc_rand;
    reg_dout_data_02_TREADY = axi_s_dout_data_02_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_02_TREADY);
        reg_dout_data_02_TREADY = axi_s_dout_data_02_TREADY;
    end
end


assign dout_data_02_TREADY = reg_dout_data_02_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_03;

reg dout_data_03_ready_reg; // for self-sync

wire dout_data_03_ready;
wire dout_data_03_done;
wire [31:0] dout_data_03_transaction;
wire axi_s_dout_data_03_TVALID;
wire axi_s_dout_data_03_TREADY;

AESL_axi_s_dout_data_03 AESL_AXI_S_dout_data_03(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_03_TDATA(dout_data_03_TDATA),
    .TRAN_dout_data_03_TVALID(axi_s_dout_data_03_TVALID),
    .TRAN_dout_data_03_TREADY(axi_s_dout_data_03_TREADY),
    .ready(dout_data_03_ready),
    .done(dout_data_03_done),
    .transaction(dout_data_03_transaction));

assign dout_data_03_ready = 0;
assign dout_data_03_done = AESL_done;

assign axi_s_dout_data_03_TVALID = dout_data_03_TVALID;

reg reg_dout_data_03_TREADY;
initial begin : gen_reg_dout_data_03_TREADY_process
    integer proc_rand;
    reg_dout_data_03_TREADY = axi_s_dout_data_03_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_03_TREADY);
        reg_dout_data_03_TREADY = axi_s_dout_data_03_TREADY;
    end
end


assign dout_data_03_TREADY = reg_dout_data_03_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_12;

reg dout_data_12_ready_reg; // for self-sync

wire dout_data_12_ready;
wire dout_data_12_done;
wire [31:0] dout_data_12_transaction;
wire axi_s_dout_data_12_TVALID;
wire axi_s_dout_data_12_TREADY;

AESL_axi_s_dout_data_12 AESL_AXI_S_dout_data_12(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_12_TDATA(dout_data_12_TDATA),
    .TRAN_dout_data_12_TVALID(axi_s_dout_data_12_TVALID),
    .TRAN_dout_data_12_TREADY(axi_s_dout_data_12_TREADY),
    .ready(dout_data_12_ready),
    .done(dout_data_12_done),
    .transaction(dout_data_12_transaction));

assign dout_data_12_ready = 0;
assign dout_data_12_done = AESL_done;

assign axi_s_dout_data_12_TVALID = dout_data_12_TVALID;

reg reg_dout_data_12_TREADY;
initial begin : gen_reg_dout_data_12_TREADY_process
    integer proc_rand;
    reg_dout_data_12_TREADY = axi_s_dout_data_12_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_12_TREADY);
        reg_dout_data_12_TREADY = axi_s_dout_data_12_TREADY;
    end
end


assign dout_data_12_TREADY = reg_dout_data_12_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_13;

reg dout_data_13_ready_reg; // for self-sync

wire dout_data_13_ready;
wire dout_data_13_done;
wire [31:0] dout_data_13_transaction;
wire axi_s_dout_data_13_TVALID;
wire axi_s_dout_data_13_TREADY;

AESL_axi_s_dout_data_13 AESL_AXI_S_dout_data_13(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_13_TDATA(dout_data_13_TDATA),
    .TRAN_dout_data_13_TVALID(axi_s_dout_data_13_TVALID),
    .TRAN_dout_data_13_TREADY(axi_s_dout_data_13_TREADY),
    .ready(dout_data_13_ready),
    .done(dout_data_13_done),
    .transaction(dout_data_13_transaction));

assign dout_data_13_ready = 0;
assign dout_data_13_done = AESL_done;

assign axi_s_dout_data_13_TVALID = dout_data_13_TVALID;

reg reg_dout_data_13_TREADY;
initial begin : gen_reg_dout_data_13_TREADY_process
    integer proc_rand;
    reg_dout_data_13_TREADY = axi_s_dout_data_13_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_13_TREADY);
        reg_dout_data_13_TREADY = axi_s_dout_data_13_TREADY;
    end
end


assign dout_data_13_TREADY = reg_dout_data_13_TREADY;
reg [31:0] ap_c_n_tvin_trans_num_dout_data_23;

reg dout_data_23_ready_reg; // for self-sync

wire dout_data_23_ready;
wire dout_data_23_done;
wire [31:0] dout_data_23_transaction;
wire axi_s_dout_data_23_TVALID;
wire axi_s_dout_data_23_TREADY;

AESL_axi_s_dout_data_23 AESL_AXI_S_dout_data_23(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_dout_data_23_TDATA(dout_data_23_TDATA),
    .TRAN_dout_data_23_TVALID(axi_s_dout_data_23_TVALID),
    .TRAN_dout_data_23_TREADY(axi_s_dout_data_23_TREADY),
    .ready(dout_data_23_ready),
    .done(dout_data_23_done),
    .transaction(dout_data_23_transaction));

assign dout_data_23_ready = 0;
assign dout_data_23_done = AESL_done;

assign axi_s_dout_data_23_TVALID = dout_data_23_TVALID;

reg reg_dout_data_23_TREADY;
initial begin : gen_reg_dout_data_23_TREADY_process
    integer proc_rand;
    reg_dout_data_23_TREADY = axi_s_dout_data_23_TREADY;
    while(1)
    begin
        @(axi_s_dout_data_23_TREADY);
        reg_dout_data_23_TREADY = axi_s_dout_data_23_TREADY;
    end
end


assign dout_data_23_TREADY = reg_dout_data_23_TREADY;

AESL_axi_slave_control AESL_AXI_SLAVE_control(
    .clk   (AESL_clock),
    .reset (AESL_reset),
    .TRAN_s_axi_control_AWADDR (control_AWADDR),
    .TRAN_s_axi_control_AWVALID (control_AWVALID),
    .TRAN_s_axi_control_AWREADY (control_AWREADY),
    .TRAN_s_axi_control_WVALID (control_WVALID),
    .TRAN_s_axi_control_WREADY (control_WREADY),
    .TRAN_s_axi_control_WDATA (control_WDATA),
    .TRAN_s_axi_control_WSTRB (control_WSTRB),
    .TRAN_s_axi_control_ARADDR (control_ARADDR),
    .TRAN_s_axi_control_ARVALID (control_ARVALID),
    .TRAN_s_axi_control_ARREADY (control_ARREADY),
    .TRAN_s_axi_control_RVALID (control_RVALID),
    .TRAN_s_axi_control_RREADY (control_RREADY),
    .TRAN_s_axi_control_RDATA (control_RDATA),
    .TRAN_s_axi_control_RRESP (control_RRESP),
    .TRAN_s_axi_control_BVALID (control_BVALID),
    .TRAN_s_axi_control_BREADY (control_BREADY),
    .TRAN_s_axi_control_BRESP (control_BRESP),
    .TRAN_control_interrupt (control_INTERRUPT),
    .TRAN_control_write_data_finish(control_write_data_finish),
    .TRAN_control_ready_out (AESL_ready),
    .TRAN_control_ready_in (AESL_slave_ready),
    .TRAN_control_done_out (AESL_slave_output_done),
    .TRAN_control_idle_out (AESL_idle),
    .TRAN_control_write_start_in     (AESL_slave_write_start_in),
    .TRAN_control_write_start_finish (AESL_slave_write_start_finish),
    .TRAN_control_transaction_done_in (AESL_done_delay),
    .TRAN_control_start_in  (AESL_slave_start)
);

initial begin : generate_AESL_ready_cnt_proc
    AESL_ready_cnt = 0;
    wait(AESL_reset === 1);
    while(AESL_ready_cnt != AUTOTB_TRANSACTION_NUM) begin
        while(AESL_ready !== 1) begin
            @(posedge AESL_clock);
            # 0.4;
        end
        @(negedge AESL_clock);
        AESL_ready_cnt = AESL_ready_cnt + 1;
        @(posedge AESL_clock);
        # 0.4;
    end
end

    event next_trigger_ready_cnt;
    
    initial begin : gen_ready_cnt
        ready_cnt = 0;
        wait (AESL_reset === 1);
        forever begin
            @ (posedge AESL_clock);
            if (ready == 1) begin
                if (ready_cnt < AUTOTB_TRANSACTION_NUM) begin
                    ready_cnt = ready_cnt + 1;
                end
            end
            -> next_trigger_ready_cnt;
        end
    end
    
    wire all_finish = (done_cnt == AUTOTB_TRANSACTION_NUM);
    
    // done_cnt
    always @ (posedge AESL_clock) begin
        if (~AESL_reset) begin
            done_cnt <= 0;
        end else begin
            if (AESL_done == 1) begin
                if (done_cnt < AUTOTB_TRANSACTION_NUM) begin
                    done_cnt <= done_cnt + 1;
                end
            end
        end
    end
    
    initial begin : finish_simulation
        wait (all_finish == 1);
        // last transaction is saved at negedge right after last done
        repeat(6) @ (posedge AESL_clock);
        $finish;
    end
    
initial begin
    AESL_clock = 0;
    forever #`AUTOTB_CLOCK_PERIOD_DIV2 AESL_clock = ~AESL_clock;
end


reg end_din_data_0;
reg [31:0] size_din_data_0;
reg [31:0] size_din_data_0_backup;
reg end_din_data_1;
reg [31:0] size_din_data_1;
reg [31:0] size_din_data_1_backup;
reg end_din_data_2;
reg [31:0] size_din_data_2;
reg [31:0] size_din_data_2_backup;
reg end_din_data_3;
reg [31:0] size_din_data_3;
reg [31:0] size_din_data_3_backup;
reg end_integration_time_frames;
reg [31:0] size_integration_time_frames;
reg [31:0] size_integration_time_frames_backup;
reg end_dout_data_00;
reg [31:0] size_dout_data_00;
reg [31:0] size_dout_data_00_backup;
reg end_dout_data_11;
reg [31:0] size_dout_data_11;
reg [31:0] size_dout_data_11_backup;
reg end_dout_data_22;
reg [31:0] size_dout_data_22;
reg [31:0] size_dout_data_22_backup;
reg end_dout_data_33;
reg [31:0] size_dout_data_33;
reg [31:0] size_dout_data_33_backup;
reg end_dout_data_01;
reg [31:0] size_dout_data_01;
reg [31:0] size_dout_data_01_backup;
reg end_dout_data_02;
reg [31:0] size_dout_data_02;
reg [31:0] size_dout_data_02_backup;
reg end_dout_data_03;
reg [31:0] size_dout_data_03;
reg [31:0] size_dout_data_03_backup;
reg end_dout_data_12;
reg [31:0] size_dout_data_12;
reg [31:0] size_dout_data_12_backup;
reg end_dout_data_13;
reg [31:0] size_dout_data_13;
reg [31:0] size_dout_data_13_backup;
reg end_dout_data_23;
reg [31:0] size_dout_data_23;
reg [31:0] size_dout_data_23_backup;

initial begin : initial_process
    integer proc_rand;
    rst = 0;
    # 100;
    repeat(0+3) @ (posedge AESL_clock);
    # 0.1;
    rst = 1;
end
initial begin : initial_process_for_dut_rst
    integer proc_rand;
    dut_rst = 0;
    # 100;
    repeat(3) @ (posedge AESL_clock);
    # 0.1;
    dut_rst = 1;
end
initial begin : start_process
    integer proc_rand;
    reg [31:0] start_cnt;
    ce = 1;
    start = 0;
    start_cnt = 0;
    wait (AESL_reset === 1);
    @ (posedge AESL_clock);
    #0 start = 1;
    start_cnt = start_cnt + 1;
    forever begin
        if (start_cnt >= AUTOTB_TRANSACTION_NUM + 1) begin
            #0 start = 0;
        end
        @ (posedge AESL_clock);
        if (AESL_ready) begin
            start_cnt = start_cnt + 1;
        end
    end
end

always @(AESL_done)
begin
    tb_continue = AESL_done;
end

initial begin : ready_initial_process
    ready_initial = 0;
    wait (AESL_start === 1);
    ready_initial = 1;
    @(posedge AESL_clock);
    ready_initial = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      AESL_ready_delay = 0;
  else
      AESL_ready_delay = AESL_ready;
end
initial begin : ready_last_n_process
  ready_last_n = 1;
  wait(ready_cnt == AUTOTB_TRANSACTION_NUM)
  @(posedge AESL_clock);
  ready_last_n <= 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      ready_delay_last_n = 0;
  else
      ready_delay_last_n <= ready_last_n;
end
assign ready = (ready_initial | AESL_ready_delay);
assign ready_wire = ready_initial | AESL_ready_delay;
initial begin : done_delay_last_n_process
  done_delay_last_n = 1;
  while(done_cnt < AUTOTB_TRANSACTION_NUM)
      @(posedge AESL_clock);
  # 0.1;
  done_delay_last_n = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
  begin
      AESL_done_delay <= 0;
      AESL_done_delay2 <= 0;
  end
  else begin
      AESL_done_delay <= AESL_done & done_delay_last_n;
      AESL_done_delay2 <= AESL_done_delay;
  end
end
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      interface_done = 0;
  else begin
      # 0.01;
      if(ready === 1 && ready_cnt > 0 && ready_cnt < AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else if(AESL_done_delay === 1 && done_cnt == AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else
          interface_done = 0;
  end
end
    
    initial begin : proc_gen_axis_internal_ready_din_data_0
        din_data_0_ready_reg = 0;
        @ (posedge ready_initial);
        forever begin
            @ (ap_c_n_tvin_trans_num_din_data_0 or din_data_0_transaction);
            if (ap_c_n_tvin_trans_num_din_data_0 > din_data_0_transaction) begin
                din_data_0_ready_reg = 1;
            end else begin
                din_data_0_ready_reg = 0;
            end
        end
    end
    
    initial begin : proc_gen_axis_internal_ready_din_data_1
        din_data_1_ready_reg = 0;
        @ (posedge ready_initial);
        forever begin
            @ (ap_c_n_tvin_trans_num_din_data_1 or din_data_1_transaction);
            if (ap_c_n_tvin_trans_num_din_data_1 > din_data_1_transaction) begin
                din_data_1_ready_reg = 1;
            end else begin
                din_data_1_ready_reg = 0;
            end
        end
    end
    
    initial begin : proc_gen_axis_internal_ready_din_data_2
        din_data_2_ready_reg = 0;
        @ (posedge ready_initial);
        forever begin
            @ (ap_c_n_tvin_trans_num_din_data_2 or din_data_2_transaction);
            if (ap_c_n_tvin_trans_num_din_data_2 > din_data_2_transaction) begin
                din_data_2_ready_reg = 1;
            end else begin
                din_data_2_ready_reg = 0;
            end
        end
    end
    
    initial begin : proc_gen_axis_internal_ready_din_data_3
        din_data_3_ready_reg = 0;
        @ (posedge ready_initial);
        forever begin
            @ (ap_c_n_tvin_trans_num_din_data_3 or din_data_3_transaction);
            if (ap_c_n_tvin_trans_num_din_data_3 > din_data_3_transaction) begin
                din_data_3_ready_reg = 1;
            end else begin
                din_data_3_ready_reg = 0;
            end
        end
    end
    
    `define STREAM_SIZE_IN_din_data_0 "../tv/stream_size/stream_size_in_din_data_0.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_din_data_0
        integer fp_din_data_0;
        reg [127:0] token_din_data_0;
        integer ret;
        
        ap_c_n_tvin_trans_num_din_data_0 = 0;
        end_din_data_0 = 0;
        wait (AESL_reset === 1);
        
        fp_din_data_0 = $fopen(`STREAM_SIZE_IN_din_data_0, "r");
        if(fp_din_data_0 == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_din_data_0);
            $finish;
        end
        read_token(fp_din_data_0, token_din_data_0); // should be [[[runtime]]]
        if (token_din_data_0 != "[[[runtime]]]") begin
            $display("ERROR: token_din_data_0 != \"[[[runtime]]]\"");
            $finish;
        end
        size_din_data_0 = 0;
        size_din_data_0_backup = 0;
        while (size_din_data_0 == 0 && end_din_data_0 == 0) begin
            ap_c_n_tvin_trans_num_din_data_0 = ap_c_n_tvin_trans_num_din_data_0 + 1;
            read_token(fp_din_data_0, token_din_data_0); // should be [[transaction]] or [[[/runtime]]]
            if (token_din_data_0 == "[[transaction]]") begin
                read_token(fp_din_data_0, token_din_data_0); // should be transaction number
                read_token(fp_din_data_0, token_din_data_0); // should be size for hls::stream
                ret = $sscanf(token_din_data_0, "%d", size_din_data_0);
                if (size_din_data_0 > 0) begin
                    size_din_data_0_backup = size_din_data_0;
                end
                read_token(fp_din_data_0, token_din_data_0); // should be [[/transaction]]
            end else if (token_din_data_0 == "[[[/runtime]]]") begin
                $fclose(fp_din_data_0);
                end_din_data_0 = 1;
            end else begin
                $display("ERROR: unknown token_din_data_0");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_din_data_0 == 0) begin
                if ((din_data_0_TREADY & din_data_0_TVALID) == 1) begin
                    if (size_din_data_0 > 0) begin
                        size_din_data_0 = size_din_data_0 - 1;
                        while (size_din_data_0 == 0 && end_din_data_0 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_0 = ap_c_n_tvin_trans_num_din_data_0 + 1;
                            read_token(fp_din_data_0, token_din_data_0); // should be [[transaction]] or [[[/runtime]]]
                            if (token_din_data_0 == "[[transaction]]") begin
                                read_token(fp_din_data_0, token_din_data_0); // should be transaction number
                                read_token(fp_din_data_0, token_din_data_0); // should be size for hls::stream
                                ret = $sscanf(token_din_data_0, "%d", size_din_data_0);
                                if (size_din_data_0 > 0) begin
                                    size_din_data_0_backup = size_din_data_0;
                                end
                                read_token(fp_din_data_0, token_din_data_0); // should be [[/transaction]]
                            end else if (token_din_data_0 == "[[[/runtime]]]") begin
                                size_din_data_0 = size_din_data_0_backup;
                                $fclose(fp_din_data_0);
                                end_din_data_0 = 1;
                            end else begin
                                $display("ERROR: unknown token_din_data_0");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if ((din_data_0_TREADY & din_data_0_TVALID) == 1) begin
                    if (size_din_data_0 > 0) begin
                        size_din_data_0 = size_din_data_0 - 1;
                        if (size_din_data_0 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_0 = ap_c_n_tvin_trans_num_din_data_0 + 1;
                            size_din_data_0 = size_din_data_0_backup;
                        end
                    end
                end
            end
        end
    end
    
    
    `define STREAM_SIZE_IN_din_data_1 "../tv/stream_size/stream_size_in_din_data_1.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_din_data_1
        integer fp_din_data_1;
        reg [127:0] token_din_data_1;
        integer ret;
        
        ap_c_n_tvin_trans_num_din_data_1 = 0;
        end_din_data_1 = 0;
        wait (AESL_reset === 1);
        
        fp_din_data_1 = $fopen(`STREAM_SIZE_IN_din_data_1, "r");
        if(fp_din_data_1 == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_din_data_1);
            $finish;
        end
        read_token(fp_din_data_1, token_din_data_1); // should be [[[runtime]]]
        if (token_din_data_1 != "[[[runtime]]]") begin
            $display("ERROR: token_din_data_1 != \"[[[runtime]]]\"");
            $finish;
        end
        size_din_data_1 = 0;
        size_din_data_1_backup = 0;
        while (size_din_data_1 == 0 && end_din_data_1 == 0) begin
            ap_c_n_tvin_trans_num_din_data_1 = ap_c_n_tvin_trans_num_din_data_1 + 1;
            read_token(fp_din_data_1, token_din_data_1); // should be [[transaction]] or [[[/runtime]]]
            if (token_din_data_1 == "[[transaction]]") begin
                read_token(fp_din_data_1, token_din_data_1); // should be transaction number
                read_token(fp_din_data_1, token_din_data_1); // should be size for hls::stream
                ret = $sscanf(token_din_data_1, "%d", size_din_data_1);
                if (size_din_data_1 > 0) begin
                    size_din_data_1_backup = size_din_data_1;
                end
                read_token(fp_din_data_1, token_din_data_1); // should be [[/transaction]]
            end else if (token_din_data_1 == "[[[/runtime]]]") begin
                $fclose(fp_din_data_1);
                end_din_data_1 = 1;
            end else begin
                $display("ERROR: unknown token_din_data_1");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_din_data_1 == 0) begin
                if ((din_data_1_TREADY & din_data_1_TVALID) == 1) begin
                    if (size_din_data_1 > 0) begin
                        size_din_data_1 = size_din_data_1 - 1;
                        while (size_din_data_1 == 0 && end_din_data_1 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_1 = ap_c_n_tvin_trans_num_din_data_1 + 1;
                            read_token(fp_din_data_1, token_din_data_1); // should be [[transaction]] or [[[/runtime]]]
                            if (token_din_data_1 == "[[transaction]]") begin
                                read_token(fp_din_data_1, token_din_data_1); // should be transaction number
                                read_token(fp_din_data_1, token_din_data_1); // should be size for hls::stream
                                ret = $sscanf(token_din_data_1, "%d", size_din_data_1);
                                if (size_din_data_1 > 0) begin
                                    size_din_data_1_backup = size_din_data_1;
                                end
                                read_token(fp_din_data_1, token_din_data_1); // should be [[/transaction]]
                            end else if (token_din_data_1 == "[[[/runtime]]]") begin
                                size_din_data_1 = size_din_data_1_backup;
                                $fclose(fp_din_data_1);
                                end_din_data_1 = 1;
                            end else begin
                                $display("ERROR: unknown token_din_data_1");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if ((din_data_1_TREADY & din_data_1_TVALID) == 1) begin
                    if (size_din_data_1 > 0) begin
                        size_din_data_1 = size_din_data_1 - 1;
                        if (size_din_data_1 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_1 = ap_c_n_tvin_trans_num_din_data_1 + 1;
                            size_din_data_1 = size_din_data_1_backup;
                        end
                    end
                end
            end
        end
    end
    
    
    `define STREAM_SIZE_IN_din_data_2 "../tv/stream_size/stream_size_in_din_data_2.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_din_data_2
        integer fp_din_data_2;
        reg [127:0] token_din_data_2;
        integer ret;
        
        ap_c_n_tvin_trans_num_din_data_2 = 0;
        end_din_data_2 = 0;
        wait (AESL_reset === 1);
        
        fp_din_data_2 = $fopen(`STREAM_SIZE_IN_din_data_2, "r");
        if(fp_din_data_2 == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_din_data_2);
            $finish;
        end
        read_token(fp_din_data_2, token_din_data_2); // should be [[[runtime]]]
        if (token_din_data_2 != "[[[runtime]]]") begin
            $display("ERROR: token_din_data_2 != \"[[[runtime]]]\"");
            $finish;
        end
        size_din_data_2 = 0;
        size_din_data_2_backup = 0;
        while (size_din_data_2 == 0 && end_din_data_2 == 0) begin
            ap_c_n_tvin_trans_num_din_data_2 = ap_c_n_tvin_trans_num_din_data_2 + 1;
            read_token(fp_din_data_2, token_din_data_2); // should be [[transaction]] or [[[/runtime]]]
            if (token_din_data_2 == "[[transaction]]") begin
                read_token(fp_din_data_2, token_din_data_2); // should be transaction number
                read_token(fp_din_data_2, token_din_data_2); // should be size for hls::stream
                ret = $sscanf(token_din_data_2, "%d", size_din_data_2);
                if (size_din_data_2 > 0) begin
                    size_din_data_2_backup = size_din_data_2;
                end
                read_token(fp_din_data_2, token_din_data_2); // should be [[/transaction]]
            end else if (token_din_data_2 == "[[[/runtime]]]") begin
                $fclose(fp_din_data_2);
                end_din_data_2 = 1;
            end else begin
                $display("ERROR: unknown token_din_data_2");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_din_data_2 == 0) begin
                if ((din_data_2_TREADY & din_data_2_TVALID) == 1) begin
                    if (size_din_data_2 > 0) begin
                        size_din_data_2 = size_din_data_2 - 1;
                        while (size_din_data_2 == 0 && end_din_data_2 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_2 = ap_c_n_tvin_trans_num_din_data_2 + 1;
                            read_token(fp_din_data_2, token_din_data_2); // should be [[transaction]] or [[[/runtime]]]
                            if (token_din_data_2 == "[[transaction]]") begin
                                read_token(fp_din_data_2, token_din_data_2); // should be transaction number
                                read_token(fp_din_data_2, token_din_data_2); // should be size for hls::stream
                                ret = $sscanf(token_din_data_2, "%d", size_din_data_2);
                                if (size_din_data_2 > 0) begin
                                    size_din_data_2_backup = size_din_data_2;
                                end
                                read_token(fp_din_data_2, token_din_data_2); // should be [[/transaction]]
                            end else if (token_din_data_2 == "[[[/runtime]]]") begin
                                size_din_data_2 = size_din_data_2_backup;
                                $fclose(fp_din_data_2);
                                end_din_data_2 = 1;
                            end else begin
                                $display("ERROR: unknown token_din_data_2");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if ((din_data_2_TREADY & din_data_2_TVALID) == 1) begin
                    if (size_din_data_2 > 0) begin
                        size_din_data_2 = size_din_data_2 - 1;
                        if (size_din_data_2 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_2 = ap_c_n_tvin_trans_num_din_data_2 + 1;
                            size_din_data_2 = size_din_data_2_backup;
                        end
                    end
                end
            end
        end
    end
    
    
    `define STREAM_SIZE_IN_din_data_3 "../tv/stream_size/stream_size_in_din_data_3.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_din_data_3
        integer fp_din_data_3;
        reg [127:0] token_din_data_3;
        integer ret;
        
        ap_c_n_tvin_trans_num_din_data_3 = 0;
        end_din_data_3 = 0;
        wait (AESL_reset === 1);
        
        fp_din_data_3 = $fopen(`STREAM_SIZE_IN_din_data_3, "r");
        if(fp_din_data_3 == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_din_data_3);
            $finish;
        end
        read_token(fp_din_data_3, token_din_data_3); // should be [[[runtime]]]
        if (token_din_data_3 != "[[[runtime]]]") begin
            $display("ERROR: token_din_data_3 != \"[[[runtime]]]\"");
            $finish;
        end
        size_din_data_3 = 0;
        size_din_data_3_backup = 0;
        while (size_din_data_3 == 0 && end_din_data_3 == 0) begin
            ap_c_n_tvin_trans_num_din_data_3 = ap_c_n_tvin_trans_num_din_data_3 + 1;
            read_token(fp_din_data_3, token_din_data_3); // should be [[transaction]] or [[[/runtime]]]
            if (token_din_data_3 == "[[transaction]]") begin
                read_token(fp_din_data_3, token_din_data_3); // should be transaction number
                read_token(fp_din_data_3, token_din_data_3); // should be size for hls::stream
                ret = $sscanf(token_din_data_3, "%d", size_din_data_3);
                if (size_din_data_3 > 0) begin
                    size_din_data_3_backup = size_din_data_3;
                end
                read_token(fp_din_data_3, token_din_data_3); // should be [[/transaction]]
            end else if (token_din_data_3 == "[[[/runtime]]]") begin
                $fclose(fp_din_data_3);
                end_din_data_3 = 1;
            end else begin
                $display("ERROR: unknown token_din_data_3");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_din_data_3 == 0) begin
                if ((din_data_3_TREADY & din_data_3_TVALID) == 1) begin
                    if (size_din_data_3 > 0) begin
                        size_din_data_3 = size_din_data_3 - 1;
                        while (size_din_data_3 == 0 && end_din_data_3 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_3 = ap_c_n_tvin_trans_num_din_data_3 + 1;
                            read_token(fp_din_data_3, token_din_data_3); // should be [[transaction]] or [[[/runtime]]]
                            if (token_din_data_3 == "[[transaction]]") begin
                                read_token(fp_din_data_3, token_din_data_3); // should be transaction number
                                read_token(fp_din_data_3, token_din_data_3); // should be size for hls::stream
                                ret = $sscanf(token_din_data_3, "%d", size_din_data_3);
                                if (size_din_data_3 > 0) begin
                                    size_din_data_3_backup = size_din_data_3;
                                end
                                read_token(fp_din_data_3, token_din_data_3); // should be [[/transaction]]
                            end else if (token_din_data_3 == "[[[/runtime]]]") begin
                                size_din_data_3 = size_din_data_3_backup;
                                $fclose(fp_din_data_3);
                                end_din_data_3 = 1;
                            end else begin
                                $display("ERROR: unknown token_din_data_3");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if ((din_data_3_TREADY & din_data_3_TVALID) == 1) begin
                    if (size_din_data_3 > 0) begin
                        size_din_data_3 = size_din_data_3 - 1;
                        if (size_din_data_3 == 0) begin
                            ap_c_n_tvin_trans_num_din_data_3 = ap_c_n_tvin_trans_num_din_data_3 + 1;
                            size_din_data_3 = size_din_data_3_backup;
                        end
                    end
                end
            end
        end
    end
    
task write_binary;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;

reg dump_tvout_finish_dout_data_00;

initial begin : dump_tvout_runtime_sign_dout_data_00
    integer fp;
    dump_tvout_finish_dout_data_00 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_00_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_00_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_00_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_00_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_00 = 1;
end


reg dump_tvout_finish_dout_data_11;

initial begin : dump_tvout_runtime_sign_dout_data_11
    integer fp;
    dump_tvout_finish_dout_data_11 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_11_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_11_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_11_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_11_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_11 = 1;
end


reg dump_tvout_finish_dout_data_22;

initial begin : dump_tvout_runtime_sign_dout_data_22
    integer fp;
    dump_tvout_finish_dout_data_22 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_22_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_22_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_22_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_22_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_22 = 1;
end


reg dump_tvout_finish_dout_data_33;

initial begin : dump_tvout_runtime_sign_dout_data_33
    integer fp;
    dump_tvout_finish_dout_data_33 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_33_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_33_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_33_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_33_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_33 = 1;
end


reg dump_tvout_finish_dout_data_01;

initial begin : dump_tvout_runtime_sign_dout_data_01
    integer fp;
    dump_tvout_finish_dout_data_01 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_01_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_01_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_01_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_01_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_01 = 1;
end


reg dump_tvout_finish_dout_data_02;

initial begin : dump_tvout_runtime_sign_dout_data_02
    integer fp;
    dump_tvout_finish_dout_data_02 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_02_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_02_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_02_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_02_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_02 = 1;
end


reg dump_tvout_finish_dout_data_03;

initial begin : dump_tvout_runtime_sign_dout_data_03
    integer fp;
    dump_tvout_finish_dout_data_03 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_03_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_03_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_03_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_03_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_03 = 1;
end


reg dump_tvout_finish_dout_data_12;

initial begin : dump_tvout_runtime_sign_dout_data_12
    integer fp;
    dump_tvout_finish_dout_data_12 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_12_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_12_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_12_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_12_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_12 = 1;
end


reg dump_tvout_finish_dout_data_13;

initial begin : dump_tvout_runtime_sign_dout_data_13
    integer fp;
    dump_tvout_finish_dout_data_13 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_13_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_13_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_13_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_13_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_13 = 1;
end


reg dump_tvout_finish_dout_data_23;

initial begin : dump_tvout_runtime_sign_dout_data_23
    integer fp;
    dump_tvout_finish_dout_data_23 = 0;
    fp = $fopen(`AUTOTB_TVOUT_dout_data_23_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_23_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_dout_data_23_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_dout_data_23_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_dout_data_23 = 1;
end


////////////////////////////////////////////
// progress and performance
////////////////////////////////////////////

task wait_start();
    while (~AESL_start) begin
        @ (posedge AESL_clock);
    end
endtask

reg [31:0] clk_cnt = 0;
reg AESL_ready_p1;
reg AESL_start_p1;

always @ (posedge AESL_clock) begin
    if (AESL_reset == 0) begin
        clk_cnt <= 32'h0;
        AESL_ready_p1 <= 1'b0;
        AESL_start_p1 <= 1'b0;
    end
    else begin
        clk_cnt <= clk_cnt + 1;
        AESL_ready_p1 <= AESL_ready;
        AESL_start_p1 <= AESL_start;
    end
end

reg [31:0] start_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] start_cnt;
reg [31:0] ready_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] ap_ready_cnt;
reg [31:0] finish_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] finish_cnt;
reg [31:0] lat_total;
event report_progress;

always @(posedge AESL_clock)
begin
    if (finish_cnt == AUTOTB_TRANSACTION_NUM - 1 && AESL_done == 1'b1)
        lat_total = clk_cnt - start_timestamp[0];
end

initial begin
    start_cnt = 0;
    finish_cnt = 0;
    ap_ready_cnt = 0;
    wait (AESL_reset == 1);
    wait_start();
    start_timestamp[start_cnt] = clk_cnt;
    start_cnt = start_cnt + 1;
    if (AESL_done) begin
        finish_timestamp[finish_cnt] = clk_cnt;
        finish_cnt = finish_cnt + 1;
    end
    -> report_progress;
    forever begin
        @ (posedge AESL_clock);
        if (start_cnt < AUTOTB_TRANSACTION_NUM) begin
            if ((AESL_start && AESL_ready_p1)||(AESL_start && ~AESL_start_p1)) begin
                start_timestamp[start_cnt] = clk_cnt;
                start_cnt = start_cnt + 1;
            end
        end
        if (ap_ready_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_start_p1 && AESL_ready_p1) begin
                ready_timestamp[ap_ready_cnt] = clk_cnt;
                ap_ready_cnt = ap_ready_cnt + 1;
            end
        end
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                finish_timestamp[finish_cnt] = clk_cnt;
                finish_cnt = finish_cnt + 1;
            end
        end
        -> report_progress;
    end
end

reg [31:0] progress_timeout;

initial begin : simulation_progress
    real intra_progress;
    wait (AESL_reset == 1);
    progress_timeout = PROGRESS_TIMEOUT;
    $display("////////////////////////////////////////////////////////////////////////////////////");
    $display("// Inter-Transaction Progress: Completed Transaction / Total Transaction");
    $display("// Intra-Transaction Progress: Measured Latency / Latency Estimation * 100%%");
    $display("//");
    $display("// RTL Simulation : \"Inter-Transaction Progress\" [\"Intra-Transaction Progress\"] @ \"Simulation Time\"");
    $display("////////////////////////////////////////////////////////////////////////////////////");
    print_progress();
    while (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
        @ (report_progress);
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                print_progress();
                progress_timeout = PROGRESS_TIMEOUT;
            end else begin
                if (progress_timeout == 0) begin
                    print_progress();
                    progress_timeout = PROGRESS_TIMEOUT;
                end else begin
                    progress_timeout = progress_timeout - 1;
                end
            end
        end
    end
    print_progress();
    $display("////////////////////////////////////////////////////////////////////////////////////");
    calculate_performance();
end

task get_intra_progress(output real intra_progress);
    begin
        if (start_cnt > finish_cnt) begin
            intra_progress = clk_cnt - start_timestamp[finish_cnt];
        end else if(finish_cnt > 0) begin
            intra_progress = LATENCY_ESTIMATION;
        end else begin
            intra_progress = 0;
        end
        intra_progress = intra_progress / LATENCY_ESTIMATION;
    end
endtask

task print_progress();
    real intra_progress;
    begin
        if (LATENCY_ESTIMATION > 0) begin
            get_intra_progress(intra_progress);
            $display("// RTL Simulation : %0d / %0d [%2.2f%%] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, intra_progress * 100, $time);
        end else begin
            $display("// RTL Simulation : %0d / %0d [n/a] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, $time);
        end
    end
endtask

task calculate_performance();
    integer i;
    integer fp;
    reg [31:0] latency [0:AUTOTB_TRANSACTION_NUM - 1];
    reg [31:0] latency_min;
    reg [31:0] latency_max;
    reg [31:0] latency_total;
    reg [31:0] latency_average;
    reg [31:0] interval [0:AUTOTB_TRANSACTION_NUM - 2];
    reg [31:0] interval_min;
    reg [31:0] interval_max;
    reg [31:0] interval_total;
    reg [31:0] interval_average;
    reg [31:0] total_execute_time;
    begin
        latency_min = -1;
        latency_max = 0;
        latency_total = 0;
        interval_min = -1;
        interval_max = 0;
        interval_total = 0;
        total_execute_time = lat_total;

        for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
            // calculate latency
            latency[i] = finish_timestamp[i] - start_timestamp[i];
            if (latency[i] > latency_max) latency_max = latency[i];
            if (latency[i] < latency_min) latency_min = latency[i];
            latency_total = latency_total + latency[i];
            // calculate interval
            if (AUTOTB_TRANSACTION_NUM == 1) begin
                interval[i] = 0;
                interval_max = 0;
                interval_min = 0;
                interval_total = 0;
            end else if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                interval[i] = start_timestamp[i + 1] - start_timestamp[i];
                if (interval[i] > interval_max) interval_max = interval[i];
                if (interval[i] < interval_min) interval_min = interval[i];
                interval_total = interval_total + interval[i];
            end
        end

        latency_average = latency_total / AUTOTB_TRANSACTION_NUM;
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            interval_average = 0;
        end else begin
            interval_average = interval_total / (AUTOTB_TRANSACTION_NUM - 1);
        end

        fp = $fopen(`AUTOTB_LAT_RESULT_FILE, "w");

        $fdisplay(fp, "$MAX_LATENCY = \"%0d\"", latency_max);
        $fdisplay(fp, "$MIN_LATENCY = \"%0d\"", latency_min);
        $fdisplay(fp, "$AVER_LATENCY = \"%0d\"", latency_average);
        $fdisplay(fp, "$MAX_THROUGHPUT = \"%0d\"", interval_max);
        $fdisplay(fp, "$MIN_THROUGHPUT = \"%0d\"", interval_min);
        $fdisplay(fp, "$AVER_THROUGHPUT = \"%0d\"", interval_average);
        $fdisplay(fp, "$TOTAL_EXECUTE_TIME = \"%0d\"", total_execute_time);

        $fclose(fp);

        fp = $fopen(`AUTOTB_PER_RESULT_TRANS_FILE, "w");

        $fdisplay(fp, "%20s%16s%16s", "", "latency", "interval");
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            i = 0;
            $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
        end else begin
            for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
                if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                    $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
                end else begin
                    $fdisplay(fp, "transaction%8d:%16d               x", i, latency[i]);
                end
            end
        end

        $fclose(fp);
    end
endtask


////////////////////////////////////////////
// Dependence Check
////////////////////////////////////////////

`ifndef POST_SYN

`endif

AESL_deadlock_kernel_monitor_top kernel_monitor_top(
    .kernel_monitor_reset(~AESL_reset),
    .kernel_monitor_clock(AESL_clock));

///////////////////////////////////////////////////////
// dataflow status monitor
///////////////////////////////////////////////////////
dataflow_monitor U_dataflow_monitor(
    .clock(AESL_clock),
    .reset(~rst),
    .finish(all_finish));

`include "fifo_para.vh"

endmodule
