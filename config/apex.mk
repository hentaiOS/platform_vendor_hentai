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

# FIXME -- DeviceLock ModulePrebuilt is only planned to be released for QPR2
DISABLE_DEXPREOPT_CHECK := true

# Optional ART/BT/UWB/WIFI module
MAINLINE_INCLUDE_ART_MODULE ?= true
MAINLINE_INCLUDE_BT_MODULE ?= true
MAINLINE_INCLUDE_TETHERING_MODULE ?= true
MAINLINE_INCLUDE_UWB_MODULE ?= true
MAINLINE_INCLUDE_WIFI_MODULE ?= true

# Networkstack certificate
# only needed if we are building NetworkStackGoogle
ifeq ($(MAINLINE_INCLUDE_NETWORK_STACK_MODULE), true)
PRODUCT_MAINLINE_SEPOLICY_DEV_CERTIFICATES=vendor/hentai/apex/certificates
endif


# Prebuilt module SDKs require prebuilt modules to work, and currently
# prebuilt modules are only provided for com.google.android.xxx.
MODULE_BUILD_FROM_SOURCE ?= false

SOONG_CONFIG_NAMESPACES += wifi_module
SOONG_CONFIG_wifi_module += source_build
SOONG_CONFIG_wifi_module_source_build := true

SOONG_CONFIG_NAMESPACES += uwb_module
SOONG_CONFIG_uwb_module += source_build
SOONG_CONFIG_uwb_module_source_build := true

SOONG_CONFIG_NAMESPACES += bluetooth_module
SOONG_CONFIG_bluetooth_module += source_build
SOONG_CONFIG_bluetooth_module_source_build := true

ifneq ($(MAINLINE_INCLUDE_ART_MODULE),true)
ART_MODULE_BUILD_FROM_SOURCE := true
endif

ifeq ($(MAINLINE_INCLUDE_BT_MODULE),true)
SOONG_CONFIG_bluetooth_module_source_build := false
endif

ifeq ($(MAINLINE_INCLUDE_TETHERING_MODULE),true)
SOONG_CONFIG_tethering_module_source_build := false
endif

ifeq ($(MAINLINE_INCLUDE_UWB_MODULE),true)
SOONG_CONFIG_uwb_module_source_build := false
endif

ifeq ($(MAINLINE_INCLUDE_WIFI_MODULE),true)
SOONG_CONFIG_wifi_module_source_build := false
endif

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
	com.google.android.configinfrastructure \
	com.google.android.conscrypt \
	com.google.android.devicelock \
	com.google.android.extservices \
	com.google.android.healthfitness \
	com.google.android.ipsec \
	com.google.android.media \
	com.google.android.media.swcodec \
	com.google.android.mediaprovider \
	com.google.android.neuralnetworks \
	com.google.android.ondevicepersonalization \
	com.google.android.os.statsd \
	com.google.android.permission \
	com.google.android.resolv \
	com.google.android.rkpd \
	com.google.android.scheduling \
	com.google.android.sdkext \
	com.google.android.tzdata5 \
	com.google.mainline.primary.libs

# cellbroadcast needs same certificate as network stack
ifeq ($(MAINLINE_INCLUDE_NETWORK_STACK_MODULE),true)
PRODUCT_PACKAGES += com.google.android.cellbroadcast
endif