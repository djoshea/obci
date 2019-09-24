Using xPC Target(TM) on PCs with the Intel(R) ICH5 family chipset
=================================================================

To successfully operate real-time software on any microprocessor system,
control and management of all interrupt services is
required. Unfortunately, depending on your BIOS, it may not be possible
to turn off certain interrupts known as System Management Interrupts
(SMIs).  These interrupts are not accessible from operating system,
kernel, or application software and the CPU cannot be instructed to
ignore them. However, for some chipsets, such as the Intel ICH5 family,
it is possible to programmatically prevent or disable the generation of
SMIs.

SMIs are used to handle a variety of tasks. One example is CPU thermal
management in x86-based processor systems.  If you have a BIOS parameter
such as "Delay prior to thermal", this is used to control the temperature
of the CPU and is usually driven by an SMI.  Typical BIOS parameter
settings are 4, 8, 16, and 32.  This controls the time duration of the
SMI and indicates the interrupt will be enabled and occur for the first
4, 8, 16 or 32 minutes after boot up, regardless of the thermal state of
the CPU.

xPC Target(TM) is a product of The MathWorks that allows for real-time
execution of Simulink models on x86-based PC platforms.  Simulink models
are downloaded to a PC, known as the target PC, which is booted with the
xPC Target real-time kernel.  As noted above, unexpected SMIs can impact
the performance of a model as it executes and this can result in an
unwanted and unexpected "CPU Overload".

To prevent this, the enclosed S-function can be used.  Simply drop the
S-function block into any Simulink model and SMIs will be disabled when
the model is downloaded to the target PC.  This presupposes you have an
Intel ICH5 chipset.  If so and you are experiencing frequency CPU
overloads, the enclosed S-function should disable the SMI and prevent
unnecessary interruption.  If the target PC does not have an ICHS
chipset, the S-function will do nothing and will have no impact on model
execution.


To install: unzip the files into any directory on your MATLAB path.
Open the library by typing "IntelSMIlibR2007b" at the MATLAB prompt, and
drag and drop the single block into your model.  If a matching chipset
is found, a message identifying the chipset will be printed, and the
SMIs will be disabled.  If no such chipset is found, a corresponding
message will be printed, and execution will continue as normal (of
course, no action will be taken).

If you get a message such as
"Failed to clear GBL_SMI_EN bit; SMI_LOCK may be set"
this means that the BIOS is locking the ability to globally turn off
SMIs.  However, this solution may still work since we are individually
turning off other SMIs.

Changelog:

Dec 17, 2009
------------
Added PCI id 0x2917 based on user suggestion.

Oct 14 2008
-----------
Added more chipsets from the ICH7 family; updated to test the GBL_SMI_EN
bit if it got set.  Thanks to Ian Brown of Queen's University for the
contributions.

If you get a message such as
"Failed to clear GBL_SMI_EN bit; SMI_LOCK may be set"
this means that the BIOS is locking the ability to globally turn off
SMIs.  However, this solution may still work since we are individually
turning off other SMIs.

Jan 13 2009
-----------
Added chipsets for ICH9 based on user contributions, PCI IDs 0x2916 and
0x2918.