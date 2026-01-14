set moduleName correlator_Pipeline_Process_Frame_Loop
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
set C_modelName {correlator_Pipeline_Process_Frame_Loop}
set C_modelType { void 0 }
set C_modelArgList {
	{ zext_ln76 int 11 regular  }
	{ din_data_0 int 32 regular {axi_s 0 volatile  { din_data_0 Data } }  }
	{ din_data_1 int 32 regular {axi_s 0 volatile  { din_data_1 Data } }  }
	{ din_data_2 int 32 regular {axi_s 0 volatile  { din_data_2 Data } }  }
	{ din_data_3 int 32 regular {axi_s 0 volatile  { din_data_3 Data } }  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 int 64 regular {array 2048 { 1 0 } 1 1 } {global 2}  }
}
set hasAXIMCache 0
set AXIMCacheInstList { }
set C_modelArgMapList {[ 
	{ "Name" : "zext_ln76", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_0", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_1", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_2", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_3", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "interface" : "memory", "bitwidth" : 64, "direction" : "READWRITE", "extern" : 0} , 
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
set portNum 131
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ din_data_0_TVALID sc_in sc_logic 1 invld 1 } 
	{ din_data_1_TVALID sc_in sc_logic 1 invld 2 } 
	{ din_data_2_TVALID sc_in sc_logic 1 invld 3 } 
	{ din_data_3_TVALID sc_in sc_logic 1 invld 4 } 
	{ zext_ln76 sc_in sc_lv 11 signal 0 } 
	{ din_data_0_TDATA sc_in sc_lv 32 signal 1 } 
	{ din_data_0_TREADY sc_out sc_logic 1 inacc 1 } 
	{ din_data_1_TDATA sc_in sc_lv 32 signal 2 } 
	{ din_data_1_TREADY sc_out sc_logic 1 inacc 2 } 
	{ din_data_2_TDATA sc_in sc_lv 32 signal 3 } 
	{ din_data_2_TREADY sc_out sc_logic 1 inacc 3 } 
	{ din_data_3_TDATA sc_in sc_lv 32 signal 4 } 
	{ din_data_3_TREADY sc_out sc_logic 1 inacc 4 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address0 sc_out sc_lv 11 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce0 sc_out sc_logic 1 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q0 sc_in sc_lv 64 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1 sc_out sc_lv 11 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1 sc_out sc_logic 1 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1 sc_out sc_logic 1 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1 sc_out sc_lv 64 signal 5 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address0 sc_out sc_lv 11 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce0 sc_out sc_logic 1 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q0 sc_in sc_lv 64 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1 sc_out sc_lv 11 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1 sc_out sc_logic 1 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1 sc_out sc_logic 1 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1 sc_out sc_lv 64 signal 6 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address0 sc_out sc_lv 11 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce0 sc_out sc_logic 1 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q0 sc_in sc_lv 64 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1 sc_out sc_lv 11 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1 sc_out sc_logic 1 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1 sc_out sc_logic 1 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1 sc_out sc_lv 64 signal 7 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address0 sc_out sc_lv 11 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce0 sc_out sc_logic 1 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q0 sc_in sc_lv 64 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1 sc_out sc_lv 11 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1 sc_out sc_logic 1 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1 sc_out sc_logic 1 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1 sc_out sc_lv 64 signal 8 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address0 sc_out sc_lv 11 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce0 sc_out sc_logic 1 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q0 sc_in sc_lv 64 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1 sc_out sc_lv 11 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1 sc_out sc_logic 1 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1 sc_out sc_logic 1 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1 sc_out sc_lv 64 signal 9 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address0 sc_out sc_lv 11 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce0 sc_out sc_logic 1 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q0 sc_in sc_lv 64 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1 sc_out sc_lv 11 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1 sc_out sc_logic 1 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1 sc_out sc_logic 1 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1 sc_out sc_lv 64 signal 10 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address0 sc_out sc_lv 11 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce0 sc_out sc_logic 1 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q0 sc_in sc_lv 64 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1 sc_out sc_lv 11 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1 sc_out sc_logic 1 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1 sc_out sc_logic 1 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1 sc_out sc_lv 64 signal 11 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address0 sc_out sc_lv 11 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce0 sc_out sc_logic 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q0 sc_in sc_lv 64 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1 sc_out sc_lv 11 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1 sc_out sc_logic 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1 sc_out sc_logic 1 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1 sc_out sc_lv 64 signal 12 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address0 sc_out sc_lv 11 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce0 sc_out sc_logic 1 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q0 sc_in sc_lv 64 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1 sc_out sc_lv 11 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1 sc_out sc_logic 1 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1 sc_out sc_logic 1 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1 sc_out sc_lv 64 signal 13 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address0 sc_out sc_lv 11 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce0 sc_out sc_logic 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q0 sc_in sc_lv 64 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1 sc_out sc_lv 11 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1 sc_out sc_logic 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1 sc_out sc_logic 1 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1 sc_out sc_lv 64 signal 14 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address0 sc_out sc_lv 11 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce0 sc_out sc_logic 1 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q0 sc_in sc_lv 64 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1 sc_out sc_lv 11 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1 sc_out sc_logic 1 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1 sc_out sc_logic 1 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1 sc_out sc_lv 64 signal 15 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address0 sc_out sc_lv 11 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce0 sc_out sc_logic 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q0 sc_in sc_lv 64 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1 sc_out sc_lv 11 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1 sc_out sc_logic 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1 sc_out sc_logic 1 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1 sc_out sc_lv 64 signal 16 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address0 sc_out sc_lv 11 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce0 sc_out sc_logic 1 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q0 sc_in sc_lv 64 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1 sc_out sc_lv 11 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1 sc_out sc_logic 1 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1 sc_out sc_logic 1 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1 sc_out sc_lv 64 signal 17 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address0 sc_out sc_lv 11 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce0 sc_out sc_logic 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q0 sc_in sc_lv 64 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1 sc_out sc_lv 11 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1 sc_out sc_logic 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1 sc_out sc_logic 1 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1 sc_out sc_lv 64 signal 18 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address0 sc_out sc_lv 11 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce0 sc_out sc_logic 1 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q0 sc_in sc_lv 64 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1 sc_out sc_lv 11 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1 sc_out sc_logic 1 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1 sc_out sc_logic 1 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1 sc_out sc_lv 64 signal 19 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address0 sc_out sc_lv 11 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce0 sc_out sc_logic 1 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q0 sc_in sc_lv 64 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1 sc_out sc_lv 11 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1 sc_out sc_logic 1 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1 sc_out sc_logic 1 signal 20 } 
	{ correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1 sc_out sc_lv 64 signal 20 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "din_data_0_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_0", "role": "TVALID" }} , 
 	{ "name": "din_data_1_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_1", "role": "TVALID" }} , 
 	{ "name": "din_data_2_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_2", "role": "TVALID" }} , 
 	{ "name": "din_data_3_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_3", "role": "TVALID" }} , 
 	{ "name": "zext_ln76", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "zext_ln76", "role": "default" }} , 
 	{ "name": "din_data_0_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_0", "role": "TDATA" }} , 
 	{ "name": "din_data_0_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_0", "role": "TREADY" }} , 
 	{ "name": "din_data_1_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_1", "role": "TDATA" }} , 
 	{ "name": "din_data_1_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_1", "role": "TREADY" }} , 
 	{ "name": "din_data_2_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_2", "role": "TDATA" }} , 
 	{ "name": "din_data_2_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_2", "role": "TREADY" }} , 
 	{ "name": "din_data_3_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_3", "role": "TDATA" }} , 
 	{ "name": "din_data_3_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_3", "role": "TREADY" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "role": "d1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "address0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "ce0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "q0" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "address1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "ce1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "we1" }} , 
 	{ "name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "role": "d1" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33"],
		"CDFG" : "correlator_Pipeline_Process_Frame_Loop",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1029", "EstimateLatencyMax" : "1029",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "zext_ln76", "Type" : "None", "Direction" : "I"},
			{"Name" : "din_data_0", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "din_data_0_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "din_data_1", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "din_data_1_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "din_data_2", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "din_data_2_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "din_data_3", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "din_data_3_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Type" : "Memory", "Direction" : "IO"},
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
			{"Name" : "Process_Frame_Loop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U21", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U22", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U23", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U24", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U25", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U26", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U27", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U28", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U29", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U30", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U31", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U32", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U33", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U34", "Parent" : "0"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U35", "Parent" : "0"},
	{"ID" : "16", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_16s_16_1_1_U36", "Parent" : "0"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.ama_submuladd_1ns_16s_16s_16ns_16_4_1_U37", "Parent" : "0"},
	{"ID" : "18", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U38", "Parent" : "0"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U39", "Parent" : "0"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U40", "Parent" : "0"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U41", "Parent" : "0"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U42", "Parent" : "0"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U43", "Parent" : "0"},
	{"ID" : "24", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U44", "Parent" : "0"},
	{"ID" : "25", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U45", "Parent" : "0"},
	{"ID" : "26", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U46", "Parent" : "0"},
	{"ID" : "27", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U47", "Parent" : "0"},
	{"ID" : "28", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U48", "Parent" : "0"},
	{"ID" : "29", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U49", "Parent" : "0"},
	{"ID" : "30", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U50", "Parent" : "0"},
	{"ID" : "31", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U51", "Parent" : "0"},
	{"ID" : "32", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_16ns_16_4_1_U52", "Parent" : "0"},
	{"ID" : "33", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	correlator_Pipeline_Process_Frame_Loop {
		zext_ln76 {Type I LastRead 0 FirstWrite -1}
		din_data_0 {Type I LastRead 0 FirstWrite -1}
		din_data_1 {Type I LastRead 0 FirstWrite -1}
		din_data_2 {Type I LastRead 0 FirstWrite -1}
		din_data_3 {Type I LastRead 0 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea {Type IO LastRead 2 FirstWrite 4}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 {Type IO LastRead 2 FirstWrite 4}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1029", "Max" : "1029"}
	, {"Name" : "Interval", "Min" : "1029", "Max" : "1029"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	zext_ln76 { ap_none {  { zext_ln76 in_data 0 11 } } }
	din_data_0 { axis {  { din_data_0_TVALID in_vld 0 1 }  { din_data_0_TDATA in_data 0 32 }  { din_data_0_TREADY in_acc 1 1 } } }
	din_data_1 { axis {  { din_data_1_TVALID in_vld 0 1 }  { din_data_1_TDATA in_data 0 32 }  { din_data_1_TREADY in_acc 1 1 } } }
	din_data_2 { axis {  { din_data_2_TVALID in_vld 0 1 }  { din_data_2_TDATA in_data 0 32 }  { din_data_2_TREADY in_acc 1 1 } } }
	din_data_3 { axis {  { din_data_3_TVALID in_vld 0 1 }  { din_data_3_TDATA in_data 0 32 }  { din_data_3_TREADY in_acc 1 1 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1 MemPortDIN2 1 64 } } }
	correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 { ap_memory {  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address0 mem_address 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce0 mem_ce 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q0 in_data 0 64 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1 MemPortADDR2 1 11 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1 MemPortCE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1 MemPortWE2 1 1 }  { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1 MemPortDIN2 1 64 } } }
}
