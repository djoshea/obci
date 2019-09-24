/**
 * ich5.c - xPC Target, non-inlined S-function driver for ICH5 chipset
 *          configuration.  This function is used to configure the chipset
 *          to not generate SMIs.
 *
 * Information is from:
 *   Intel(r) 82801EB I/O Controller Hub 5 (ICH5)/Intel 82801ER I/O
 *   Controller Hub 5 R (ICH5R) Datasheet, April 2003 (Document number
 *   25216-001). (c) 2002-2003, Intel Corporation.
 *
 * Added PCI id 0x2917 Dec 2009
 *
 * ICH7 family added Oct 2008
 * Information is from:
 *   Intel(r) I/O Controller Hub 7 (ICH7) family Datasheet, April 2007
 *   Document numbers 307013-003 and 307014-023. (c) 2007, Intel Corporation.
 *
 *  Changes contributed by Ian Brown [ianbrown@biomed.queensu.ca]
 */
/* Copyright 2008-2009 The MathWorks, Inc. */

#define         S_FUNCTION_LEVEL        2
#undef          S_FUNCTION_NAME
#define         S_FUNCTION_NAME         ich5

#include        <stddef.h>
#include        <stdlib.h>

#include        "simstruc.h"

#ifdef          MATLAB_MEX_FILE
#include        "mex.h"
#endif

#ifndef         MATLAB_MEX_FILE
#include        "xpctarget.h"
#endif

/* Input Arguments */
#define NUMBER_OF_ARGS    (0)

#define NO_R_WORKS        (0)
#define NO_I_WORKS        (5)
#define NO_P_WORKS        (0)

/* Index into IWork */
#define  SMI_EN_ADDR      (0)
#define  SMI_EN_ORIG      (1)
#define GPE0_EN_ADDR      (2)
#define GPE0_EN_ORIG      (3)
#define  PMBASE_ADDR      (4)

static char msg[256];

static void mdlInitializeSizes(SimStruct *S) {
    int j;

    ssSetNumSFcnParams(S, 0);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        sprintf(msg,"Wrong number of input arguments passed.\n"
                "%d arguments are expected\n", NUMBER_OF_ARGS);
        ssSetErrorStatus(S,msg);
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    ssSetNumInputPorts( S, 0);
    ssSetNumOutputPorts(S, 0);

    ssSetNumSampleTimes(S, 1);

    ssSetNumRWork(S, NO_R_WORKS);
    ssSetNumIWork(S, NO_I_WORKS);
    ssSetNumPWork(S, NO_P_WORKS);

    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    for (j = 0; j < NUMBER_OF_ARGS; j++)
        ssSetSFcnParamNotTunable(S, j);

    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE | SS_OPTION_PLACE_ASAP);
    return;
}

