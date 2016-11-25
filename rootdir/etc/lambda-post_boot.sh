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
echo "[Lambda] Initializing Kernel post-boot script" | tee /dev/kmsg

############################
# RQ Stats
#
echo "0" > /sys/devices/system/cpu/cpu0/rq-stats/hotplug_enable

############################
# Governors
#
# TODO: Re-do for AOSPA battery life focus, but keeping impulse.
#
# Interactive:
echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 0.25 # Wait for interactive sysfs paths.
echo "20000 1400000:40000 1700000:20000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo "70" > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo "1190400" > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo "89 1300000:45 1500000:65 1700000:80 1800000:98" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo "40000" > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo "30000" > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo "-1" > /sys/devices/system/cpu/cpufreq/interactive/timer_slack
echo "100000" > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
# Impulse:
echo "impulse" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 0.25 # Wait for impulse sysfs paths.
echo "19000 1400000:39000 1700000:19000 2100000:79000" > /sys/devices/system/cpu/cpufreq/impulse/above_hispeed_delay
echo "95" > /sys/devices/system/cpu/cpufreq/impulse/go_hispeed_load
echo "1728000" > /sys/devices/system/cpu/cpufreq/impulse/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpufreq/impulse/io_is_busy
echo "85 1500000:90 1800000:70 2100000:95" > /sys/devices/system/cpu/cpufreq/impulse/target_loads
echo "1" > /sys/devices/system/cpu/cpufreq/impulse/powersave_bias
echo "79000" > /sys/devices/system/cpu/cpufreq/impulse/max_freq_hysteresis
echo "19000" > /sys/devices/system/cpu/cpufreq/impulse/min_sample_time
echo "20000" > /sys/devices/system/cpu/cpufreq/impulse/timer_rate

############################
# State Notifier
#
echo "1" > /sys/module/state_notifier/parameters/enabled

############################
# MSM Hotplug
#
echo "1" > /sys/module/msm_hotplug/msm_enabled

############################
# MSM Limiter
#
echo "impulse" > /sys/kernel/msm_limiter/scaling_governor
echo "2265600" > /sys/kernel/msm_limiter/resume_max_freq
echo "1" > /sys/kernel/msm_limiter/debug_mask
echo "0" > /sys/kernel/msm_limiter/mpd_enabled
echo "1" > /sys/kernel/msm_limiter/freq_control

############################
# CPU Input Boost
#
echo "422400 729600" > /sys/kernel/cpu_input_boost/ib_freqs
echo "400" > /sys/kernel/cpu_input_boost/ib_duration_ms
echo "1" > /sys/kernel/cpu_input_boost/enabled

############################
# GPU
#
# TODO: Refactor in Kernel.
#
# echo "cpubw_hwmon" > /sys/class/devfreq/qcom,cpubw.42/governor
# echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor

############################
# Scheduler/Read Ahead
#
echo "fiops" > /sys/block/mmcblk0/queue/scheduler
setprop sys.io.scheduler "fiops"
echo "1024" > /sys/block/mmcblk0/bdi/read_ahead_kb

############################
# Random
#
echo "256" > /proc/sys/kernel/random/write_wakeup_threshold

############################
# Swappiness
#
echo "50" > /proc/sys/vm/swappiness

############################
# LMK
#
# TODO: Set optimal values.
#
echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "53059" > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
# echo "0" > /sys/module/lowmemorykiller/parameters/lmk_fast_run
# echo "18432,23040,24576,28672,31744,34816" > /sys/module/lowmemorykiller/parameters/minfree
# echo "48" > /sys/module/lowmemorykiller/parameters/cost

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
# MPDecision
#
stop mpdecision # Again, just in case!
echo "[Lambda] Exiting Kernel post-boot script" | tee /dev/kmsg
