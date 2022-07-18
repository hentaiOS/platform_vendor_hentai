# Qcom-specific bits
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/hentai/config/BoardConfigQcom.mk
endif

# Soong
include vendor/hentai/config/BoardConfigSoong.mk
