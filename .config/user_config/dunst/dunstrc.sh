#!/bin/sh

dunst_config="$USER_CONFIG/dunst/dunstrc"

cat << EOF > "$dunst_config"
[global]
    monitor = 0
    follow = mouse
    geometry = "250x5-10+30"
    indicate_hidden = yes
    shrink = no
    transparency = 0
    notification_height = 0
    separator_height = 2
    padding = 4
    horizontal_padding = 4
    frame_width = 2
    foreground = "$WHITE_0"
    separator_color = "$BLACK_1"
    sort = yes
    idle_threshold = 120

    font = JetBrains Mono 8
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes

    icon_position = off
    max_icon_size = 32
    icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

    sticky_history = yes
    history_length = 20

    dmenu = $(which dmenu) $(dmenu_center.sh 600 12)
    browser = $(which firefox-esr) -new-tab
    always_run_script = true
    startup_notification = false

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+Tab

[urgency_low]
    frame_color = "$GREEN_0"
    background = "$BACKGD"
    foreground = "$WHITE_0"
    timeout = 6

[urgency_normal]
    frame_color = "$BLUE_0"
    background = "$BACKGD"
    foreground = "$WHITE_0"
    timeout = 6

[urgency_critical]
    frame_color = "$RED_0"
    background = "$BACKGD"
    foreground = "$WHITE_0"
    timeout = 0
EOF

dunst -conf "$dunst_config" &
