set moduleName correlator_Pipeline_Offload_Loop
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set C_modelName {correlator_Pipeline_Offload_Loop}
set C_modelType { void 0 }
set C_modelArgList {
	{ zext_ln76 int 11 regular  }
	{ dout_data_00 int 128 regular {axi_s 1 volatile  { dout_data_00 Data } }  }
	{ dout_data_11 int 128 regular {axi_s 1 volatile  { dout_data_11 Data } }  }
	{ dout_data_22 int 128 regular {axi_s 1 volatile  { dout_data_22 Data } }  }
	{ dout_data_33 int 128 regular {axi_s 1 volatile  { dout_data_33 Data } }  }
	{ dout_data_01 int 128 regular {axi_s 1 volatile  { dout_data_01 Data } }  }
	{ dout_data_02 int 128 regular {axi_s 1 volatile  { dout_data_02 Data } }  }
	{ dout_data_03 int 128 regular {axi_s 1 volatile  { dout_data_03 Data } }  }
	{ dout_data_12 int 128 regular {axi_s 1 volatile  { dout_data_12 Data } }  }
	{ dout_data_13 int 128 regular {axi_s 1 volatile  { dout_data_13 Data } }  }
	{ dout_data_23 int 128 regular {axi_s 1 volatile  { dout_data_23 Data } }  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17 int 1 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16 int 1 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15 int 1 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14 int 1 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 int 64 regular {array 2048 { 3 2 } 1 1 } {global 2}  }
}
set hasAXIMCache 0
set AXIMCacheInstList { }
set C_modelArgMapList {[ 
	{ "Name" : "zext_ln76", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "dout_data_00", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_11", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_22", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_33", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_01", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_02", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_03", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_12", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_13", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dout_data_23", "interface" : "axis", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "interface" : "memory", "bitwidth" : 1, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "interface" : "memory", "bitwidth" : 1, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "interface" : "memory", "bitwidth" : 1, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "interface" : "memory", "bitwidth" : 1, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} ]}
# RTL Port declarations: 
set portNum 137
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ dout_data_00_TREADY sc_in sc_logic 1 outacc 1 } 
	{ dout_data_11_TREADY sc_in sc_logic 1 outacc 2 } 
	{ dout_data_22_TREADY sc_in sc_logic 1 outacc 3 } 
	{ dout_data_33_TREADY sc_in sc_logic 1 outacc 4 } 
	{ dout_data_01_TREADY sc_in sc_logic 1 outacc 5 } 
	{ dout_data_02_TREADY sc_in sc_logic 1 outacc 6 } 
	{ dout_data_03_TREADY sc_in sc_logic 1 outacc 7 } 
	{ dout_data_12_TREADY sc_in sc_logic 1 outacc 8 } 
	{ dout_data_13_TREADY sc_in sc_logic 1 outacc 9 } 
	{ dout_data_23_TREADY sc_in sc_logic 1 outacc 10 } 
	{ zext_ln76 sc_in sc_lv 11 signal 0 } 
	{ dout_data_00_TDATA sc_out sc_lv 128 signal 1 } 
	{ dout_data_00_TVALID sc_out sc_logic 1 outvld 1 } 
	{ dout_data_11_TDATA sc_out sc_lv 128 signal 2 } 
	{ dout_data_11_TVALID sc_out sc_logic 1 outvld 2 } 
	{ dout_data_22_TDATA sc_out sc_lv 128 signal 3 } 
	{ dout_data_22_TVALID sc_out sc_logic 1 outvld 3 } 
	{ dout_data_33_TDATA sc_out sc_lv 128 signal 4 } 
	{ dout_data_33_TVALID sc_out sc_logic 1 outvld 4 } 
	{ dout_data_01_TDATA sc_out sc_lv 128 signal 5 } 
	{ dout_data_01_TVALID sc_out sc_logic 1 outvld 5 } 
	{ dout_data_02_TDATA sc_out sc_lv 128 signal 6 } 
	{ dout_data_02_TVALID sc_out sc_logic 1 outvld 6 } 
	{ dout_data_03_TDATA sc_out sc_lv 128 signal 7 } 
	{ dout_data_03_TVALID sc_out sc_logic 1 outvld 7 } 
	{ dout_data_12_TDATA sc_out sc_lv 128 signal 8 } 
	{ dout_data_12_TVALID sc_out sc_logic 1 outvld 8 } 
	{ dout_data_13_TDATA sc_out sc_lv 128 signal 9 } 
	{ dout_data_13_TVALID sc_out sc_logic 1 outvld 9 } 
	{ dout_data_23_TDATA sc_out sc_lv 128 signal 10 } 
	{ dout_data_23_TVALID sc_out sc_logic 1 outvld 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1 sc_out sc_lv 11 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1 sc_out sc_logic 1 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1 sc_out sc_logic 1 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1 sc_out sc_lv 64 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q1 sc_in sc_lv 64 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_address1 sc_out sc_lv 11 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_ce1 sc_out sc_logic 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_we1 sc_out sc_logic 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_d1 sc_out sc_lv 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_q1 sc_in sc_lv 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1 sc_out sc_lv 11 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1 sc_out sc_logic 1 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1 sc_out sc_logic 1 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1 sc_out sc_lv 64 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q1 sc_in sc_lv 64 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_address1 sc_out sc_lv 11 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_ce1 sc_out sc_logic 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_we1 sc_out sc_logic 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_d1 sc_out sc_lv 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_q1 sc_in sc_lv 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1 sc_out sc_lv 11 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1 sc_out sc_logic 1 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1 sc_out sc_logic 1 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1 sc_out sc_lv 64 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q1 sc_in sc_lv 64 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_address1 sc_out sc_lv 11 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_ce1 sc_out sc_logic 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_we1 sc_out sc_logic 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_d1 sc_out sc_lv 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_q1 sc_in sc_lv 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1 sc_out sc_lv 11 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1 sc_out sc_logic 1 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1 sc_out sc_logic 1 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1 sc_out sc_lv 64 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q1 sc_in sc_lv 64 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_address1 sc_out sc_lv 11 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_ce1 sc_out sc_logic 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_we1 sc_out sc_logic 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_d1 sc_out sc_lv 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_q1 sc_in sc_lv 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1 sc_out sc_lv 11 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1 sc_out sc_logic 1 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1 sc_out sc_logic 1 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1 sc_out sc_lv 64 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q1 sc_in sc_lv 64 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1 sc_out sc_lv 11 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1 sc_out sc_logic 1 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1 sc_out sc_logic 1 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1 sc_out sc_lv 64 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q1 sc_in sc_lv 64 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1 sc_out sc_lv 11 signal 21 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1 sc_out sc_logic 1 signal 21 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1 sc_out sc_logic 1 signal 21 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1 sc_out sc_lv 64 signal 21 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q1 sc_in sc_lv 64 signal 21 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1 sc_out sc_lv 11 signal 22 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1 sc_out sc_logic 1 signal 22 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1 sc_out sc_logic 1 signal 22 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1 sc_out sc_lv 64 signal 22 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q1 sc_in sc_lv 64 signal 22 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1 sc_out sc_lv 11 signal 23 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1 sc_out sc_logic 1 signal 23 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1 sc_out sc_logic 1 signal 23 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1 sc_out sc_lv 64 signal 23 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q1 sc_in sc_lv 64 signal 23 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1 sc_out sc_lv 11 signal 24 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1 sc_out sc_logic 1 signal 24 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1 sc_out sc_logic 1 signal 24 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1 sc_out sc_lv 64 signal 24 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q1 sc_in sc_lv 64 signal 24 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1 sc_out sc_lv 11 signal 25 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1 sc_out sc_logic 1 signal 25 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1 sc_out sc_logic 1 signal 25 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1 sc_out sc_lv 64 signal 25 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q1 sc_in sc_lv 64 signal 25 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1 sc_out sc_lv 11 signal 26 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1 sc_out sc_logic 1 signal 26 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1 sc_out sc_logic 1 signal 26 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1 sc_out sc_lv 64 signal 26 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q1 sc_in sc_lv 64 signal 26 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1 sc_out sc_lv 11 signal 27 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1 sc_out sc_logic 1 signal 27 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1 sc_out sc_logic 1 signal 27 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1 sc_out sc_lv 64 signal 27 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q1 sc_in sc_lv 64 signal 27 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1 sc_out sc_lv 11 signal 28 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1 sc_out sc_logic 1 signal 28 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1 sc_out sc_logic 1 signal 28 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1 sc_out sc_lv 64 signal 28 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q1 sc_in sc_lv 64 signal 28 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1 sc_out sc_lv 11 signal 29 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1 sc_out sc_logic 1 signal 29 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1 sc_out sc_logic 1 signal 29 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1 sc_out sc_lv 64 signal 29 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q1 sc_in sc_lv 64 signal 29 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1 sc_out sc_lv 11 signal 30 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1 sc_out sc_logic 1 signal 30 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1 sc_out sc_logic 1 signal 30 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1 sc_out sc_lv 64 signal 30 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q1 sc_in sc_lv 64 signal 30 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "dout_data_00_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_00", "role": "TREADY" }} , 
 	{ "name": "dout_data_11_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_11", "role": "TREADY" }} , 
 	{ "name": "dout_data_22_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_22", "role": "TREADY" }} , 
 	{ "name": "dout_data_33_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_33", "role": "TREADY" }} , 
 	{ "name": "dout_data_01_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_01", "role": "TREADY" }} , 
 	{ "name": "dout_data_02_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_02", "role": "TREADY" }} , 
 	{ "name": "dout_data_03_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_03", "role": "TREADY" }} , 
 	{ "name": "dout_data_12_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_12", "role": "TREADY" }} , 
 	{ "name": "dout_data_13_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_13", "role": "TREADY" }} , 
 	{ "name": "dout_data_23_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_23", "role": "TREADY" }} , 
 	{ "name": "zext_ln76", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "zext_ln76", "role": "default" }} , 
 	{ "name": "dout_data_00_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_00", "role": "TDATA" }} , 
 	{ "name": "dout_data_00_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_00", "role": "TVALID" }} , 
 	{ "name": "dout_data_11_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_11", "role": "TDATA" }} , 
 	{ "name": "dout_data_11_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_11", "role": "TVALID" }} , 
 	{ "name": "dout_data_22_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_22", "role": "TDATA" }} , 
 	{ "name": "dout_data_22_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_22", "role": "TVALID" }} , 
 	{ "name": "dout_data_33_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_33", "role": "TDATA" }} , 
 	{ "name": "dout_data_33_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_33", "role": "TVALID" }} , 
 	{ "name": "dout_data_01_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_01", "role": "TDATA" }} , 
 	{ "name": "dout_data_01_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_01", "role": "TVALID" }} , 
 	{ "name": "dout_data_02_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_02", "role": "TDATA" }} , 
 	{ "name": "dout_data_02_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_02", "role": "TVALID" }} , 
 	{ "name": "dout_data_03_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_03", "role": "TDATA" }} , 
 	{ "name": "dout_data_03_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_03", "role": "TVALID" }} , 
 	{ "name": "dout_data_12_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_12", "role": "TDATA" }} , 
 	{ "name": "dout_data_12_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_12", "role": "TVALID" }} , 
 	{ "name": "dout_data_13_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_13", "role": "TDATA" }} , 
 	{ "name": "dout_data_13_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_13", "role": "TVALID" }} , 
 	{ "name": "dout_data_23_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_23", "role": "TDATA" }} , 
 	{ "name": "dout_data_23_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_23", "role": "TVALID" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "q1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "q1" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "correlator_Pipeline_Offload_Loop",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1026", "EstimateLatencyMax" : "1026",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "zext_ln76", "Type" : "None", "Direction" : "I"},
			{"Name" : "dout_data_00", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_00_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_11", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_11_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_22", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_22_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_33", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_33_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_01", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_01_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_02", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_02_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_03", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_03_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_12", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_12_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_13", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_13_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_data_23", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_data_23_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Type" : "Memory", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "Offload_Loop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	correlator_Pipeline_Offload_Loop {
		zext_ln76 {Type I LastRead 0 FirstWrite -1}
		dout_data_00 {Type O LastRead -1 FirstWrite 1}
		dout_data_11 {Type O LastRead -1 FirstWrite 1}
		dout_data_22 {Type O LastRead -1 FirstWrite 1}
		dout_data_33 {Type O LastRead -1 FirstWrite 1}
		dout_data_01 {Type O LastRead -1 FirstWrite 1}
		dout_data_02 {Type O LastRead -1 FirstWrite 1}
		dout_data_03 {Type O LastRead -1 FirstWrite 1}
		dout_data_12 {Type O LastRead -1 FirstWrite 1}
		dout_data_13 {Type O LastRead -1 FirstWrite 1}
		dout_data_23 {Type O LastRead -1 FirstWrite 1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea {Type IO LastRead 0 FirstWrite 0}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 {Type IO LastRead 0 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1026", "Max" : "1026"}
	, {"Name" : "Interval", "Min" : "1026", "Max" : "1026"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	zext_ln76 { ap_none {  { zext_ln76 in_data 0 11 } } }
	dout_data_00 { axis {  { dout_data_00_TREADY out_acc 0 1 }  { dout_data_00_TDATA out_data 1 128 }  { dout_data_00_TVALID out_vld 1 1 } } }
	dout_data_11 { axis {  { dout_data_11_TREADY out_acc 0 1 }  { dout_data_11_TDATA out_data 1 128 }  { dout_data_11_TVALID out_vld 1 1 } } }
	dout_data_22 { axis {  { dout_data_22_TREADY out_acc 0 1 }  { dout_data_22_TDATA out_data 1 128 }  { dout_data_22_TVALID out_vld 1 1 } } }
	dout_data_33 { axis {  { dout_data_33_TREADY out_acc 0 1 }  { dout_data_33_TDATA out_data 1 128 }  { dout_data_33_TVALID out_vld 1 1 } } }
	dout_data_01 { axis {  { dout_data_01_TREADY out_acc 0 1 }  { dout_data_01_TDATA out_data 1 128 }  { dout_data_01_TVALID out_vld 1 1 } } }
	dout_data_02 { axis {  { dout_data_02_TREADY out_acc 0 1 }  { dout_data_02_TDATA out_data 1 128 }  { dout_data_02_TVALID out_vld 1 1 } } }
	dout_data_03 { axis {  { dout_data_03_TREADY out_acc 0 1 }  { dout_data_03_TDATA out_data 1 128 }  { dout_data_03_TVALID out_vld 1 1 } } }
	dout_data_12 { axis {  { dout_data_12_TREADY out_acc 0 1 }  { dout_data_12_TDATA out_data 1 128 }  { dout_data_12_TVALID out_vld 1 1 } } }
	dout_data_13 { axis {  { dout_data_13_TREADY out_acc 0 1 }  { dout_data_13_TDATA out_data 1 128 }  { dout_data_13_TVALID out_vld 1 1 } } }
	dout_data_23 { axis {  { dout_data_23_TREADY out_acc 0 1 }  { dout_data_23_TDATA out_data 1 128 }  { dout_data_23_TVALID out_vld 1 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_d1 MemPortDIN2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_q1 in_data 0 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_d1 MemPortDIN2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_q1 in_data 0 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_d1 MemPortDIN2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_q1 in_data 0 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_d1 MemPortDIN2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_q1 in_data 0 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q1 in_data 0 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1 MemPortDIN2 1 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q1 in_data 0 64 } } }
}
