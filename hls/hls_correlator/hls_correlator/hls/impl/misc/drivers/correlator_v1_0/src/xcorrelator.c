// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xcorrelator.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XCorrelator_CfgInitialize(XCorrelator *InstancePtr, XCorrelator_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XCorrelator_Start(XCorrelator *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL) & 0x80;
    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XCorrelator_IsDone(XCorrelator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XCorrelator_IsIdle(XCorrelator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XCorrelator_IsReady(XCorrelator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XCorrelator_EnableAutoRestart(XCorrelator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XCorrelator_DisableAutoRestart(XCorrelator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_AP_CTRL, 0);
}

void XCorrelator_Set_integration_time_frames(XCorrelator *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_INTEGRATION_TIME_FRAMES_DATA, Data);
}

u32 XCorrelator_Get_integration_time_frames(XCorrelator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_INTEGRATION_TIME_FRAMES_DATA);
    return Data;
}

void XCorrelator_InterruptGlobalEnable(XCorrelator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_GIE, 1);
}

void XCorrelator_InterruptGlobalDisable(XCorrelator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_GIE, 0);
}

void XCorrelator_InterruptEnable(XCorrelator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_IER);
    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_IER, Register | Mask);
}

void XCorrelator_InterruptDisable(XCorrelator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_IER);
    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_IER, Register & (~Mask));
}

void XCorrelator_InterruptClear(XCorrelator *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCorrelator_WriteReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_ISR, Mask);
}

u32 XCorrelator_InterruptGetEnabled(XCorrelator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_IER);
}

u32 XCorrelator_InterruptGetStatus(XCorrelator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCorrelator_ReadReg(InstancePtr->Control_BaseAddress, XCORRELATOR_CONTROL_ADDR_ISR);
}

