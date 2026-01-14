set SynModuleInfo {
  {SRCNAME correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3 MODELNAME correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3 RTLNAME correlator_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3
    SUBMODULES {
      {MODELNAME correlator_flow_control_loop_pipe_sequential_init RTLNAME correlator_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME correlator_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME correlator_Pipeline_Process_Frame_Loop MODELNAME correlator_Pipeline_Process_Frame_Loop RTLNAME correlator_correlator_Pipeline_Process_Frame_Loop
    SUBMODULES {
      {MODELNAME correlator_mul_16s_16s_16_1_1 RTLNAME correlator_mul_16s_16s_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME correlator_ama_submuladd_1ns_16s_16s_16ns_16_4_1 RTLNAME correlator_ama_submuladd_1ns_16s_16s_16ns_16_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME correlator_mac_muladd_16s_16s_16ns_16_4_1 RTLNAME correlator_mac_muladd_16s_16s_16ns_16_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME correlator_Pipeline_Offload_Loop MODELNAME correlator_Pipeline_Offload_Loop RTLNAME correlator_correlator_Pipeline_Offload_Loop}
  {SRCNAME correlator MODELNAME correlator RTLNAME correlator IS_TOP 1
    SUBMODULES {
      {MODELNAME correlator_correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_Rbkb RTLNAME correlator_correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_Rbkb BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME correlator_correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_Rcud RTLNAME correlator_correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_Rcud BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME correlator_control_s_axi RTLNAME correlator_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME correlator_regslice_both RTLNAME correlator_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME correlator_regslice_both_U}
    }
  }
}
