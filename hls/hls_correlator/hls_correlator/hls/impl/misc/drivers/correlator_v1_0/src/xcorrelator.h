// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XCORRELATOR_H
#define XCORRELATOR_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xcorrelator_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XCorrelator_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XCorrelator;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XCorrelator_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XCorrelator_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XCorrelator_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XCorrelator_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XCorrelator_Initialize(XCorrelator *InstancePtr, UINTPTR BaseAddress);
XCorrelator_Config* XCorrelator_LookupConfig(UINTPTR BaseAddress);
#else
int XCorrelator_Initialize(XCorrelator *InstancePtr, u16 DeviceId);
XCorrelator_Config* XCorrelator_LookupConfig(u16 DeviceId);
#endif
int XCorrelator_CfgInitialize(XCorrelator *InstancePtr, XCorrelator_Config *ConfigPtr);
#else
int XCorrelator_Initialize(XCorrelator *InstancePtr, const char* InstanceName);
int XCorrelator_Release(XCorrelator *InstancePtr);
#endif

void XCorrelator_Start(XCorrelator *InstancePtr);
u32 XCorrelator_IsDone(XCorrelator *InstancePtr);
u32 XCorrelator_IsIdle(XCorrelator *InstancePtr);
u32 XCorrelator_IsReady(XCorrelator *InstancePtr);
void XCorrelator_EnableAutoRestart(XCorrelator *InstancePtr);
void XCorrelator_DisableAutoRestart(XCorrelator *InstancePtr);

void XCorrelator_Set_integration_time_frames(XCorrelator *InstancePtr, u32 Data);
u32 XCorrelator_Get_integration_time_frames(XCorrelator *InstancePtr);

void XCorrelator_InterruptGlobalEnable(XCorrelator *InstancePtr);
void XCorrelator_InterruptGlobalDisable(XCorrelator *InstancePtr);
void XCorrelator_InterruptEnable(XCorrelator *InstancePtr, u32 Mask);
void XCorrelator_InterruptDisable(XCorrelator *InstancePtr, u32 Mask);
void XCorrelator_InterruptClear(XCorrelator *InstancePtr, u32 Mask);
u32 XCorrelator_InterruptGetEnabled(XCorrelator *InstancePtr);
u32 XCorrelator_InterruptGetStatus(XCorrelator *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
