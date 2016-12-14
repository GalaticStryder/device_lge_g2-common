#!/system/bin/sh
#
# Copyright - Ícaro Hoff <icarohoff@gmail.com>
#
#              \
#              /\
#             /  \
#            /    \
#

############################
# Kick-off
#
stop mpdecision # To avoid troubles...
echo "[Lambda] Kicking-off post-boot script" | tee /dev/kmsg

############################
# Simple Thermal
#
echo "0" > /sys/kernel/msm_thermal/enabled
echo "1728000 39 38" > /sys/kernel/msm_thermal/zone0
echo "1574400 42 40" > /sys/kernel/msm_thermal/zone1
echo "1497600 45 43" > /sys/kernel/msm_thermal/zone2
echo "1267200 49 46" > /sys/kernel/msm_thermal/zone3
echo "1190400 53 50" > /sys/kernel/msm_thermal/zone4
echo "1036800 56 54" > /sys/kernel/msm_thermal/zone5
echo "960000 62 60" > /sys/kernel/msm_thermal/zone6
echo "729600 79 75" > /sys/kernel/msm_thermal/zone7
echo "8000" > /sys/kernel/msm_thermal/sampling_ms
echo "1" > /sys/kernel/msm_thermal/enabled

############################
# RQ Stats
#
echo "0" > /sys/devices/system/cpu/cpu0/rq-stats/hotplug_enable

############################
# MSM Hotplug
#
echo "1" > /sys/module/msm_hotplug/msm_enabled

############################
# MSM Limiter
#
echo "2265600" > /sys/kernel/msm_limiter/resume_max_freq
echo "0" > /sys/kernel/msm_limiter/mpd_enabled
echo "1" > /sys/kernel/msm_limiter/debug_mask
echo "1" > /sys/kernel/msm_limiter/freq_control
echo "ondemand" > /sys/kernel/msm_limiter/scaling_governor

############################
# CPU Input Boost
#
echo "1190400 1497600" > /sys/kernel/cpu_input_boost/ib_freqs
echo "1400" > /sys/kernel/cpu_input_boost/ib_duration_ms
echo "1" > /sys/kernel/cpu_input_boost/enabled

############################
# I/O Scheduler
#
echo "fiops" > /sys/block/mmcblk0/queue/scheduler

############################
# Swappiness
#
echo "50" > /proc/sys/vm/swappiness

############################
# LMK
#
echo "18432,23040,24576,28672,31744,34816" > /sys/module/lowmemorykiller/parameters/minfree
echo "48" > /sys/module/lowmemorykiller/parameters/cost
echo "73728" > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
echo "85" > /sys/module/lowmemorykiller/parameters/vm_pressure_adaptive_start
echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "0" > /sys/module/lowmemorykiller/parameters/lmk_fast_run
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level

############################
# Debugging
#
echo "0" > /sys/module/alarm_dev/parameters/debug_mask
echo "0" > /sys/module/lge_touch_core/parameters/debug_mask
echo "0" > /sys/devices/fe12f000.slim/debug_mask
echo "0" > /sys/module/smd/parameters/debug_mask
echo "0" > /sys/module/smem/parameters/debug_mask
echo "0" > /sys/module/ipc_router/parameters/debug_mask
echo "0" > /sys/module/smp2p/parameters/debug_mask
echo "0" > /sys/module/msm_serial_hs_lge/parameters/debug_mask
echo "0" > /sys/module/mpm_of/parameters/debug_mask
echo "0" > /sys/module/msm_pm/parameters/debug_mask

############################
# Finish
#
echo "[Lambda] Exiting post-boot script" | tee /dev/kmsg
