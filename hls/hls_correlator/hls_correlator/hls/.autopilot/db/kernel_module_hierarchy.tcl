set ModuleHierarchy {[{
"Name" : "correlator","ID" : "0","Type" : "sequential",
"SubInsts" : [
	{"Name" : "grp_correlator_Pipeline_VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3_fu_147","ID" : "1","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_52_1_VITIS_LOOP_53_2_VITIS_LOOP_54_3","ID" : "2","Type" : "pipeline"},]},
	{"Name" : "grp_correlator_Pipeline_Process_Frame_Loop_fu_191","ID" : "3","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "Process_Frame_Loop","ID" : "4","Type" : "pipeline"},]},
	{"Name" : "grp_correlator_Pipeline_Offload_Loop_fu_236","ID" : "5","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "Offload_Loop","ID" : "6","Type" : "pipeline"},]},]
}]}