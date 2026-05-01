
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [11:0] axis_block_sigs;
wire [5:0] inst_idle_sigs;
wire [2:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~read_inputs_U0.din_data_i0_TDATA_blk_n;
assign axis_block_sigs[1] = ~read_inputs_U0.din_data_q0_TDATA_blk_n;
assign axis_block_sigs[2] = ~read_inputs_U0.din_data_i1_TDATA_blk_n;
assign axis_block_sigs[3] = ~read_inputs_U0.din_data_q1_TDATA_blk_n;
assign axis_block_sigs[4] = ~read_inputs_U0.din_data_i2_TDATA_blk_n;
assign axis_block_sigs[5] = ~read_inputs_U0.din_data_q2_TDATA_blk_n;
assign axis_block_sigs[6] = ~read_inputs_U0.din_data_i3_TDATA_blk_n;
assign axis_block_sigs[7] = ~read_inputs_U0.din_data_q3_TDATA_blk_n;
assign axis_block_sigs[8] = ~write_outputs_U0.dout_data_0_TDATA_blk_n;
assign axis_block_sigs[9] = ~write_outputs_U0.dout_data_1_TDATA_blk_n;
assign axis_block_sigs[10] = ~write_outputs_U0.dout_data_2_TDATA_blk_n;
assign axis_block_sigs[11] = ~write_outputs_U0.dout_data_3_TDATA_blk_n;

assign inst_idle_sigs[0] = read_inputs_U0.ap_idle;
assign inst_block_sigs[0] = (read_inputs_U0.ap_done & ~read_inputs_U0.ap_continue) | ~read_inputs_U0.stream_read_to_compute_blk_n;
assign inst_idle_sigs[1] = compute_pfb_U0.ap_idle;
assign inst_block_sigs[1] = (compute_pfb_U0.ap_done & ~compute_pfb_U0.ap_continue) | ~compute_pfb_U0.grp_compute_pfb_Pipeline_compute_loop_fu_168.stream_read_to_compute_blk_n | ~compute_pfb_U0.grp_compute_pfb_Pipeline_compute_loop_fu_168.stream_compute_to_write_blk_n;
assign inst_idle_sigs[2] = write_outputs_U0.ap_idle;
assign inst_block_sigs[2] = (write_outputs_U0.ap_done & ~write_outputs_U0.ap_continue) | ~write_outputs_U0.stream_compute_to_write_blk_n;

assign inst_idle_sigs[3] = 1'b0;
assign inst_idle_sigs[4] = read_inputs_U0.ap_idle;
assign inst_idle_sigs[5] = write_outputs_U0.ap_idle;

pfb_multichannel_decimator_hls_deadlock_idx0_monitor pfb_multichannel_decimator_hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);


always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
