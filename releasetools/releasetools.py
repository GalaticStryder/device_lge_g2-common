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

import os

TARGET_DIR = os.getenv('OUT')

# HACK: Hooker for copying the boot.img to the block unconditionally.

def IncrementalOTA_InstallEnd(info):
  InstallEnd_PushFullBootImage(info)

def FullOTA_InstallEnd(info):
  InstallEnd_PushFullBootImage(info)

def InstallEnd_PushFullBootImage(info):
  info.script.script = [cmd for cmd in info.script.script if not "boot.img" in cmd]
  info.script.script = [cmd for cmd in info.script.script if not "show_progress(0.100000, 0);" in cmd]
  info.script.AppendExtra('package_extract_file("boot.img", "/tmp/boot.img");')
  info.script.AppendExtra('assert(run_program("/sbin/sh", "-c", "busybox dd if=/tmp/boot.img of=/dev/block/platform/msm_sdcc.1/by-name/boot") == 0);')
