# Kernel
ifeq ($(LOCAL_KERNEL),)
include vendor/hentai/config/BoardConfigKernel.mk
endif

# Qcom-specific bits
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/hentai/config/BoardConfigQcom.mk
endif

# Soong
include vendor/hentai/config/BoardConfigSoong.mk
