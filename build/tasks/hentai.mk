#
# Copyright (C) 2018-2019 The Pixel3ROM Project
# Copyright (C) 2024 The hentaiOS Project and its Proprietors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SIGNED_TARGET_FILES_PACKAGE := $(PRODUCT_OUT)/$(TARGET_DEVICE)-target_files-$(BUILD_ID_LC).zip
SIGN_FROM_TARGET_FILES := $(HOST_OUT_EXECUTABLES)/sign_target_files_apks$(HOST_EXECUTABLE_SUFFIX)

$(SIGNED_TARGET_FILES_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) \
		$(INTERNAL_OTATOOLS_FILES) $(SIGN_FROM_TARGET_FILES)
	@echo "Signed target files package: $@"
	    $(SIGN_FROM_TARGET_FILES) --verbose \
	    -o \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -d $(PROD_CERTS) \
	    $(BUILT_TARGET_FILES_PACKAGE) $@

.PHONY: signed-target-files-package
signed-target-files-package: $(SIGNED_TARGET_FILES_PACKAGE)

PROD_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/$(PROD_VERSION).zip

$(PROD_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(PROD_OTA_PACKAGE_TARGET): $(BRO)

$(PROD_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		$(INTERNAL_OTATOOLS_FILES) $(OTA_FROM_TARGET_FILES)
	@echo "hentai production: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

.PHONY: hentai-prod
hentai-prod: $(PROD_OTA_PACKAGE_TARGET)

PROD_UPDATE_PACKAGE_TARGET := $(PRODUCT_OUT)/$(PROD_VERSION)-img.zip

$(PROD_UPDATE_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
            $(INTERNAL_OTATOOLS_FILES) $(IMG_FROM_TARGET_FILES)
	@echo "hentai updatepackage: $@"
	    $(IMG_FROM_TARGET_FILES) \
	        --additional IMAGES/VerifiedBootParams.textproto:VerifiedBootParams.textproto \
	        $(SIGNED_TARGET_FILES_PACKAGE) $@

.PHONY: hentai-updatepackage
hentai-updatepackage: $(PROD_UPDATE_PACKAGE_TARGET)

ifneq ($(PREVIOUS_TARGET_FILES_PACKAGE),)

INCREMENTAL_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/incremental-$(PROD_VERSION).zip

$(INCREMENTAL_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(BRO)

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		$(INTERNAL_OTATOOLS_FILES) $(OTA_FROM_TARGET_FILES)
	@echo "hentai incremental production: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    -i $(PREVIOUS_TARGET_FILES_PACKAGE) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

.PHONY: incremental-ota
incremental-ota: $(INCREMENTAL_OTA_PACKAGE_TARGET)

endif
