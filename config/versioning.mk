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

BUILD_ID_LC ?= $(shell echo $(BUILD_ID) | tr '[:upper:]' '[:lower:]')

PLATFORM_HENTAI_RELEASE := Ursamoon

ifeq ($(TARGET_BUILD_VARIANT),user)
    PROD_VERSION += $(TARGET_PRODUCT)-$(PLATFORM_HENTAI_RELEASE)-ota-$(BUILD_ID_LC)-Furry.$(shell date +%m%d%H%M)
else
    PROD_VERSION += $(TARGET_PRODUCT)-$(PLATFORM_HENTAI_RELEASE)-ota-$(BUILD_ID_LC)-INT.$(shell date +%m%d%H%M)
endif

$(call inherit-product-if-exists, vendor/hentai/build/target/product/security/hentai_security.mk)

PRODUCT_HOST_PACKAGES += \
    sign_target_files_apks \
    ota_from_target_files
