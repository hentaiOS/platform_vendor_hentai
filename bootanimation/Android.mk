#
# Copyright (C) 2020 Raphielscape LLC. and Haruka LLC.
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

# If the device is a pixel we support themable bootanimation
# FIXME
# Find some other way to detect device as we can't really do much due to the order they are included in

ifneq ($(filter walleye taimen blueline crosshatch bonito sargo flame coral sunfish bramble redfin, $(TARGET_DEVICE)),)
include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation
LOCAL_MODULE_TAGS := optional
ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
LOCAL_SRC_FILES := bootanimation-light_1440.zip
else
LOCAL_SRC_FILES := bootanimation-light_1080.zip
endif
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
LOCAL_MODULE_SUFFIX := .zip
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation-dark
LOCAL_MODULE_TAGS := optional
ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
LOCAL_SRC_FILES := bootanimation-dark_1440.zip
else
LOCAL_SRC_FILES := bootanimation-dark_1080.zip
endif
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
LOCAL_MODULE_SUFFIX := .zip
include $(BUILD_PREBUILT)

else

include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation
LOCAL_MODULE_TAGS := optional
ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
LOCAL_SRC_FILES := bootanimation-dark_1440.zip
else
LOCAL_SRC_FILES := bootanimation-dark_1080.zip
endif
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media
LOCAL_MODULE_SUFFIX := .zip
include $(BUILD_PREBUILT)

endif
