// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XPFB_MULTICHANNEL_H
#define XPFB_MULTICHANNEL_H

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
#include "xpfb_multichannel_hw.h"

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
} XPfb_multichannel_Config;
#endif

typedef struct {
    u64 Control_r_BaseAddress;
    u64 Control_BaseAddress;
    u32 IsReady;
} XPfb_multichannel;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XPfb_multichannel_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XPfb_multichannel_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XPfb_multichannel_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XPfb_multichannel_ReadReg(BaseAddress, RegOffset) \
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
int XPfb_multichannel_Initialize(XPfb_multichannel *InstancePtr, UINTPTR BaseAddress);
XPfb_multichannel_Config* XPfb_multichannel_LookupConfig(UINTPTR BaseAddress);
#else
int XPfb_multichannel_Initialize(XPfb_multichannel *InstancePtr, u16 DeviceId);
XPfb_multichannel_Config* XPfb_multichannel_LookupConfig(u16 DeviceId);
#endif
int XPfb_multichannel_CfgInitialize(XPfb_multichannel *InstancePtr, XPfb_multichannel_Config *ConfigPtr);
#else
int XPfb_multichannel_Initialize(XPfb_multichannel *InstancePtr, const char* InstanceName);
int XPfb_multichannel_Release(XPfb_multichannel *InstancePtr);
#endif

void XPfb_multichannel_Start(XPfb_multichannel *InstancePtr);
u32 XPfb_multichannel_IsDone(XPfb_multichannel *InstancePtr);
u32 XPfb_multichannel_IsIdle(XPfb_multichannel *InstancePtr);
u32 XPfb_multichannel_IsReady(XPfb_multichannel *InstancePtr);
void XPfb_multichannel_EnableAutoRestart(XPfb_multichannel *InstancePtr);
void XPfb_multichannel_DisableAutoRestart(XPfb_multichannel *InstancePtr);

void XPfb_multichannel_Set_coeff(XPfb_multichannel *InstancePtr, u64 Data);
u64 XPfb_multichannel_Get_coeff(XPfb_multichannel *InstancePtr);

void XPfb_multichannel_InterruptGlobalEnable(XPfb_multichannel *InstancePtr);
void XPfb_multichannel_InterruptGlobalDisable(XPfb_multichannel *InstancePtr);
void XPfb_multichannel_InterruptEnable(XPfb_multichannel *InstancePtr, u32 Mask);
void XPfb_multichannel_InterruptDisable(XPfb_multichannel *InstancePtr, u32 Mask);
void XPfb_multichannel_InterruptClear(XPfb_multichannel *InstancePtr, u32 Mask);
u32 XPfb_multichannel_InterruptGetEnabled(XPfb_multichannel *InstancePtr);
u32 XPfb_multichannel_InterruptGetStatus(XPfb_multichannel *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
