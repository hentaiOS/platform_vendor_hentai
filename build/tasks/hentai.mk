#
# Copyright (C) 2018-2019 The Pixel3ROM Project
# Copyright (C) 2020 Raphielscape LLC. and Haruka LLC.
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

$(SIGNED_TARGET_FILES_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/sign_target_files_apks
	@echo "Signed target files package: $@"
	    ./build/tools/releasetools/sign_target_files_apks --verbose \
	    -o \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -d $(PROD_CERTS) \
	    $(SIGNING_FLAGS) \
	    $(APEX_SIGNING_FLAGS) \
	    $(BUILT_TARGET_FILES_PACKAGE) $@

.PHONY: signed-target-files-package
signed-target-files-package: $(SIGNED_TARGET_FILES_PACKAGE)

PROD_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/$(PROD_VERSION).zip

$(PROD_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(PROD_OTA_PACKAGE_TARGET): $(BRO)

$(PROD_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/ota_from_target_files
	@echo "hentai production: $@"
	    ./build/tools/releasetools/ota_from_target_files --verbose \
	    --block \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

.PHONY: hentai-prod
hentai-prod: $(PROD_OTA_PACKAGE_TARGET)

ifneq ($(PREVIOUS_TARGET_FILES_PACKAGE),)

INCREMENTAL_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/incremental-$(PROD_VERSION).zip

$(INCREMENTAL_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(BRO)

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/ota_from_target_files
	@echo "hentai incremental production: $@"
	    ./build/tools/releasetools/ota_from_target_files --verbose \
	    --block \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    -i $(PREVIOUS_TARGET_FILES_PACKAGE) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

.PHONY: incremental-ota
incremental-ota: $(INCREMENTAL_OTA_PACKAGE_TARGET)

endif
