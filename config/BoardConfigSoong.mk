PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE))

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += hentaiVarsPlugin

SOONG_CONFIG_hentaiVarsPlugin :=

define addVar
  SOONG_CONFIG_hentaiVarsPlugin += $(1)
  SOONG_CONFIG_hentaiVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += hentaiGlobalVars
SOONG_CONFIG_hentaiGlobalVars += \
    spoof_first_api_level_32

# Soong value variables
SOONG_CONFIG_hentaiGlobalVars_spoof_first_api_level_32 := $(BOARD_SPOOF_FIRST_API_LEVEL_32)
