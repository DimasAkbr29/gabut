#!/system/bin/sh
MODDIR=${0%/*}

syslimit=/proc/perfmgr/syslimiter
ppm=/proc/ppm
MINFREE_VALUES="2560,5120,7680,8960,10240,12800"
# $1: Value $2: Directory
write_val()
{
    if [ -e "$2" ]; then
        if [ ! -w "$2" ]; then
            chmod +w "$2"
        else
            echo "$1" > "$2"
        fi
    fi
}

# $1: Value $2: Directory
lock_val()
{
    if [ -e "$2" ]; then
        chmod 0664 "$2"
        echo "$1" > "$2"
        chmod 0444 "$2"
    fi
}

# Start Notification
notif_start() { su -lp 2000 -c "cmd notification post -S bigtext -t 'Starting Module' tag 'Please Wait a Sec!'" >/dev/null 2>&1; }

# End Notification
notif_end() { su -lp 2000 -c "cmd notification post -S bigtext -t 'Done' tag 'Join Our Group @Archive_dim @gabutdiscuss Telegram'" >/dev/null 2>&1; }

boot_wait() {
 while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done
}

boot_wait


notif_start

write_val "$MINFREE_VALUES" /sys/module/lowmemorykiller/parameters/minfree

# Kernel Mode ( HMP )
write_val "0" "/sys/devices/system/cpu/eas/enable"
write_val "0" /sys/kernel/eara_thermal/enable


syslimit=$(find /proc/perfmgr/syslimiter -type d)
for fps in $syslimit ; do
    chmod 644 "$fps/syslimiter_fps_60"
    lock_val "1" "$fps/syslimiter_fps_60"
    chmod 644 "$fps/syslimiter_fps_90"
    lock_val "1" "$fps/syslimiter_fps_90"
    chmod 644 "$fps/syslimiter_fps_120"
    lock_val "1" "$fps/syslimiter_fps_120"
    chmod 644 "$fps/syslimiter_fps_144"
    lock_val "1" "$fps/syslimiter_fps_144"
    chmod 644 "$fps/syslimiter_force_disable"
    lock_val "1" "$fps/syslimiter_force_disable"
done

lock_val "0" > /sys/module/ged/parameters/gx_dfps


# Disable Some Log
for i in debug_mask log_level* debug_level* *debug_mode edac_mc_log* enable_event_log *log_level* *log_ue* *log_ce* log_ecn_error snapshot_crashdumper seclog* compat-log *log_enabled tracing_on mballoc_debug sched_schedstats exception-trace; do
    for log in $(find /sys/ -type f -name "$i"); do
        write_val "0" "$log"
    done
done


# Virtual Memory
for VM in /proc/sys/vm; do
    lock_val "3" "$VM/drop_caches"
    lock_val "20" "$VM/dirty_background_ratio"
    lock_val "1000"/"$VM/dirty_expire_centisecs"
    lock_val "0" "$VM/page-cluster"
    lock_val "10" "$VM/dirty_ratio"
    lock_val "0" "$VM/laptop_mode"
    lock_val "1" "$VM/block_dump"
    lock_val "0" "$VM/compact_memory"
    lock_val "5000" "$VM/dirty_writeback_centisecs"
    lock_val "1" "$VM/oom_dump_tasks"
    lock_val "0" "$VM/oom_kill_allocating_task"
    lock_val "60" "$VM/stat_interval"
    lock_val "0" "$VM/panic_on_oom"
    lock_val "60" "$VM/swappiness"
    lock_val "50" "$VM/vfs_cache_pressure"
    lock_val "80" "$VM/overcommit_ratio"
    lock_val "10240" "$VM/extra_free_kbytes"
done

for GED in /sys/module/ged/parameters; do
    write_val "1" "$GED/boost_amp"
    write_val "1" "$GED/boost_extra"
    write_val "1" "$GED/boost_gpu_enable"
    write_val "100" "$GED/cpu_boost_policy"
    write_val "0" "$GED/deboost_reduce"
    write_val "1" "$GED/enable_cpu_boost"
    write_val "1" "$GED/enable_game_self_frc_detect"
    write_val "1" "$GED/enable_gpu_boost"
    write_val "0" "$GED/g_fb_dvfs_threshold"
    write_val "1" "$GED/g_gpu_timer_based_emu"
    write_val "1" "$GED/ged_boost_enable"
    write_val "1" "$GED/ged_force_mdp_enable"
    write_val "0" "$GED/ged_log_perf_trace_enable"
    write_val "0" "$GED/ged_log_trace_enable"
    write_val "0" "$GED/ged_monitor_3D_fence_debug"
    write_val "1" "$GED/ged_monitor_3D_fence_disable"
    write_val "0" "$GED/ged_monitor_3D_fence_systrace"
    write_val "1" "$GED/ged_smart_boost"
    write_val "0" "$GED/gpu_debug_enable"
    write_val "1" "$GED/gpu_dvfs_enable"
    write_val "1" "$GED/gx_boost_on"
    write_val "1" "$GED/gx_dfps"
    write_val "100" "$GED/gx_fb_dvfs_margin"
    write_val "1" "$GED/gx_force_cpu_boost"
    write_val "1" "$GED/gx_frc_mode"
    write_val "1" "$GED/gx_game_mode"
    write_val "1" "$GED/gx_top_app_pid"
    write_val "1" "$GED/is_GED_KPI_enabled"
    write_val "0" "$GED/target_t_cpu_remained"
done

# Unity Fix
write_val "com.miHoYo., com.activision., com.riotgames., com.riotgames.league., com.mobile., com.mobile.legends, com.dts., UnityMain, libAkSoundEngine.so, libalog.so libAudio360-JNI.so, libAudio360.so, libAVProLocal.so, libbreakpad_client.so, libbytebench.so, libbytehook.so, libcpuinfo.so, libEncryptor.so, libEncryptorP.so, libgodzilla-sysopt.so, libhades.so, libil2ccp.so, libjato.so, libmain.so, libmoba.so, libmonitorcollector-lib.so, libmultinetwork.so, liblnpth_dl.so,  liblnpth_dumper.so, liblnpth_logcat.so, liblnpth_tools.so, liblnpth_wrapper.so, liblnpth_xasan.so, liblnpth.so, libopus.so, linopusJNI.so, librendentry.so,  libResources.so, libunity.so, libagora-rtc-sdk-jni.so, linAgoraSdkCwrapper.so, libavcodex.so, libavfilter.so, libavformat.so, libavutil.so, libbyte_rec.so, libbyteaudio.so, libffmpeg-cmd.so, libgame_turbo.so, libpl_droidsonroids_gif.so, libshadowhook.so, libgamesdkcronet.so,  libswresample.so, libboringssl.so, libttcrypto, libttvideouploaderso, libulien_audio_jni.so, libulien_audio.so, libulien_video.so, libvolcenginertc.so, libfb.so" "/proc/sys/kernel/sched_lib_name"
lock_val "255" "/proc/sys/kernel/sched_lib_mask_force"

resetprop -n persist.sys.performance.tuning 1
resetprop -n debug.performance.tuning 1
resetprop -n debug.sf.showupdates 0
resetprop -n debug.sf.showcpu 0
resetprop -n debug.sf.showbackground 0
resetprop -n debug.sf.showfps 0
resetprop -n hwui.disable_vsync true
resetprop -n debug.sf.vsync 0
resetprop -n debug.cpurend.vsync false
resetprop -n persist.service.pcsync.enable 0
resetprop -n debug.hwui.empty_window false
resetprop -n debug.hwui.disable_vsync 1
resetprop -n debug.hwui.fps_limit 0
resetprop -n ro.vsync.control 0
resetprop -n debug.sf.vsync_disable 1
setprop debug.egl.swapinterval 0
setprop vendor.debug.egl.swapinterval 0
#ngenntouch
resetprop -n ro.input.resampling 1
resetprop -n touch.pressure.scale 0.001
resetprop -n touch.size.calibration diameter
resetprop -n touch.pressure.calibration amplitude
resetprop -n touch.size.scale 1
resetprop -n touch.size.bias 0
resetprop -n touch.size.isSummed 1
resetprop -n touch.orientation.calibration none
resetprop -n touch.distance.calibration none
resetprop -n touch.distance.scale 0
resetprop -n touch.coverage.calibration box
resetprop -n touch.gestureMode spots
resetprop -n debug.input.normalizetouch true
resetprop -n persist.vendor.qti.inputopts.movetouchslop 0.1
resetprop -n persist.vendor.qti.inputopts.enable true
resetprop -n persist.sys.brightness.low.gamma true
#best sf saturation Similar to the AMOLED screen
resetprop -n persist.sys.sf.color_saturation 1.7
service call SurfaceFlinger 1022 f 1.7
# Disable Limit 60Fps while Gaming on AOSP 15.0 thanks miazmi
resetprop -n debug.graphics.game_default_frame_rate.disabled true


Daily
notif_end
sleep 1
GM &