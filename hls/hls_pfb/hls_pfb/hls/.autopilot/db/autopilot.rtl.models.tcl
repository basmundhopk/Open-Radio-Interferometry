set SynModuleInfo {
  {SRCNAME pfb_multichannel MODELNAME pfb_multichannel RTLNAME pfb_multichannel IS_TOP 1
    SUBMODULES {
      {MODELNAME pfb_multichannel_mul_16s_16s_32_1_1 RTLNAME pfb_multichannel_mul_16s_16s_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME pfb_multichannel_sparsemux_9_2_16_1_1 RTLNAME pfb_multichannel_sparsemux_9_2_16_1_1 BINDTYPE op TYPE sparsemux IMPL auto}
      {MODELNAME pfb_multichannel_mac_muladd_16s_16s_32s_33_4_1 RTLNAME pfb_multichannel_mac_muladd_16s_16s_32s_33_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME pfb_multichannel_mac_muladd_16s_16s_33s_33_4_1 RTLNAME pfb_multichannel_mac_muladd_16s_16s_33s_33_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME pfb_multichannel_compute_pfb_stream_stream_ap_fixed_const_bool_local_coeffs_3_RAM_AUTO_1R1W RTLNAME pfb_multichannel_compute_pfb_stream_stream_ap_fixed_const_bool_local_coeffs_3_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME pfb_multichannel_compute_pfb_stream_stream_ap_fixed_const_bool_branch_memory_31_RAM_1P_BRAM_1R1W RTLNAME pfb_multichannel_compute_pfb_stream_stream_ap_fixed_const_bool_branch_memory_31_RAM_1P_BRAM_1R1W BINDTYPE storage TYPE ram_1p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME pfb_multichannel_fifo_w128_d2_S RTLNAME pfb_multichannel_fifo_w128_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME stream_read_to_compute_U}
      {MODELNAME pfb_multichannel_fifo_w128_d2_S RTLNAME pfb_multichannel_fifo_w128_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME stream_compute_to_fft_U}
      {MODELNAME pfb_multichannel_gmem_m_axi RTLNAME pfb_multichannel_gmem_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME pfb_multichannel_control_s_axi RTLNAME pfb_multichannel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME pfb_multichannel_control_r_s_axi RTLNAME pfb_multichannel_control_r_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME pfb_multichannel_regslice_both RTLNAME pfb_multichannel_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME pfb_multichannel_regslice_both_U}
    }
  }
}
