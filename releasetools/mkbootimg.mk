#
# Copyright (C) 2016 The Paranoid Android Project
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

LOCAL_PATH := $(call my-dir)

G2_DTS_TARGET ?= msm8974-g2-open_com
KERNEL_CONFIG := $(KERNEL_OUT)/.config
G2_DTS_NAMES := msm8974

G2_DTS_FILES = $(wildcard $(TOP)/$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/lge/msm8974-g2/$(G2_DTS_TARGET)/*.dts)
G2_DTS_FILE = $(lastword $(subst /, ,$(1)))
DTB_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%.dtb,$(call G2_DTS_FILE,$(1))))
ZIMG_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%-zImage,$(call G2_DTS_FILE,$(1))))
KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage
DTC = $(KERNEL_OUT)/scripts/dtc/dtc

define append-g2-dtb
mkdir -p $(KERNEL_OUT)/arch/arm/boot;\
$(foreach G2_DTS_NAME, $(G2_DTS_NAMES), \
   $(foreach d, $(G2_DTS_FILES), \
      $(DTC) -p 1024 -O dtb -o $(call DTB_FILE,$(d)) $(d); \
      cat $(KERNEL_ZIMG) $(call DTB_FILE,$(d)) > $(call ZIMG_FILE,$(d));))
endef

BUMP := $(LOCAL_PATH)/open_bump.py
DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbTool$(HOST_EXECUTABLE_SUFFIX)
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	@echo "Target DT image: $@"
	$(call append-g2-dtb)
	$(call pretty,"Target DT image: $(INSTALLED_DTIMAGE_TARGET)")
	$(hide) $(DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/
	@echo "Made DT image: $@"

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS) $(INSTALLED_DTIMAGE_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo "Bumping boot image..."
	$(hide) $(BUMP) $@ $@

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTFS) $(MKBOOTIMG) $(MINIGZIP) $(RECOVERYIMAGE_EXTRA_DEPS) \
		$(INSTALLED_RAMDISK_TARGET) \
		$(INSTALLED_BOOTIMAGE_TARGET) \
		$(INTERNAL_RECOVERYIMAGE_FILES) \
		$(recovery_initrc) $(recovery_sepolicy) $(recovery_kernel) \
		$(INSTALLED_2NDBOOTLOADER_TARGET) \
		$(recovery_build_prop) $(recovery_resource_deps) \
		$(recovery_fstab) \
		$(RECOVERY_INSTALL_OTA_KEYS)
		$(call build-recoveryimage-target, $@)
	@echo "Bumping recovery image..."
	$(hide) $(BUMP) $@ $@
