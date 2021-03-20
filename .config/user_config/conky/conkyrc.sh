#!/bin/sh

# shellcheck source=./color_tools.sh
. "$USER_CONFIG/conky/color_tools.sh"
conky_config="$USER_CONFIG/conky/conkyrc"

default_color="$(printf '%s' "$WHITE_0" | tr -d '#')"
color0="$(printf '%s' "$CYAN_1" | tr -d '#')"
color1="$(printf '%s' "$CYAN_0" | tr -d '#')"
color2="$(printf '%s' "$(adjust_color "$CYAN_0" 0 0 -20)" | tr -d '#')"
color3="$(printf '%s' "$(adjust_color "$CYAN_0" 0 0 20)" | tr -d '#')"

config_text="\
-- Conky Configuration File

conky.config = {
	alignment = 'tl',
	minimum_width = 590,
	maximum_width = 590,
	border_width = 0,
	gap_x = 20,
	gap_y = 35,

	update_interval = 2,
	background = true,
	double_buffer = true,
	own_window = true,
	own_window_type = 'desktop',
	own_window_argb_visual = true,
	own_window_argb_value = 0,
	draw_shades = false,

	use_spacer = 'none',
	format_human_readable = true,
	short_units = true,
	temperature_unit = 'celsius',
	pad_percents = 0,

	top_name_width = 16,
	top_name_verbose = false,
	top_cpu_separate = false,

	if_up_strictness = 'address',
	no_buffers = false,
	hddtemp_host = '127.0.0.1',
	hddtemp_port = 7634,

	cpu_avg_samples = 5,
	diskio_avg_samples = 5,
	net_avg_samples = 5,

	use_xft = true,
	font = 'JetBrains Mono:style=Light:pixelsize=10',
	font0 = 'JetBrains Mono:style=Regular:pixelsize=10',
	font1 = 'JetBrains Mono:style=Medium:pixelsize=11',
	font2 = 'JetBrains Mono:style=Bold:pixelsize=11',

	default_color = '$default_color',
	color0 = '$color0',
	color1 = '$color1',
	color2 = '$color2',
"'
	template0 = [[${voffset \3}${goto \4}${if_match "\1" != "none"}${font1}${color0}\1 ${endif}${font2}${color1}\2]],
	template1 = [[${voffset \4}${goto \5}${font}${color1}\1${color}${alignr}${offset \6} ${if_match "\2" != "none"}${\2}${endif}${if_match "\3" != "none"}\3${endif}]],
	template2 = [[${voffset \2}${goto \3}${font0}${color0}NAME${alignr}${offset \4}\1]],
	template3 = [[${goto \6}${font}${color1}${\2 name \1}${color}${alignr}${offset \7}${\2 \3 \1} ${\2 \4 \1} ${\2 \5 \1}]],
	template4 = [[${voffset \5}${goto \6}${font}${color1}\1${color}${if_match "\2" != "none"}  ${\2}%${endif}${alignr}${offset \7}${\3} / ${\4}]],
	template5 = [[${template4 \1 fs_used_perc\\ \2 fs_used\\ \2 fs_size\\ \2 \3 \4 \5}]],
	template6 = [[${voffset \7}${goto \8}${font}${color1}\1  ${color}${\2 \3}${alignr}${offset \9}${color1}\4  ${color}${\5 \6}]],
	template7 = [[${voffset \6}${goto \7}${color2}${if_match "\2" == "none"}${\1 \3,\4}${else}${if_match "\5" == "1"}${\1 \3,\4 \2}${else}${\1 \2 \3,\4}${endif}${endif}]],
	template8 = [[${voffset \5}${goto \6}${color2}${if_match "\2" == "none"}${\1 \3,\4'" $color2 $color3 "'-t}${else}${\1 \2 \3,\4'" $color2 $color3 "'-t}${endif}]],
	template9 = [[${template0 NETWORK ================================ 15 310}
		${template6 Up upspeed \1 Uploaded totalup \1 5 325 -10}
		${template8 upspeedgraph \1 50 255 0 325}
		${template6 Down downspeed \1 Downloaded totaldown \1 0 325 -10}
		${template8 downspeedgraph \1 50 255 0 325}
		${template1 Interface none \1 0 325 -10}
		${template1 IP\\ address addr\\ \1 none 0 325 -10}
		${if_match "\2" == "1"}${template1 ESSID wireless_essid\\ \1 none 0 325 -10}
		${template1 Mode wireless_mode\\ \1 none 0 325 -10}
		${template1 Quality wireless_link_qual_perc\\ \1 % 0 325 -10}
		${template1 Frequency wireless_freq\\ \1 none 0 325 -10}
		${endif}${template1 Firewall execi\\ 3600\\ systemctl\\ is-active\\ ufw.service none 0 325 -10}
		${template0 none ======================================== 5 310}]]
};

