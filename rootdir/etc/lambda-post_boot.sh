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
# RQ Stats
#
sleep 1
echo "0" > /sys/devices/system/cpu/cpu0/rq-stats/hotplug_enable

############################
# MSM Hotplug
#
sleep 1.5
echo "1" > /sys/module/msm_hotplug/msm_enabled

############################
# MSM Limiter
#
sleep 1.5
echo "2265600" > /sys/kernel/msm_limiter/resume_max_freq
echo "1" > /sys/kernel/msm_limiter/debug_mask
echo "0" > /sys/kernel/msm_limiter/mpd_enabled
echo "1" > /sys/kernel/msm_limiter/freq_control

############################
# Scheduler/Read Ahead
#
sleep 0.5
echo "fiops" > /sys/block/mmcblk0/queue/scheduler

############################
# Swappiness
#
sleep 0.5
echo "50" > /proc/sys/vm/swappiness

############################
# LMK
#
sleep 0.5
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
sleep 0.5
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
# MPDecision
#
echo "[Lambda] Exiting post-boot script" | tee /dev/kmsg
