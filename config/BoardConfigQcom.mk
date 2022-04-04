# Platform names
KONA := kona #SM8250
LITO := lito #SM7250
MSMNILE := msmnile #SM8150
MSMSTEPPE := sm6150
TRINKET := trinket #SM6125
ATOLL := atoll #SM6250
TARO := taro #SM8450

UM_4_4_FAMILY := msm8998 sdm660
UM_4_9_FAMILY := sdm845 sdm710
UM_4_14_FAMILY := $(MSMNILE) $(MSMSTEPPE) $(TRINKET) $(ATOLL)
UM_4_19_FAMILY := $(KONA) $(LITO)
UM_5_10_FAMILY := $(TARO)
UM_PLATFORMS := $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_10_FAMILY)

BOARD_USES_ADRENO := true

# Add qtidisplay to soong config namespaces
SOONG_CONFIG_NAMESPACES += qtidisplay

# Add supported variables to qtidisplay config
SOONG_CONFIG_qtidisplay += \
    drmpp \
    headless \
    llvmsa \
    gralloc4 \
    displayconfig_enabled \
    udfps \
    default \
    var1 \
    var2 \
    var3

# Set default values for qtidisplay config
SOONG_CONFIG_qtidisplay_drmpp ?= false
SOONG_CONFIG_qtidisplay_headless ?= false
SOONG_CONFIG_qtidisplay_llvmsa ?= false
SOONG_CONFIG_qtidisplay_gralloc4 ?= false
SOONG_CONFIG_qtidisplay_displayconfig_enabled ?= false
SOONG_CONFIG_qtidisplay_udfps ?= false
SOONG_CONFIG_qtidisplay_default ?= true
SOONG_CONFIG_qtidisplay_var1 ?= false
SOONG_CONFIG_qtidisplay_var2 ?= false
SOONG_CONFIG_qtidisplay_var3 ?= false

# Tell HALs that we're compiling an AOSP build with an in-line kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Enable media extensions
TARGET_USES_MEDIA_EXTENSIONS := true

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Enable color metadata for every UM platform
TARGET_USES_COLOR_METADATA := true

# Enable DRM PP driver on UM platforms that support it
ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_drmpp := true
    TARGET_USES_DRM_PP := true
endif

# Enable Gralloc4 on UM platforms that support it
ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_gralloc4 := true
endif

# Select AR variant of A-HAL dependencies
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_AUDIO_AR ?= true
endif

# Enable displayconfig on every UM platform
ifeq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_displayconfig_enabled := true
endif

# List of targets that use master side content protection
MASTER_SIDE_CP_TARGET_LIST := msm8996 $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY)

ifneq ($(filter $(UM_4_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_4_FAMILY)
    QCOM_HARDWARE_VARIANT := msm8998
else ifneq ($(filter $(UM_4_9_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_9_FAMILY)
    QCOM_HARDWARE_VARIANT := sdm845
else ifneq ($(filter $(UM_4_14_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_14_FAMILY)
    QCOM_HARDWARE_VARIANT := sm8150
else ifneq ($(filter $(UM_4_19_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_4_19_FAMILY)
    QCOM_HARDWARE_VARIANT := sm8250
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    MSM_VIDC_TARGET_LIST := $(UM_5_10_FAMILY)
    QCOM_HARDWARE_VARIANT := sm8450
else
    MSM_VIDC_TARGET_LIST := $(TARGET_BOARD_PLATFORM)
    QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif


TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0

# Mark GRALLOC_USAGE_EXTERNAL_DISP as valid gralloc bit
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 13)

# Mark GRALLOC_USAGE_PRIVATE_WFD as valid gralloc bit
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 21)

# Mark GRALLOC_USAGE_PRIVATE_HEIF_VIDEO as valid gralloc bit on UM platforms that support it
ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif

# Allow a device to manually override which HALs it wants to use
ifneq ($(OVERRIDE_QCOM_HARDWARE_VARIANT),)
    QCOM_HARDWARE_VARIANT := $(OVERRIDE_QCOM_HARDWARE_VARIANT)
endif

PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)

# QCOM HW crypto
ifeq ($(TARGET_HW_DISK_ENCRYPTION),true)
    TARGET_CRYPTFS_HW_PATH ?= vendor/qcom/opensource/cryptfs_hw
endif
