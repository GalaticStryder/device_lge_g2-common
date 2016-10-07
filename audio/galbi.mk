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
#

LOCAL_PATH := $(call my-dir)

BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := false
AUDIO_FEATURE_ENABLED_ANC_HEADSET := false
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := false
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_HDMI_SPK := true
AUDIO_FEATURE_ENABLED_HDMI_EDID := true
AUDIO_FEATURE_ENABLED_USBAUDIO := true
AUDIO_FEATURE_ENABLED_HFP := false
AUDIO_FEATURE_ENABLED_CUSTOMSTEREO := false
AUDIO_FEATURE_ENABLED_SSR := false
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := false
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := false
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_SPKR_PROTECTION := true
AUDIO_FEATURE_ENABLED_COMPRESS_CAPTURE := false
AUDIO_FEATURE_ENABLED_NEW_SAMPLE_RATE := true
# TODO: Set low latency as default together ULL.
AUDIO_FEATURE_LOW_LATENCY_PRIMARY := false
AUDIO_FEATURE_ENABLED_LISTEN := false
AUDIO_FEATURE_ENABLED_AUXPCM_BT := false
AUDIO_FEATURE_PCM_IOCTL_ENABLED := true
AUDIO_FEATURE_ENABLED_HWDEP_CAL := true
AUDIO_FEATURE_ENABLED_EXTN_POST_PROC := true
#DTS_CODEC_M_ := true TODO: Backport this codec from Alcatel.
DOLBY_DDP := true
DOLBY_DAP := true
TARGET_USES_QCOM_MM_AUDIO := true

# XML
# The $LOCAL_PATH variable is device/lge/g2-common, not this file/directory.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/mixer_paths.xml:system/etc/mixer_paths.xml

# Packages
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.msm8974 \
    audio.r_submix.default \
    audio.usb.default \
    audiod \
    libaudio-resampler \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcomvoiceprocessingdescriptors

# DRM
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# Fluence (Calls only)
# TODO: Rework all this for real.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.fluence.voicecall=true \
    ro.qc.sdk.audio.fluencetype=fluence

# Output
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio_hal.period_size=192 \
    persist.audio.dualmic.config=endfire \
    media.aac_51_output_enabled=true \
    mm.enable.smoothstreaming=true \
    use.voice.path.for.pcm.voip=true

# Offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.deep_buffer.media=true \
    audio.offload.buffer.size.kb=32 \
    audio.offload.video=true \
    audio.offload.multiple.enabled=false \
    audio.offload.gapless.enabled=true
