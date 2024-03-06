#
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

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Inherit hentai products.
$(call inherit-product, vendor/hentai/config/common_telephony.mk)

# Includes all AOSP product packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_product.mk)

# Additional settings used in all AOSP builds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.android.dataroaming?=false \

# More AOSP packages
PRODUCT_PACKAGES += \
    messaging \
    PhotoTable \
    preinstalled-packages-platform-aosp-product.xml \
    WallpaperPicker \

# Enforce RRO targets
PRODUCT_ENFORCE_RRO_TARGETS := *
