`timescale 1 ns / 1 ps

module AESL_deadlock_kernel_monitor_top ( 
    input wire kernel_monitor_clock,
    input wire kernel_monitor_reset
);
wire [13:0] axis_block_sigs;
wire [2:0] inst_idle_sigs;
wire [0:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~AESL_inst_correlator.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.din_data_0_TDATA_blk_n;
assign axis_block_sigs[1] = ~AESL_inst_correlator.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.din_data_1_TDATA_blk_n;
assign axis_block_sigs[2] = ~AESL_inst_correlator.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.din_data_2_TDATA_blk_n;
assign axis_block_sigs[3] = ~AESL_inst_correlator.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.din_data_3_TDATA_blk_n;
assign axis_block_sigs[4] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_00_TDATA_blk_n;
assign axis_block_sigs[5] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_11_TDATA_blk_n;
assign axis_block_sigs[6] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_22_TDATA_blk_n;
assign axis_block_sigs[7] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_33_TDATA_blk_n;
assign axis_block_sigs[8] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_01_TDATA_blk_n;
assign axis_block_sigs[9] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_02_TDATA_blk_n;
assign axis_block_sigs[10] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_03_TDATA_blk_n;
assign axis_block_sigs[11] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_12_TDATA_blk_n;
assign axis_block_sigs[12] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_13_TDATA_blk_n;
assign axis_block_sigs[13] = ~AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.dout_data_23_TDATA_blk_n;

assign inst_block_sigs[0] = 1'b0;

assign inst_idle_sigs[0] = 1'b0;
assign inst_idle_sigs[1] = AESL_inst_correlator.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.ap_idle;
assign inst_idle_sigs[2] = AESL_inst_correlator.grp_correlator_Pipeline_Offload_Loop_fu_236.ap_idle;

AESL_deadlock_idx0_monitor AESL_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);


initial begin : trigger_axis_deadlock
reg block_delay;
    block_delay = 0;
    while(1) begin
        @(posedge kernel_monitor_clock);
    if (kernel_block == 1'b1 && block_delay == 1'b0)
        block_delay = kernel_block;
    end
end

endmodule
