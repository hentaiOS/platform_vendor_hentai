# Kernel
ifeq ($(LOCAL_KERNEL),)
include vendor/hentai/config/BoardConfigKernel.mk
PRODUCT_SOONG_NAMESPACES += \
    vendor/hentai/build/soong/generator
endif

# Qcom-specific bits
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/hentai/config/BoardConfigQcom.mk
endif

# Soong
include vendor/hentai/config/BoardConfigSoong.mk