static void mdlInitializeSampleTimes(SimStruct *S) {
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

#ifndef MATLAB_MEX_FILE
static const struct PCIVendorId_t {
    uint16_T    id;
    const char *descr;
} IntelChipSets[] =
    {
        {0x2410, "82801AA_0"},
        {0x2420, "82801AB_0"},
        {0x2440, "82801BA_0"},
        {0x244c, "82801BA_10"},
        {0x2450, "82801E_0"},
        {0x2480, "82801CA_0"},
        {0x248c, "82801CA_12"},
        {0x24c0, "82801DB_0"},
        {0x24cc, "82801DB_12"},
        {0x24d0, "82801EB_0"},
        {0x25a1, "6300ESB LIB"},
        {0x2640, "ICH6_0"},
        {0x2641, "ICH6_1"},
        {0x2642, "ICH6_2"},
        {0x27B8, "ICH7, ICH7R 945GL"},
        {0x27B9, "ICH7M, ICH7U"},
        {0x27BD, "ICH7M DH"},
		{0x2916, "ICH9"},
        {0x2917, "ICH9M-E"},
		{0x2918, "ICH9"},
        {0x1c50, "IntelCorei7"},
        {0x8cc4, "Rig1Chipset"},
        {0x0000, NULL}
    };
#endif

#define BIT(n) (1 << (n))

#define GBL_SMI_EN BIT(0)
#define LEGACY_USB_EN BIT(3)
#define LEGACY_USB2_EN BIT(17)
#define INTEL_USB2_EN  BIT(18)

//#define SMI_BITS (GBL_SMI_EN | LEGACY_USB_EN | LEGACY_USB2_EN | INTEL_USB2_EN)
#define SMI_BITS (GBL_SMI_EN)


#define MDL_START
static void mdlStart(SimStruct *S) {
#ifndef MATLAB_MEX_FILE
    int32_T *i = ssGetIWork(S);
    uint32_T *bits;
    uint32_T  smi_en_tst;

    xpcPCIDevice pciinfo;
    const struct PCIVendorId_t *vend;
    uint32_T pmBase;

    for (vend = IntelChipSets; vend->id > 0; vend++) {
        /* Want bus 0, device 31: LPC Interface Bridge */
        if (xpcGetPCIDeviceInfo(0x8086, vend->id, XPC_NO_SUB, XPC_NO_SUB,
                                0, 31, &pciinfo) == 0) { /* Bus 0, device 31 */
            break;
        }
    }
    if (vend->id == 0) {                /* not found */
        i[SMI_EN_ADDR] = 0xffffffff; /* marker value */
        printf("Intel chipset not found\n");
        return;
    } else {
        printf("Found chipset with ID 0x%04x\n", (unsigned int)vend->id);
    }

    xpcOutpDW(0xCF8,
              0x80000000 |              /* set config enable bit */
              (31 << 11) |              /* slot */
              0x40);                    /* config space address */

    /* pmBase is bits 7-15, giving us a 128 byte slot */
    pmBase = xpcInpDW(0xCFC) & (uint32_T)(0x1ff << 7); /* bits 7-15 */

    i[ SMI_EN_ADDR] = pmBase + 0x30;    /* SMI_EN base within PMBASE */
    i[GPE0_EN_ADDR] = pmBase + 0x2C;

    i[ SMI_EN_ORIG] = (uint32_T)xpcInpDW((uint16_T)i[ SMI_EN_ADDR]);
    i[GPE0_EN_ORIG] = (uint32_T)xpcInpDW((uint16_T)i[GPE0_EN_ADDR]);

    i[PMBASE_ADDR]  = (uint32_T)pmBase;

    /* Set all bits to 0.  Another alternative is to use the commented
     * out line below.
     */
    xpcOutpDW((uint16_T)i[SMI_EN_ADDR], 0);
    /* Could use this instead of the line above */
    /* (uint32_T)i[SMI_EN_ORIG] & ~SMI_BITS); */
    /* Don't touch GPE0_EN_ADDR for now */

    /* with ICH7, if the SMI_LOCK bit is set, then we cannot write a 0
       to the SMI_GBL_EN bit (i.e. bit 0 of SMI_EN_ADDR). */
    /* Test the GBL_SMI_EN bit to see if it was actually cleared */
    smi_en_tst = (uint32_T)xpcInpDW((uint16_T)i[ SMI_EN_ADDR]);
    if (((smi_en_tst     & GBL_SMI_EN) != 0) && 
        ((i[SMI_EN_ORIG] & GBL_SMI_EN) != 0)) {
        /* Tried to set the bit, but it failed */
        printf("Failed to clear GBL_SMI_EN bit; SMI_LOCK may be set\n");
    }

#endif
}

static void mdlOutputs(SimStruct *S, int_T tid) {
    /* Nothing to do */
}

static void mdlTerminate(SimStruct *S) {
#ifndef MATLAB_MEX_FILE
    uint32_T  *i = (uint32_T *)ssGetIWork(S);

    if (i[SMI_EN_ADDR] == 0xffffffff) {
        /* ffffffff: No chipset found; don't do anything */
        return;
    }

    /* Reset registers to their original values */
    xpcOutpDW((uint16_T)i[ SMI_EN_ADDR], i[ SMI_EN_ORIG]);
    /* Don't touch GPE0_EN_ADDR for now */
    //xpcOutpDW((uint16_T)i[GPE0_EN_ADDR], i[GPE0_EN_ORIG]);
#endif
}

#ifdef MATLAB_MEX_FILE  /* Is this file being compiled as a MEX-file? */
#include "simulink.c"   /* Mex glue */
#else
#include "cg_sfun.h"    /* Code generation glue */
#endif
