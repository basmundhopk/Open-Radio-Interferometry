// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================

extern "C" void AESL_WRAP_correlator (
hls::stream<int > din_data_0,
hls::stream<int > din_data_1,
hls::stream<int > din_data_2,
hls::stream<int > din_data_3,
hls::stream<int > dout_data_00,
hls::stream<int > dout_data_11,
hls::stream<int > dout_data_22,
hls::stream<int > dout_data_33,
hls::stream<int > dout_data_01,
hls::stream<int > dout_data_02,
hls::stream<int > dout_data_03,
hls::stream<int > dout_data_12,
hls::stream<int > dout_data_13,
hls::stream<int > dout_data_23,
int integration_time_frames);
