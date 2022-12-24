#
# Copyright (C) 2018-2019 The Google Pixel3ROM Project
#
# Licensed under the Apache License, Version 2.0 (the License);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an AS IS BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := ModuleMetadataGoogle
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ModuleMetadataGoogle/ModuleMetadataGoogle.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRODUCT_MODULE := true
LOCAL_MODULE_CLASS := APPS
LOCAL_OVERRIDES_PACKAGES := ModuleMetadata
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

# Google Apexes
LOCAL_REQUIRED_MODULES += \
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

# ART Mainline Module
ifeq ($(MAINLINE_INCLUDE_ART_MODULE),true)
LOCAL_REQUIRED_MODULES += \
    com.google.android.art
endif

# Bluetooth Mainline Module
ifeq ($(MAINLINE_INCLUDE_BT_MODULE),true)
LOCAL_REQUIRED_MODULES += \
    com.google.android.bluetooth
endif
# UWB Mainline Module
ifeq ($(MAINLINE_INCLUDE_UWB_MODULE),true)
LOCAL_REQUIRED_MODULES += \
    com.google.android.uwb
endif

# WIFI Mainline Module
ifeq ($(MAINLINE_INCLUDE_WIFI_MODULE),true)
LOCAL_REQUIRED_MODULES += \
    com.google.android.wifi
endif

# Virtualization Mainline Module
ifeq ($(PRODUCT_BUILD_PVMFW_IMAGE),true) 
LOCAL_REQUIRED_MODULES += \
	com.google.android.compos \
	com.google.android.virt
endif
include $(BUILD_PREBUILT)
