set moduleName correlator
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set C_modelName {correlator}
set C_modelType { void 0 }
set C_modelArgList {
	{ din_data_0 int 32 regular {axi_s 0 volatile  { din_data_0 Data } }  }
	{ din_data_1 int 32 regular {axi_s 0 volatile  { din_data_1 Data } }  }
	{ din_data_2 int 32 regular {axi_s 0 volatile  { din_data_2 Data } }  }
	{ din_data_3 int 32 regular {axi_s 0 volatile  { din_data_3 Data } }  }
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
	{ integration_time_frames int 32 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set AXIMCacheInstList { }
set C_modelArgMapList {[ 
	{ "Name" : "din_data_0", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_1", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_2", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "din_data_3", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
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
 	{ "Name" : "integration_time_frames", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":23}} ]}
# RTL Port declarations: 
set portNum 62
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ din_data_0_TDATA sc_in sc_lv 32 signal 0 } 
	{ din_data_0_TVALID sc_in sc_logic 1 invld 0 } 
	{ din_data_0_TREADY sc_out sc_logic 1 inacc 0 } 
	{ din_data_1_TDATA sc_in sc_lv 32 signal 1 } 
	{ din_data_1_TVALID sc_in sc_logic 1 invld 1 } 
	{ din_data_1_TREADY sc_out sc_logic 1 inacc 1 } 
	{ din_data_2_TDATA sc_in sc_lv 32 signal 2 } 
	{ din_data_2_TVALID sc_in sc_logic 1 invld 2 } 
	{ din_data_2_TREADY sc_out sc_logic 1 inacc 2 } 
	{ din_data_3_TDATA sc_in sc_lv 32 signal 3 } 
	{ din_data_3_TVALID sc_in sc_logic 1 invld 3 } 
	{ din_data_3_TREADY sc_out sc_logic 1 inacc 3 } 
	{ dout_data_00_TDATA sc_out sc_lv 128 signal 4 } 
	{ dout_data_00_TVALID sc_out sc_logic 1 outvld 4 } 
	{ dout_data_00_TREADY sc_in sc_logic 1 outacc 4 } 
	{ dout_data_11_TDATA sc_out sc_lv 128 signal 5 } 
	{ dout_data_11_TVALID sc_out sc_logic 1 outvld 5 } 
	{ dout_data_11_TREADY sc_in sc_logic 1 outacc 5 } 
	{ dout_data_22_TDATA sc_out sc_lv 128 signal 6 } 
	{ dout_data_22_TVALID sc_out sc_logic 1 outvld 6 } 
	{ dout_data_22_TREADY sc_in sc_logic 1 outacc 6 } 
	{ dout_data_33_TDATA sc_out sc_lv 128 signal 7 } 
	{ dout_data_33_TVALID sc_out sc_logic 1 outvld 7 } 
	{ dout_data_33_TREADY sc_in sc_logic 1 outacc 7 } 
	{ dout_data_01_TDATA sc_out sc_lv 128 signal 8 } 
	{ dout_data_01_TVALID sc_out sc_logic 1 outvld 8 } 
	{ dout_data_01_TREADY sc_in sc_logic 1 outacc 8 } 
	{ dout_data_02_TDATA sc_out sc_lv 128 signal 9 } 
	{ dout_data_02_TVALID sc_out sc_logic 1 outvld 9 } 
	{ dout_data_02_TREADY sc_in sc_logic 1 outacc 9 } 
	{ dout_data_03_TDATA sc_out sc_lv 128 signal 10 } 
	{ dout_data_03_TVALID sc_out sc_logic 1 outvld 10 } 
	{ dout_data_03_TREADY sc_in sc_logic 1 outacc 10 } 
	{ dout_data_12_TDATA sc_out sc_lv 128 signal 11 } 
	{ dout_data_12_TVALID sc_out sc_logic 1 outvld 11 } 
	{ dout_data_12_TREADY sc_in sc_logic 1 outacc 11 } 
	{ dout_data_13_TDATA sc_out sc_lv 128 signal 12 } 
	{ dout_data_13_TVALID sc_out sc_logic 1 outvld 12 } 
	{ dout_data_13_TREADY sc_in sc_logic 1 outacc 12 } 
	{ dout_data_23_TDATA sc_out sc_lv 128 signal 13 } 
	{ dout_data_23_TVALID sc_out sc_logic 1 outvld 13 } 
	{ dout_data_23_TREADY sc_in sc_logic 1 outacc 13 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 5 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 5 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"correlator","role":"start","value":"0","valid_bit":"0"},{"name":"correlator","role":"continue","value":"0","valid_bit":"4"},{"name":"correlator","role":"auto_start","value":"0","valid_bit":"7"},{"name":"integration_time_frames","role":"data","value":"16"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"correlator","role":"start","value":"0","valid_bit":"0"},{"name":"correlator","role":"done","value":"0","valid_bit":"1"},{"name":"correlator","role":"idle","value":"0","valid_bit":"2"},{"name":"correlator","role":"ready","value":"0","valid_bit":"3"},{"name":"correlator","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "din_data_0_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_0", "role": "TDATA" }} , 
 	{ "name": "din_data_0_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_0", "role": "TVALID" }} , 
 	{ "name": "din_data_0_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_0", "role": "TREADY" }} , 
 	{ "name": "din_data_1_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_1", "role": "TDATA" }} , 
 	{ "name": "din_data_1_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_1", "role": "TVALID" }} , 
 	{ "name": "din_data_1_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_1", "role": "TREADY" }} , 
 	{ "name": "din_data_2_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_2", "role": "TDATA" }} , 
 	{ "name": "din_data_2_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_2", "role": "TVALID" }} , 
 	{ "name": "din_data_2_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_2", "role": "TREADY" }} , 
 	{ "name": "din_data_3_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "din_data_3", "role": "TDATA" }} , 
 	{ "name": "din_data_3_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "din_data_3", "role": "TVALID" }} , 
 	{ "name": "din_data_3_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "din_data_3", "role": "TREADY" }} , 
 	{ "name": "dout_data_00_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_00", "role": "TDATA" }} , 
 	{ "name": "dout_data_00_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_00", "role": "TVALID" }} , 
 	{ "name": "dout_data_00_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_00", "role": "TREADY" }} , 
 	{ "name": "dout_data_11_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_11", "role": "TDATA" }} , 
 	{ "name": "dout_data_11_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_11", "role": "TVALID" }} , 
 	{ "name": "dout_data_11_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_11", "role": "TREADY" }} , 
 	{ "name": "dout_data_22_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_22", "role": "TDATA" }} , 
 	{ "name": "dout_data_22_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_22", "role": "TVALID" }} , 
 	{ "name": "dout_data_22_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_22", "role": "TREADY" }} , 
 	{ "name": "dout_data_33_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_33", "role": "TDATA" }} , 
 	{ "name": "dout_data_33_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_33", "role": "TVALID" }} , 
 	{ "name": "dout_data_33_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_33", "role": "TREADY" }} , 
 	{ "name": "dout_data_01_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_01", "role": "TDATA" }} , 
 	{ "name": "dout_data_01_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_01", "role": "TVALID" }} , 
 	{ "name": "dout_data_01_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_01", "role": "TREADY" }} , 
 	{ "name": "dout_data_02_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_02", "role": "TDATA" }} , 
 	{ "name": "dout_data_02_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_02", "role": "TVALID" }} , 
 	{ "name": "dout_data_02_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_02", "role": "TREADY" }} , 
 	{ "name": "dout_data_03_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_03", "role": "TDATA" }} , 
 	{ "name": "dout_data_03_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_03", "role": "TVALID" }} , 
 	{ "name": "dout_data_03_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_03", "role": "TREADY" }} , 
 	{ "name": "dout_data_12_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_12", "role": "TDATA" }} , 
 	{ "name": "dout_data_12_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_12", "role": "TVALID" }} , 
 	{ "name": "dout_data_12_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_12", "role": "TREADY" }} , 
 	{ "name": "dout_data_13_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_13", "role": "TDATA" }} , 
 	{ "name": "dout_data_13_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_13", "role": "TVALID" }} , 
 	{ "name": "dout_data_13_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_13", "role": "TREADY" }} , 
 	{ "name": "dout_data_23_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "dout_data_23", "role": "TDATA" }} , 
 	{ "name": "dout_data_23_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_data_23", "role": "TVALID" }} , 
 	{ "name": "dout_data_23_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_data_23", "role": "TREADY" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "23", "57", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73"],
		"CDFG" : "correlator",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1034", "EstimateLatencyMax" : "22544",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "din_data_0", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "din_data_0", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "din_data_1", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "din_data_1", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "din_data_2", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "din_data_2", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "din_data_3", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "din_data_3", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "dout_data_00", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_00", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_11", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_11", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_22", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_22", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_33", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_33", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_01", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_01", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_02", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_02", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_03", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_03", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_12", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_12", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_13", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_13", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "dout_data_23", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "dout_data_23", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "integration_time_frames", "Type" : "None", "Direction" : "I"},
			{"Name" : "first_run", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "21", "SubInstance" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "57", "SubInstance" : "grp_correlator_Pipeline_Offload_Loop_fu_236", "Port" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Inst_start_state" : "6", "Inst_end_state" : "7"}]},
			{"Name" : "bank_sel", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "frame_count", "Type" : "OVld", "Direction" : "IO"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_U", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_U", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_U", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_U", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_U", "Parent" : "0"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_U", "Parent" : "0"},
	{"ID" : "16", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_U", "Parent" : "0"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_U", "Parent" : "0"},
	{"ID" : "18", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_U", "Parent" : "0"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_U", "Parent" : "0"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_U", "Parent" : "0"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147", "Parent" : "0", "Child" : ["22"],
		"CDFG" : "correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "20482", "EstimateLatencyMax" : "20482",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8", "Type" : "Memory", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147.flow_control_loop_pipe_sequential_init_U", "Parent" : "21"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191", "Parent" : "0", "Child" : ["24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56"],
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
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U21", "Parent" : "23"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U22", "Parent" : "23"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U23", "Parent" : "23"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U24", "Parent" : "23"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U25", "Parent" : "23"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U26", "Parent" : "23"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U27", "Parent" : "23"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U28", "Parent" : "23"},
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U29", "Parent" : "23"},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U30", "Parent" : "23"},
	{"ID" : "34", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U31", "Parent" : "23"},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U32", "Parent" : "23"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U33", "Parent" : "23"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U34", "Parent" : "23"},
	{"ID" : "38", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U35", "Parent" : "23"},
	{"ID" : "39", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mul_16s_16s_16_1_1_U36", "Parent" : "23"},
	{"ID" : "40", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.ama_submuladd_1ns_16s_16s_16ns_16_4_1_U37", "Parent" : "23"},
	{"ID" : "41", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U38", "Parent" : "23"},
	{"ID" : "42", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U39", "Parent" : "23"},
	{"ID" : "43", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U40", "Parent" : "23"},
	{"ID" : "44", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U41", "Parent" : "23"},
	{"ID" : "45", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U42", "Parent" : "23"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U43", "Parent" : "23"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U44", "Parent" : "23"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U45", "Parent" : "23"},
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U46", "Parent" : "23"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U47", "Parent" : "23"},
	{"ID" : "51", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U48", "Parent" : "23"},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U49", "Parent" : "23"},
	{"ID" : "53", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U50", "Parent" : "23"},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U51", "Parent" : "23"},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.mac_muladd_16s_16s_16ns_16_4_1_U52", "Parent" : "23"},
	{"ID" : "56", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Process_Frame_Loop_fu_191.flow_control_loop_pipe_sequential_init_U", "Parent" : "23"},
	{"ID" : "57", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Offload_Loop_fu_236", "Parent" : "0", "Child" : ["58"],
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
	{"ID" : "58", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_correlator_Pipeline_Offload_Loop_fu_236.flow_control_loop_pipe_sequential_init_U", "Parent" : "57"},
	{"ID" : "59", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.control_s_axi_U", "Parent" : "0"},
	{"ID" : "60", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_din_data_0_U", "Parent" : "0"},
	{"ID" : "61", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_din_data_1_U", "Parent" : "0"},
	{"ID" : "62", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_din_data_2_U", "Parent" : "0"},
	{"ID" : "63", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_din_data_3_U", "Parent" : "0"},
	{"ID" : "64", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_00_U", "Parent" : "0"},
	{"ID" : "65", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_11_U", "Parent" : "0"},
	{"ID" : "66", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_22_U", "Parent" : "0"},
	{"ID" : "67", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_33_U", "Parent" : "0"},
	{"ID" : "68", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_01_U", "Parent" : "0"},
	{"ID" : "69", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_02_U", "Parent" : "0"},
	{"ID" : "70", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_03_U", "Parent" : "0"},
	{"ID" : "71", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_12_U", "Parent" : "0"},
	{"ID" : "72", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_13_U", "Parent" : "0"},
	{"ID" : "73", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_dout_data_23_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	correlator {
		din_data_0 {Type I LastRead 0 FirstWrite -1}
		din_data_1 {Type I LastRead 0 FirstWrite -1}
		din_data_2 {Type I LastRead 0 FirstWrite -1}
		din_data_3 {Type I LastRead 0 FirstWrite -1}
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
		integration_time_frames {Type I LastRead 0 FirstWrite -1}
		first_run {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea {Type IO LastRead -1 FirstWrite -1}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 {Type IO LastRead -1 FirstWrite -1}
		bank_sel {Type IO LastRead -1 FirstWrite -1}
		frame_count {Type IO LastRead -1 FirstWrite -1}}
	correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3 {
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_17 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_16 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_15 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_14 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea {Type O LastRead -1 FirstWrite 2}
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 {Type O LastRead -1 FirstWrite 2}}
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
		correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 {Type IO LastRead 2 FirstWrite 4}}
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
	{"Name" : "Latency", "Min" : "1034", "Max" : "22544"}
	, {"Name" : "Interval", "Min" : "1035", "Max" : "22545"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	din_data_0 { axis {  { din_data_0_TDATA in_data 0 32 }  { din_data_0_TVALID in_vld 0 1 }  { din_data_0_TREADY in_acc 1 1 } } }
	din_data_1 { axis {  { din_data_1_TDATA in_data 0 32 }  { din_data_1_TVALID in_vld 0 1 }  { din_data_1_TREADY in_acc 1 1 } } }
	din_data_2 { axis {  { din_data_2_TDATA in_data 0 32 }  { din_data_2_TVALID in_vld 0 1 }  { din_data_2_TREADY in_acc 1 1 } } }
	din_data_3 { axis {  { din_data_3_TDATA in_data 0 32 }  { din_data_3_TVALID in_vld 0 1 }  { din_data_3_TREADY in_acc 1 1 } } }
	dout_data_00 { axis {  { dout_data_00_TDATA out_data 1 128 }  { dout_data_00_TVALID out_vld 1 1 }  { dout_data_00_TREADY out_acc 0 1 } } }
	dout_data_11 { axis {  { dout_data_11_TDATA out_data 1 128 }  { dout_data_11_TVALID out_vld 1 1 }  { dout_data_11_TREADY out_acc 0 1 } } }
	dout_data_22 { axis {  { dout_data_22_TDATA out_data 1 128 }  { dout_data_22_TVALID out_vld 1 1 }  { dout_data_22_TREADY out_acc 0 1 } } }
	dout_data_33 { axis {  { dout_data_33_TDATA out_data 1 128 }  { dout_data_33_TVALID out_vld 1 1 }  { dout_data_33_TREADY out_acc 0 1 } } }
	dout_data_01 { axis {  { dout_data_01_TDATA out_data 1 128 }  { dout_data_01_TVALID out_vld 1 1 }  { dout_data_01_TREADY out_acc 0 1 } } }
	dout_data_02 { axis {  { dout_data_02_TDATA out_data 1 128 }  { dout_data_02_TVALID out_vld 1 1 }  { dout_data_02_TREADY out_acc 0 1 } } }
	dout_data_03 { axis {  { dout_data_03_TDATA out_data 1 128 }  { dout_data_03_TVALID out_vld 1 1 }  { dout_data_03_TREADY out_acc 0 1 } } }
	dout_data_12 { axis {  { dout_data_12_TDATA out_data 1 128 }  { dout_data_12_TVALID out_vld 1 1 }  { dout_data_12_TREADY out_acc 0 1 } } }
	dout_data_13 { axis {  { dout_data_13_TDATA out_data 1 128 }  { dout_data_13_TVALID out_vld 1 1 }  { dout_data_13_TREADY out_acc 0 1 } } }
	dout_data_23 { axis {  { dout_data_23_TDATA out_data 1 128 }  { dout_data_23_TVALID out_vld 1 1 }  { dout_data_23_TREADY out_acc 0 1 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
