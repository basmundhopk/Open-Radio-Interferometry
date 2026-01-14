; ModuleID = '/home/brett/Documents/FX_Correlator/pfb/hls_correlator/hls_correlator/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<ap_uint<32>, 0>" = type { %"struct.ap_uint<32>" }
%"struct.ap_uint<32>" = type { %"struct.ap_int_base<32, false>" }
%"struct.ap_int_base<32, false>" = type { %"struct.ssdm_int<32, false>" }
%"struct.ssdm_int<32, false>" = type { i32 }
%"class.hls::stream<ap_uint<128>, 0>" = type { %"struct.ap_uint<128>" }
%"struct.ap_uint<128>" = type { %"struct.ap_int_base<128, false>" }
%"struct.ap_int_base<128, false>" = type { %"struct.ssdm_int<128, false>" }
%"struct.ssdm_int<128, false>" = type { i128 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: noinline willreturn
define void @apatb_correlator_ir(%"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture nonnull dereferenceable(4) %din_data_0, %"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture nonnull dereferenceable(4) %din_data_1, %"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture nonnull dereferenceable(4) %din_data_2, %"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture nonnull dereferenceable(4) %din_data_3, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_00, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_11, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_22, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_33, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_01, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_02, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_03, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_12, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_13, %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture nonnull dereferenceable(16) %dout_data_23, i32 %integration_time_frames) local_unnamed_addr #1 {
entry:
  %din_data_0_copy = alloca i32, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i32* %din_data_0_copy, i32 0) ]
  %din_data_1_copy = alloca i32, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i32* %din_data_1_copy, i32 0) ]
  %din_data_2_copy = alloca i32, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i32* %din_data_2_copy, i32 0) ]
  %din_data_3_copy = alloca i32, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i32* %din_data_3_copy, i32 0) ]
  %dout_data_00_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_00_copy, i32 0) ]
  %dout_data_11_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_11_copy, i32 0) ]
  %dout_data_22_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_22_copy, i32 0) ]
  %dout_data_33_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_33_copy, i32 0) ]
  %dout_data_01_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_01_copy, i32 0) ]
  %dout_data_02_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_02_copy, i32 0) ]
  %dout_data_03_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_03_copy, i32 0) ]
  %dout_data_12_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_12_copy, i32 0) ]
  %dout_data_13_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_13_copy, i32 0) ]
  %dout_data_23_copy = alloca i128, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i128* %dout_data_23_copy, i32 0) ]
  call fastcc void @copy_in(%"class.hls::stream<ap_uint<32>, 0>"* nonnull %din_data_0, i32* nonnull align 512 %din_data_0_copy, %"class.hls::stream<ap_uint<32>, 0>"* nonnull %din_data_1, i32* nonnull align 512 %din_data_1_copy, %"class.hls::stream<ap_uint<32>, 0>"* nonnull %din_data_2, i32* nonnull align 512 %din_data_2_copy, %"class.hls::stream<ap_uint<32>, 0>"* nonnull %din_data_3, i32* nonnull align 512 %din_data_3_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_00, i128* nonnull align 512 %dout_data_00_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_11, i128* nonnull align 512 %dout_data_11_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_22, i128* nonnull align 512 %dout_data_22_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_33, i128* nonnull align 512 %dout_data_33_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_01, i128* nonnull align 512 %dout_data_01_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_02, i128* nonnull align 512 %dout_data_02_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_03, i128* nonnull align 512 %dout_data_03_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_12, i128* nonnull align 512 %dout_data_12_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_13, i128* nonnull align 512 %dout_data_13_copy, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %dout_data_23, i128* nonnull align 512 %dout_data_23_copy)
  call void @apatb_correlator_hw(i32* %din_data_0_copy, i32* %din_data_1_copy, i32* %din_data_2_copy, i32* %din_data_3_copy, i128* %dout_data_00_copy, i128* %dout_data_11_copy, i128* %dout_data_22_copy, i128* %dout_data_33_copy, i128* %dout_data_01_copy, i128* %dout_data_02_copy, i128* %dout_data_03_copy, i128* %dout_data_12_copy, i128* %dout_data_13_copy, i128* %dout_data_23_copy, i32 %integration_time_frames)
  call void @copy_back(%"class.hls::stream<ap_uint<32>, 0>"* %din_data_0, i32* %din_data_0_copy, %"class.hls::stream<ap_uint<32>, 0>"* %din_data_1, i32* %din_data_1_copy, %"class.hls::stream<ap_uint<32>, 0>"* %din_data_2, i32* %din_data_2_copy, %"class.hls::stream<ap_uint<32>, 0>"* %din_data_3, i32* %din_data_3_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_00, i128* %dout_data_00_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_11, i128* %dout_data_11_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_22, i128* %dout_data_22_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_33, i128* %dout_data_33_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_01, i128* %dout_data_01_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_02, i128* %dout_data_02_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_03, i128* %dout_data_03_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_12, i128* %dout_data_12_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_13, i128* %dout_data_13_copy, %"class.hls::stream<ap_uint<128>, 0>"* %dout_data_23, i128* %dout_data_23_copy)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_in(%"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="0", i32* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="2", i32* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="4", i32* noalias nocapture align 512 "unpacked"="5.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="8", i128* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="10", i128* noalias nocapture align 512 "unpacked"="11.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="12", i128* noalias nocapture align 512 "unpacked"="13.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="14", i128* noalias nocapture align 512 "unpacked"="15.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="16", i128* noalias nocapture align 512 "unpacked"="17.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="18", i128* noalias nocapture align 512 "unpacked"="19.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="20", i128* noalias nocapture align 512 "unpacked"="21.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="22", i128* noalias nocapture align 512 "unpacked"="23.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="24", i128* noalias nocapture align 512 "unpacked"="25.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="26", i128* noalias nocapture align 512 "unpacked"="27.0") unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>.186"(i32* align 512 %1, %"class.hls::stream<ap_uint<32>, 0>"* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>.186"(i32* align 512 %3, %"class.hls::stream<ap_uint<32>, 0>"* %2)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>.186"(i32* align 512 %5, %"class.hls::stream<ap_uint<32>, 0>"* %4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>.186"(i32* align 512 %7, %"class.hls::stream<ap_uint<32>, 0>"* %6)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %9, %"class.hls::stream<ap_uint<128>, 0>"* %8)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %11, %"class.hls::stream<ap_uint<128>, 0>"* %10)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %13, %"class.hls::stream<ap_uint<128>, 0>"* %12)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %15, %"class.hls::stream<ap_uint<128>, 0>"* %14)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %17, %"class.hls::stream<ap_uint<128>, 0>"* %16)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %19, %"class.hls::stream<ap_uint<128>, 0>"* %18)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %21, %"class.hls::stream<ap_uint<128>, 0>"* %20)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %23, %"class.hls::stream<ap_uint<128>, 0>"* %22)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %25, %"class.hls::stream<ap_uint<128>, 0>"* %24)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* align 512 %27, %"class.hls::stream<ap_uint<128>, 0>"* %26)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_out(%"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="0", i32* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="2", i32* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="4", i32* noalias nocapture align 512 "unpacked"="5.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="8", i128* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="10", i128* noalias nocapture align 512 "unpacked"="11.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="12", i128* noalias nocapture align 512 "unpacked"="13.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="14", i128* noalias nocapture align 512 "unpacked"="15.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="16", i128* noalias nocapture align 512 "unpacked"="17.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="18", i128* noalias nocapture align 512 "unpacked"="19.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="20", i128* noalias nocapture align 512 "unpacked"="21.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="22", i128* noalias nocapture align 512 "unpacked"="23.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="24", i128* noalias nocapture align 512 "unpacked"="25.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="26", i128* noalias nocapture align 512 "unpacked"="27.0") unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %0, i32* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %2, i32* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %4, i32* align 512 %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %6, i32* align 512 %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %8, i128* align 512 %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %10, i128* align 512 %11)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %12, i128* align 512 %13)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %14, i128* align 512 %15)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %16, i128* align 512 %17)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %18, i128* align 512 %19)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %20, i128* align 512 %21)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %22, i128* align 512 %23)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %24, i128* align 512 %25)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %26, i128* align 512 %27)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="0" %dst, i128* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<128>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<128>, 0>.138"(%"class.hls::stream<ap_uint<128>, 0>"* nonnull %dst, i128* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<128>, 0>.138"(%"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture "unpacked"="0", i128* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #5 {
entry:
  %2 = alloca i128
  %3 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i128* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_16(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i128* %2 to i8*
  %7 = bitcast i128* %1 to i8*
  call void @fpga_fifo_pop_16(i8* %6, i8* %7)
  %8 = load volatile i128, i128* %2
  %.ivi = insertvalue %"class.hls::stream<ap_uint<128>, 0>" undef, i128 %8, 0, 0, 0, 0
  store %"class.hls::stream<ap_uint<128>, 0>" %.ivi, %"class.hls::stream<ap_uint<128>, 0>"* %3
  %9 = bitcast %"class.hls::stream<ap_uint<128>, 0>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<ap_uint<128>, 0>"* %0 to i8*
  call void @fpga_fifo_push_16(i8* %9, i8* %10)
  br label %empty, !llvm.loop !5

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>.143"(i128* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<128>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<128>, 0>.146"(i128* align 512 %dst, %"class.hls::stream<ap_uint<128>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<128>, 0>.146"(i128* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #5 {
entry:
  %2 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %3 = alloca i128
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_uint<128>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_16(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_uint<128>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_uint<128>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_16(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_uint<128>, 0>", %"class.hls::stream<ap_uint<128>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_uint<128>, 0>" %8, 0, 0, 0, 0
  store i128 %.evi, i128* %3
  %9 = bitcast i128* %3 to i8*
  %10 = bitcast i128* %0 to i8*
  call void @fpga_fifo_push_16(i8* %9, i8* %10)
  br label %empty, !llvm.loop !7

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="0" %dst, i32* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<32>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<32>, 0>.181"(%"class.hls::stream<ap_uint<32>, 0>"* nonnull %dst, i32* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<32>, 0>.181"(%"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture "unpacked"="0", i32* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #5 {
entry:
  %2 = alloca i32
  %3 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i32* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i32* %2 to i8*
  %7 = bitcast i32* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile i32, i32* %2
  %.ivi = insertvalue %"class.hls::stream<ap_uint<32>, 0>" undef, i32 %8, 0, 0, 0, 0
  store %"class.hls::stream<ap_uint<32>, 0>" %.ivi, %"class.hls::stream<ap_uint<32>, 0>"* %3
  %9 = bitcast %"class.hls::stream<ap_uint<32>, 0>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<ap_uint<32>, 0>"* %0 to i8*
  call void @fpga_fifo_push_4(i8* %9, i8* %10)
  br label %empty, !llvm.loop !8

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>.186"(i32* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<32>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<32>, 0>.189"(i32* align 512 %dst, %"class.hls::stream<ap_uint<32>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<32>, 0>.189"(i32* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #5 {
entry:
  %2 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  %3 = alloca i32
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_uint<32>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_uint<32>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_uint<32>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_uint<32>, 0>", %"class.hls::stream<ap_uint<32>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_uint<32>, 0>" %8, 0, 0, 0, 0
  store i32 %.evi, i32* %3
  %9 = bitcast i32* %3 to i8*
  %10 = bitcast i32* %0 to i8*
  call void @fpga_fifo_push_4(i8* %9, i8* %10)
  br label %empty, !llvm.loop !9

ret:                                              ; preds = %empty
  ret void
}

declare void @apatb_correlator_hw(i32*, i32*, i32*, i32*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i32)

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_back(%"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="0", i32* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="2", i32* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="4", i32* noalias nocapture align 512 "unpacked"="5.0", %"class.hls::stream<ap_uint<32>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="8", i128* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="10", i128* noalias nocapture align 512 "unpacked"="11.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="12", i128* noalias nocapture align 512 "unpacked"="13.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="14", i128* noalias nocapture align 512 "unpacked"="15.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="16", i128* noalias nocapture align 512 "unpacked"="17.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="18", i128* noalias nocapture align 512 "unpacked"="19.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="20", i128* noalias nocapture align 512 "unpacked"="21.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="22", i128* noalias nocapture align 512 "unpacked"="23.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="24", i128* noalias nocapture align 512 "unpacked"="25.0", %"class.hls::stream<ap_uint<128>, 0>"* noalias "unpacked"="26", i128* noalias nocapture align 512 "unpacked"="27.0") unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %0, i32* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %2, i32* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %4, i32* align 512 %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<32>, 0>"(%"class.hls::stream<ap_uint<32>, 0>"* %6, i32* align 512 %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %8, i128* align 512 %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %10, i128* align 512 %11)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %12, i128* align 512 %13)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %14, i128* align 512 %15)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %16, i128* align 512 %17)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %18, i128* align 512 %19)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %20, i128* align 512 %21)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %22, i128* align 512 %23)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %24, i128* align 512 %25)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<128>, 0>"(%"class.hls::stream<ap_uint<128>, 0>"* %26, i128* align 512 %27)
  ret void
}

define void @correlator_hw_stub_wrapper(i32*, i32*, i32*, i32*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i128*, i32) #6 {
entry:
  %15 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  %16 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  %17 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  %18 = alloca %"class.hls::stream<ap_uint<32>, 0>"
  %19 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %20 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %21 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %22 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %23 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %24 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %25 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %26 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %27 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  %28 = alloca %"class.hls::stream<ap_uint<128>, 0>"
  call void @copy_out(%"class.hls::stream<ap_uint<32>, 0>"* %15, i32* %0, %"class.hls::stream<ap_uint<32>, 0>"* %16, i32* %1, %"class.hls::stream<ap_uint<32>, 0>"* %17, i32* %2, %"class.hls::stream<ap_uint<32>, 0>"* %18, i32* %3, %"class.hls::stream<ap_uint<128>, 0>"* %19, i128* %4, %"class.hls::stream<ap_uint<128>, 0>"* %20, i128* %5, %"class.hls::stream<ap_uint<128>, 0>"* %21, i128* %6, %"class.hls::stream<ap_uint<128>, 0>"* %22, i128* %7, %"class.hls::stream<ap_uint<128>, 0>"* %23, i128* %8, %"class.hls::stream<ap_uint<128>, 0>"* %24, i128* %9, %"class.hls::stream<ap_uint<128>, 0>"* %25, i128* %10, %"class.hls::stream<ap_uint<128>, 0>"* %26, i128* %11, %"class.hls::stream<ap_uint<128>, 0>"* %27, i128* %12, %"class.hls::stream<ap_uint<128>, 0>"* %28, i128* %13)
  call void @correlator_hw_stub(%"class.hls::stream<ap_uint<32>, 0>"* %15, %"class.hls::stream<ap_uint<32>, 0>"* %16, %"class.hls::stream<ap_uint<32>, 0>"* %17, %"class.hls::stream<ap_uint<32>, 0>"* %18, %"class.hls::stream<ap_uint<128>, 0>"* %19, %"class.hls::stream<ap_uint<128>, 0>"* %20, %"class.hls::stream<ap_uint<128>, 0>"* %21, %"class.hls::stream<ap_uint<128>, 0>"* %22, %"class.hls::stream<ap_uint<128>, 0>"* %23, %"class.hls::stream<ap_uint<128>, 0>"* %24, %"class.hls::stream<ap_uint<128>, 0>"* %25, %"class.hls::stream<ap_uint<128>, 0>"* %26, %"class.hls::stream<ap_uint<128>, 0>"* %27, %"class.hls::stream<ap_uint<128>, 0>"* %28, i32 %14)
  call void @copy_in(%"class.hls::stream<ap_uint<32>, 0>"* %15, i32* %0, %"class.hls::stream<ap_uint<32>, 0>"* %16, i32* %1, %"class.hls::stream<ap_uint<32>, 0>"* %17, i32* %2, %"class.hls::stream<ap_uint<32>, 0>"* %18, i32* %3, %"class.hls::stream<ap_uint<128>, 0>"* %19, i128* %4, %"class.hls::stream<ap_uint<128>, 0>"* %20, i128* %5, %"class.hls::stream<ap_uint<128>, 0>"* %21, i128* %6, %"class.hls::stream<ap_uint<128>, 0>"* %22, i128* %7, %"class.hls::stream<ap_uint<128>, 0>"* %23, i128* %8, %"class.hls::stream<ap_uint<128>, 0>"* %24, i128* %9, %"class.hls::stream<ap_uint<128>, 0>"* %25, i128* %10, %"class.hls::stream<ap_uint<128>, 0>"* %26, i128* %11, %"class.hls::stream<ap_uint<128>, 0>"* %27, i128* %12, %"class.hls::stream<ap_uint<128>, 0>"* %28, i128* %13)
  ret void
}

declare void @correlator_hw_stub(%"class.hls::stream<ap_uint<32>, 0>"*, %"class.hls::stream<ap_uint<32>, 0>"*, %"class.hls::stream<ap_uint<32>, 0>"*, %"class.hls::stream<ap_uint<32>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, %"class.hls::stream<ap_uint<128>, 0>"*, i32)

declare i1 @fpga_fifo_not_empty_4(i8*)

declare i1 @fpga_fifo_not_empty_16(i8*)

declare void @fpga_fifo_pop_4(i8*, i8*)

declare void @fpga_fifo_pop_16(i8*, i8*)

declare void @fpga_fifo_push_4(i8*, i8*)

declare void @fpga_fifo_push_16(i8*, i8*)

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #3 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #5 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #6 = { "fpga.wrapper.func"="stub" }
attributes #7 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="32" "xlx.source"="user" }
attributes #8 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="128" "xlx.source"="user" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.rotate.disable"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}
