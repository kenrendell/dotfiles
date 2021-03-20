#!/bin/sh

battery_path="/sys/class/power_supply/$BATTERY"
interval=10
label='BAT'

while true
do
    if [ -d "$battery_path" ]; then
        battery_status="$(cut -c 1 "$battery_path/status" | tr '[:lower:]' '[:upper:]')"
        battery_charge="$(cat "$battery_path/capacity")"

        case "$battery_status" in
            'F'|'C')
                if [ "$battery_charge" -ge 90 ]; then
                    output="%{F$BLUE_0}$label $battery_status $battery_charge%%{F-}"
                else
                    output="%{F$GREEN_0}$label $battery_status $battery_charge%%{F-}"
                fi
                ;;
            'D'|'U')
                if [ "$battery_charge" -le 10 ]; then
                    output="%{F$RED_0}$label $battery_status $battery_charge%%{F-}"
                elif [ "$battery_charge" -le 30 ]; then
                    output="%{F$YELLOW_1}$label $battery_status $battery_charge%%{F-}"
                else
                    output="$label $battery_status $battery_charge%"
                fi
        esac
    else output="$label 0"; fi

    printf '%s\n' "$output"
    sleep "$interval"
done
