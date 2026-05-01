// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XPFB_MULTICHANNEL_DECIMATOR_H
#define XPFB_MULTICHANNEL_DECIMATOR_H

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
#include "xpfb_multichannel_decimator_hw.h"

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
    u64 Control_r_BaseAddress;
    u64 Control_BaseAddress;
} XPfb_multichannel_decimator_Config;
#endif

typedef struct {
    u64 Control_r_BaseAddress;
    u64 Control_BaseAddress;
    u32 IsReady;
} XPfb_multichannel_decimator;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XPfb_multichannel_decimator_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XPfb_multichannel_decimator_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XPfb_multichannel_decimator_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XPfb_multichannel_decimator_ReadReg(BaseAddress, RegOffset) \
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
int XPfb_multichannel_decimator_Initialize(XPfb_multichannel_decimator *InstancePtr, UINTPTR BaseAddress);
XPfb_multichannel_decimator_Config* XPfb_multichannel_decimator_LookupConfig(UINTPTR BaseAddress);
#else
int XPfb_multichannel_decimator_Initialize(XPfb_multichannel_decimator *InstancePtr, u16 DeviceId);
XPfb_multichannel_decimator_Config* XPfb_multichannel_decimator_LookupConfig(u16 DeviceId);
#endif
int XPfb_multichannel_decimator_CfgInitialize(XPfb_multichannel_decimator *InstancePtr, XPfb_multichannel_decimator_Config *ConfigPtr);
#else
int XPfb_multichannel_decimator_Initialize(XPfb_multichannel_decimator *InstancePtr, const char* InstanceName);
int XPfb_multichannel_decimator_Release(XPfb_multichannel_decimator *InstancePtr);
#endif

void XPfb_multichannel_decimator_Start(XPfb_multichannel_decimator *InstancePtr);
u32 XPfb_multichannel_decimator_IsDone(XPfb_multichannel_decimator *InstancePtr);
u32 XPfb_multichannel_decimator_IsIdle(XPfb_multichannel_decimator *InstancePtr);
u32 XPfb_multichannel_decimator_IsReady(XPfb_multichannel_decimator *InstancePtr);
void XPfb_multichannel_decimator_EnableAutoRestart(XPfb_multichannel_decimator *InstancePtr);
void XPfb_multichannel_decimator_DisableAutoRestart(XPfb_multichannel_decimator *InstancePtr);

void XPfb_multichannel_decimator_Set_coeff(XPfb_multichannel_decimator *InstancePtr, u64 Data);
u64 XPfb_multichannel_decimator_Get_coeff(XPfb_multichannel_decimator *InstancePtr);

void XPfb_multichannel_decimator_InterruptGlobalEnable(XPfb_multichannel_decimator *InstancePtr);
void XPfb_multichannel_decimator_InterruptGlobalDisable(XPfb_multichannel_decimator *InstancePtr);
void XPfb_multichannel_decimator_InterruptEnable(XPfb_multichannel_decimator *InstancePtr, u32 Mask);
void XPfb_multichannel_decimator_InterruptDisable(XPfb_multichannel_decimator *InstancePtr, u32 Mask);
void XPfb_multichannel_decimator_InterruptClear(XPfb_multichannel_decimator *InstancePtr, u32 Mask);
u32 XPfb_multichannel_decimator_InterruptGetEnabled(XPfb_multichannel_decimator *InstancePtr);
u32 XPfb_multichannel_decimator_InterruptGetStatus(XPfb_multichannel_decimator *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
