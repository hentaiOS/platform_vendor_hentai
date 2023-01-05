#
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

# Optional ART/BT/UWB/WIFI module
MAINLINE_INCLUDE_ART_MODULE ?= true
MAINLINE_INCLUDE_BT_MODULE ?= true
MAINLINE_INCLUDE_UWB_MODULE ?= true
MAINLINE_INCLUDE_WIFI_MODULE ?= true

# Networkstack certificate
PRODUCT_MAINLINE_SEPOLICY_DEV_CERTIFICATES := vendor/hentai/apex/NetworkStack

# Prebuilt module SDKs require prebuilt modules to work, and currently
# prebuilt modules are only provided for com.google.android.xxx.
MODULE_BUILD_FROM_SOURCE := false

# Enable Google Play system updates support
PRODUCT_SOONG_NAMESPACES += \
    vendor/hentai/apex

# ModuleMetadata
PRODUCT_PACKAGES += \
    ModuleMetadataGoogle

# Google Apexes
PRODUCT_PACKAGES += \
	com.google.android.adbd \
	com.google.android.adservices \
	com.google.android.appsearch \
	com.google.android.cellbroadcast \
	com.google.android.conscrypt \
	com.google.android.extservices \
	com.google.android.ipsec \
	com.google.android.media \
	com.google.android.media.swcodec \
	com.google.android.mediaprovider \
	com.google.android.neuralnetworks \
	com.google.android.ondevicepersonalization \
	com.google.android.os.statsd \
	com.google.android.permission \
	com.google.android.resolv \
	com.google.android.scheduling \
	com.google.android.sdkext \
	com.google.android.tethering \
	com.google.android.tzdata4 \
	com.google.mainline.primary.libs

# Apexes
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
	system/apex/com.google.android.adbd \
	system/apex/com.google.android.adservices \
	system/apex/com.google.android.appsearch \
	system/apex/com.google.android.art \
	system/apex/com.google.android.bluetooth \
	system/apex/com.google.android.cellbroadcast \
	system/apex/com.google.android.conscrypt \
	system/apex/com.google.android.extservices \
	system/apex/com.google.android.ipsec \
	system/apex/com.google.android.media \
	system/apex/com.google.android.media.swcodec \
	system/apex/com.google.android.mediaprovider \
	system/apex/com.google.android.neuralnetworks \
	system/apex/com.google.android.ondevicepersonalization \
	system/apex/com.google.android.os.statsd \
	system/apex/com.google.android.permission \
	system/apex/com.google.android.resolv \
	system/apex/com.google.android.scheduling \
	system/apex/com.google.android.sdkext \
	system/apex/com.google.android.tethering \
	system/apex/com.google.android.tzdata4 \
	system/apex/com.google.android.uwb \
	system/apex/com.google.android.wifi \
	system/apex/com.google.mainline.primary.libs

# Dex
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/framework/arm/%.art \
    system/framework/arm/%.oat \
    system/framework/arm/%.vdex \
    system/framework/arm64/%.art \
    system/framework/arm64/%.oat \
    system/framework/arm64/%.vdex \

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/framework/oat/arm/%.odex \
    system/framework/oat/arm/%.vdex \
    system/framework/oat/arm64/%.odex \
    system/framework/oat/arm64/%.vdex \
