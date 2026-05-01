// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xpfb_multichannel_decimator.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XPfb_multichannel_decimator_CfgInitialize(XPfb_multichannel_decimator *InstancePtr, XPfb_multichannel_decimator_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_r_BaseAddress = ConfigPtr->Control_r_BaseAddress;
    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XPfb_multichannel_decimator_Start(XPfb_multichannel_decimator *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL) & 0x80;
    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XPfb_multichannel_decimator_IsDone(XPfb_multichannel_decimator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XPfb_multichannel_decimator_IsIdle(XPfb_multichannel_decimator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XPfb_multichannel_decimator_IsReady(XPfb_multichannel_decimator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XPfb_multichannel_decimator_EnableAutoRestart(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XPfb_multichannel_decimator_DisableAutoRestart(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_AP_CTRL, 0);
}

void XPfb_multichannel_decimator_Set_coeff(XPfb_multichannel_decimator *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_r_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_R_ADDR_COEFF_DATA, (u32)(Data));
    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_r_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_R_ADDR_COEFF_DATA + 4, (u32)(Data >> 32));
}

u64 XPfb_multichannel_decimator_Get_coeff(XPfb_multichannel_decimator *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_r_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_R_ADDR_COEFF_DATA);
    Data += (u64)XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_r_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_R_ADDR_COEFF_DATA + 4) << 32;
    return Data;
}

void XPfb_multichannel_decimator_InterruptGlobalEnable(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_GIE, 1);
}

void XPfb_multichannel_decimator_InterruptGlobalDisable(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_GIE, 0);
}

void XPfb_multichannel_decimator_InterruptEnable(XPfb_multichannel_decimator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_IER);
    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_IER, Register | Mask);
}

void XPfb_multichannel_decimator_InterruptDisable(XPfb_multichannel_decimator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_IER);
    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_IER, Register & (~Mask));
}

void XPfb_multichannel_decimator_InterruptClear(XPfb_multichannel_decimator *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPfb_multichannel_decimator_WriteReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_ISR, Mask);
}

u32 XPfb_multichannel_decimator_InterruptGetEnabled(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_IER);
}

u32 XPfb_multichannel_decimator_InterruptGetStatus(XPfb_multichannel_decimator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPfb_multichannel_decimator_ReadReg(InstancePtr->Control_BaseAddress, XPFB_MULTICHANNEL_DECIMATOR_CONTROL_ADDR_ISR);
}

