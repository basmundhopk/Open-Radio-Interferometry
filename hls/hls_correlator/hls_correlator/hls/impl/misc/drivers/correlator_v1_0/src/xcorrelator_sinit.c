// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xcorrelator.h"

extern XCorrelator_Config XCorrelator_ConfigTable[];

#ifdef SDT
XCorrelator_Config *XCorrelator_LookupConfig(UINTPTR BaseAddress) {
	XCorrelator_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XCorrelator_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XCorrelator_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XCorrelator_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCorrelator_Initialize(XCorrelator *InstancePtr, UINTPTR BaseAddress) {
	XCorrelator_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCorrelator_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCorrelator_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XCorrelator_Config *XCorrelator_LookupConfig(u16 DeviceId) {
	XCorrelator_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCORRELATOR_NUM_INSTANCES; Index++) {
		if (XCorrelator_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XCorrelator_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCorrelator_Initialize(XCorrelator *InstancePtr, u16 DeviceId) {
	XCorrelator_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCorrelator_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCorrelator_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

