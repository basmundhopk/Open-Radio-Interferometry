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
#include "xpfb_multichannel.h"

extern XPfb_multichannel_Config XPfb_multichannel_ConfigTable[];

#ifdef SDT
XPfb_multichannel_Config *XPfb_multichannel_LookupConfig(UINTPTR BaseAddress) {
	XPfb_multichannel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XPfb_multichannel_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XPfb_multichannel_ConfigTable[Index].Control_r_BaseAddress == BaseAddress) {
			ConfigPtr = &XPfb_multichannel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPfb_multichannel_Initialize(XPfb_multichannel *InstancePtr, UINTPTR BaseAddress) {
	XPfb_multichannel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPfb_multichannel_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPfb_multichannel_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XPfb_multichannel_Config *XPfb_multichannel_LookupConfig(u16 DeviceId) {
	XPfb_multichannel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XPFB_MULTICHANNEL_NUM_INSTANCES; Index++) {
		if (XPfb_multichannel_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XPfb_multichannel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPfb_multichannel_Initialize(XPfb_multichannel *InstancePtr, u16 DeviceId) {
	XPfb_multichannel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPfb_multichannel_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPfb_multichannel_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