conky.text = [[
#
# -------------
# | PROCESSOR |
# -------------
# Use "nproc" to see the number of cpu cores
# See "/sys/class/hwmon/"
${template0 PROCESSOR ============================== 0 0}
# General CPU usage
${template1 CPU\ usage cpu\ cpu0 % 5 15 -470}
${template7 cpubar cpu0 5 140 0 -14 130}
# Core 1
${template1 Core\ 1 cpu\ cpu1 % 5 15 -470}
${template1 Freq\ Mhz freq\ 1 none 0 15 -470}
${template1 Temp hwmon\ 3\ temp\ 2 °C 0 15 -470}
${template8 cpugraph cpu1 37 140 -45 130}
# Core 2
${template1 Core\ 1 cpu\ cpu2 % 5 15 -470}
${template1 Freq\ Mhz freq\ 2 none 0 15 -470}
${template1 Temp hwmon\ 3\ temp\ 3 °C 0 15 -470}
${template8 cpugraph cpu2 37 140 -45 130}
# Load Average
${template1 Load\ Average loadavg none 2 15 -320}
${template8 loadgraph none 50 255 0 15}
# Entropy
${template4 Entropy entropy_perc entropy_avail entropy_poolsize 0 15 -320}
${template7 entropy_bar none 5 255 0 0 15}
# ACPI Temperature
${template1 ACPI\ Temp hwmon\ 0\ temp\ 1 °C 3 15 -320}
# Uptime
${template1 Uptime uptime_short none 0 15 -320}
# Power saving (using tlp)
${template1 TLP\ service execi\ 3600\ systemctl\ is-active\ tlp.service none 0 15 -320}
${template1 Laptop\ mode laptop_mode none 0 15 -320}
# Running processes and threads
${template4 Threads none running_threads threads 0 15 -320}
${template4 Processes none running_processes processes 0 15 -320}
# Top cpu processes
${template2 TIME\ \ \ \ \ PID\ \ \ CPU% 6 15 -320}
${template3 1 top time pid cpu 15 -320}
${template3 2 top time pid cpu 15 -320}
${template3 3 top time pid cpu 15 -320}
${template3 4 top time pid cpu 15 -320}
${template3 5 top time pid cpu 15 -320}
#
# ----------
# | MEMORY |
# ----------
${template0 MEMORY ================================= 15 0}
${template4 RAM\ usage memperc mem memmax 5 15 -320}
${template7 membar none 5 255 0 0 15}
${template1 Cached cached none 5 15 -470}
${template1 Buffered buffers none 0 15 -470}
${template1 Dirty memdirty none 0 15 -470}
${template1 Free memfree none 0 15 -470}
${template8 memgraph none 50 140 -59 130}
# Top memory processes
${template2 RES\ \ \ \ \ PID\ \ \ MEM% 0 15 -320}
${template3 1 top_mem mem_res pid mem 15 -320}
${template3 2 top_mem mem_res pid mem 15 -320}
${template3 3 top_mem mem_res pid mem 15 -320}
${template3 4 top_mem mem_res pid mem 15 -320}
${template3 5 top_mem mem_res pid mem 15 -320}
${template3 6 top_mem mem_res pid mem 15 -320}
${template3 7 top_mem mem_res pid mem 15 -320}
${template3 8 top_mem mem_res pid mem 15 -320}
${template3 9 top_mem mem_res pid mem 15 -320}
${template0 none ======================================== 5 0}
#
# --------------
# | FILESYSTEM |
# --------------
${template0 FILESYSTEM =================================== -719 310}
${template5 Root / 5 325 -10}
${template7 fs_bar / 5 255 1 0 325}
${template5 Home /home 3 325 -10}
${template7 fs_bar /home 5 255 1 0 325}
${template4 Swap swapperc swap swapmax 3 325 -10}
${template7 swapbar none 5 255 0 0 325}
# Disk IO
# Use "lsblk" to list block devices
# Disk IO for reads
${template1 Read diskio_read\ sda none 5 325 -10}
${template8 diskiograph_read sda 50 255 0 325}
# Disk IO for writes
${template1 Write diskio_write\ sda none 0 325 -10}
${template8 diskiograph_write sda 50 255 0 325}
# HDD/SSD temperature
# Set "RUN_DAEMON" to "true" in "/etc/default/hddtemp"
${template1 Temp\ /dev/sda hddtemp\ /dev/sda °C 0 325 -10}
# Top IO processes
${template2 UID\ \ \ \ \ PID\ \ \ \ IO% 6 325 -10}
${template3 1 top_io uid pid io_perc 325 -10}
${template3 2 top_io uid pid io_perc 325 -10}
${template3 3 top_io uid pid io_perc 325 -10}
${template3 4 top_io uid pid io_perc 325 -10}
${template3 5 top_io uid pid io_perc 325 -10}
#
# -----------
# | NETWORK |
# -----------
# Use "ip link" to see available network devices
# Find the active network interface
${if_up wlp3s0}${template9 wlp3s0 1}
${else}${if_up enp2s0}${template9 enp2s0 0}
${else}${if_up usb0}${template9 usb0 0}
${else}${template0 none ======================================== 5 310}
${endif}${endif}${endif}]]'

printf '%s' "$config_text" > "$conky_config"
conky -q -c "$conky_config" &
