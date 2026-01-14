# This script segment is generated automatically by AutoPilot

set name correlator_mul_16s_16s_16_1_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {mul} IMPL {auto} LATENCY 0 ALLOW_PRAGMA 1
}


set id 37
set name correlator_ama_submuladd_1ns_16s_16s_16ns_16_4_1
set corename simcore_ama
set op ama
set stage_num 4
set clk_width 1
set clk_signed 0
set reset_width 1
set reset_signed 0
set in0_width 1
set in0_signed 0
set in1_width 16
set in1_signed 1
set in2_width 16
set in2_signed 1
set in3_width 16
set in3_signed 0
set ce_width 1
set ce_signed 0
set out_width 16
set arg_lists {i0 {1 0 +} i1 {16 1 -} s {16 1 +} i2 {16 1 +} m {16 1 +} i3 {16 0 +} p {16 1 +} c_expval {c} c_reg {1} rnd {0} acc {0} }
set TrueReset 0
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3 ALLOW_PRAGMA 1
}


set op ama
set corename DSP48
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_dsp48] == "::AESL_LIB_VIRTEX::xil_gen_dsp48"} {
eval "::AESL_LIB_VIRTEX::xil_gen_dsp48 { \
    id ${id} \
    name ${name} \
    corename ${corename} \
    op ${op} \
    reset_level 1 \
    sync_rst true \
    true_reset ${TrueReset} \
    stage_num ${stage_num} \
    clk_width ${clk_width} \
    clk_signed ${clk_signed} \
    reset_width ${reset_width} \
    reset_signed ${reset_signed} \
    in0_width ${in0_width} \
    in0_signed ${in0_signed} \
    in1_width ${in1_width} \
    in1_signed ${in1_signed} \
    in2_width ${in2_width} \
    in2_signed ${in2_signed} \
    in3_width ${in3_width} \
    in3_signed ${in3_signed} \
    ce_width ${ce_width} \
    ce_signed ${ce_signed} \
    out_width ${out_width} \
    arg_lists {${arg_lists}} \
}"
} else {
puts "@W \[IMPL-101\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_dsp48, check your platform lib"
}
}


set id 38
set name correlator_mac_muladd_16s_16s_16ns_16_4_1
set corename simcore_mac
set op mac
set stage_num 4
set clk_width 1
set clk_signed 0
set reset_width 1
set reset_signed 0
set in0_width 16
set in0_signed 1
set in1_width 16
set in1_signed 1
set in2_width 16
set in2_signed 0
set ce_width 1
set ce_signed 0
set out_width 16
set arg_lists {i0 {16 1 +} i1 {16 1 +} m {16 1 +} i2 {16 0 +} p {16 1 +} c_reg {1} rnd {0} acc {0} }
set TrueReset 0
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3 ALLOW_PRAGMA 1
}


set op mac
set corename DSP48
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_dsp48] == "::AESL_LIB_VIRTEX::xil_gen_dsp48"} {
eval "::AESL_LIB_VIRTEX::xil_gen_dsp48 { \
    id ${id} \
    name ${name} \
    corename ${corename} \
    op ${op} \
    reset_level 1 \
    sync_rst true \
    true_reset ${TrueReset} \
    stage_num ${stage_num} \
    clk_width ${clk_width} \
    clk_signed ${clk_signed} \
    reset_width ${reset_width} \
    reset_signed ${reset_signed} \
    in0_width ${in0_width} \
    in0_signed ${in0_signed} \
    in1_width ${in1_width} \
    in1_signed ${in1_signed} \
    in2_width ${in2_width} \
    in2_signed ${in2_signed} \
    ce_width ${ce_width} \
    ce_signed ${ce_signed} \
    out_width ${out_width} \
    arg_lists {${arg_lists}} \
}"
} else {
puts "@W \[IMPL-101\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_dsp48, check your platform lib"
}
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 57 \
    name din_data_0 \
    reset_level 1 \
    sync_rst true \
    corename {} \
    metadata {  } \
    op interface \
    ports { din_data_0_TVALID { I 1 bit } din_data_0_TDATA { I 32 vector } din_data_0_TREADY { O 1 bit } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'din_data_0'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 58 \
    name din_data_1 \
    reset_level 1 \
    sync_rst true \
    corename {} \
    metadata {  } \
    op interface \
    ports { din_data_1_TVALID { I 1 bit } din_data_1_TDATA { I 32 vector } din_data_1_TREADY { O 1 bit } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'din_data_1'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 59 \
    name din_data_2 \
    reset_level 1 \
    sync_rst true \
    corename {} \
    metadata {  } \
    op interface \
    ports { din_data_2_TVALID { I 1 bit } din_data_2_TDATA { I 32 vector } din_data_2_TREADY { O 1 bit } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'din_data_2'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 60 \
    name din_data_3 \
    reset_level 1 \
    sync_rst true \
    corename {} \
    metadata {  } \
    op interface \
    ports { din_data_3_TVALID { I 1 bit } din_data_3_TDATA { I 32 vector } din_data_3_TREADY { O 1 bit } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'din_data_3'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 61 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_19'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 62 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_18'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 63 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_7'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 64 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_6'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 65 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_5'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 66 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_13'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 67 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_4'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 68 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_12'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 69 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_3'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 70 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_11'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 71 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_2'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 72 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_10'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 73 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_1'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 74 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_9'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 75 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea'"
}
}


# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 76 \
    name correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 \
    reset_level 1 \
    sync_rst true \
    dir IO \
    corename correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8 \
    op interface \
    ports { correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address0 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce0 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_q0 { I 64 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_address1 { O 11 vector } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_ce1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_we1 { O 1 bit } correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8_d1 { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'correlator_stream_stream_stream_stream_stream_stream_stream_stream_strea_8'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 56 \
    name zext_ln76 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_zext_ln76 \
    op interface \
    ports { zext_ln76 { I 11 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


# flow_control definition:
set InstName correlator_flow_control_loop_pipe_sequential_init_U
set CompName correlator_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix correlator_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


