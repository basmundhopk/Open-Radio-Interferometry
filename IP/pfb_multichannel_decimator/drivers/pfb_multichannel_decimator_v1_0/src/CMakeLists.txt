# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
# Tool Version Limit: 2023.10
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
cmake_minimum_required(VERSION 3.15)
project(pfb_multichannel_decimator)
find_package(common)
collector_create (PROJECT_LIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}")
collect (PROJECT_LIB_SOURCES xpfb_multichannel_decimator.c)
collect (PROJECT_LIB_SOURCES xpfb_multichannel_decimator_sinit.c)
collect (PROJECT_LIB_SOURCES xpfb_multichannel_decimator_linux.c)
collect (PROJECT_LIB_SOURCES xpfb_multichannel_decimator_g.c)
collector_list (_sources PROJECT_LIB_SOURCES)
collector_create (PROJECT_LIB_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}")
collect (PROJECT_LIB_HEADERS xpfb_multichannel_decimator.h)
collect (PROJECT_LIB_HEADERS xpfb_multichannel_decimator_hw.h)
collector_list (_headers PROJECT_LIB_HEADERS)
file(COPY ${_headers} DESTINATION ${CMAKE_BINARY_DIR}/include)
include_directories(${CMAKE_BINARY_DIR}/include)
add_library(pfb_multichannel_decimator STATIC ${_sources})
set_target_properties(pfb_multichannel_decimator PROPERTIES LINKER_LANGUAGE C)

