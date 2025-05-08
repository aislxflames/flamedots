#!/bin/bash

# Auto-detect battery and AC adapter names
BAT_DEVICE=$(ls /sys/class/power_supply/ | grep -i BAT)
AC_DEVICE=$(ls /sys/class/power_supply/ | grep -i AC)

BAT_PATH="/sys/class/power_supply/$BAT_DEVICE"
AC_PATH="/sys/class/power_supply/$AC_DEVICE"

ICON_PATH="$HOME/.local/share/icons/battery-icons"
NOTIFY_ID=9998
CATEGORY="Battery"
TIMEOUT=3000
HINT="--hint=string:x-canonical-private-synchronous:battery"

PREV_AC_ONLINE=""
PREV_STATUS=""
FIRST_RUN=true

send_notify() {
    local title="$1"
    local message="$2"
    local icon="$3"
    notify-send -c "$CATEGORY" -r "$NOTIFY_ID" -t "$TIMEOUT" \
        -i "$ICON_PATH/$icon" $HINT "$title" "$message"
}

check_status() {
    AC_ONLINE=$(cat "$AC_PATH/online")
    CAPACITY=$(cat "$BAT_PATH/capacity")
    STATUS=$(cat "$BAT_PATH/status")

    # Skip first run to avoid notifications
    if $FIRST_RUN; then
        PREV_AC_ONLINE="$AC_ONLINE"
        PREV_STATUS="$STATUS"
        FIRST_RUN=false
        return
    fi

    # Plug/unplug event
    if [[ "$AC_ONLINE" != "$PREV_AC_ONLINE" ]]; then
        if [[ "$AC_ONLINE" == "1" ]]; then
            send_notify "Charger Plugged" "AC adapter connected." "charger-plugged.svg"
        else
            send_notify "Charger Unplugged" "Running on battery." "charger-unplugged.svg"
        fi
        PREV_AC_ONLINE="$AC_ONLINE"
    fi

    # Charging status event
    if [[ "$STATUS" != "$PREV_STATUS" ]]; then
        case "$STATUS" in
            "Charging")
                send_notify "Charging Started" "Battery is charging at ${CAPACITY}%." "charging.svg"
                ;;
            "Discharging")
                send_notify "Discharging" "Battery is now discharging (${CAPACITY}%)." "discharging.svg"
                ;;
            "Full")
                send_notify "Battery Full" "Battery is fully charged (${CAPACITY}%)." "battery-full.svg"
                ;;
        esac
        PREV_STATUS="$STATUS"
    fi

    # Battery percentage-based icons
    if [ "$CAPACITY" -le 15 ]; then
        send_notify "Battery Low" "Battery is at ${CAPACITY}%. Please plug in your charger." "battery-low.svg"
    elif [ "$CAPACITY" -le 20 ]; then
        send_notify "Battery 20%" "Battery is at ${CAPACITY}%. Please charge soon." "battery-20.svg"
    elif [ "$CAPACITY" -le 40 ]; then
        send_notify "Battery 40%" "Battery is at ${CAPACITY}%. You can use it for a while." "battery-40.svg"
    elif [ "$CAPACITY" -le 50 ]; then
        send_notify "Battery 50%" "Battery is at ${CAPACITY}%. Halfway there!" "battery-50.svg"
    elif [ "$CAPACITY" -le 60 ]; then
        send_notify "Battery 60%" "Battery is at ${CAPACITY}%. Still good!" "battery-60.svg"
    elif [ "$CAPACITY" -le 80 ]; then
        send_notify "Battery 80%" "Battery is at ${CAPACITY}%. Almost full!" "battery-80.svg"
    fi
}

# Monitor for power events — skip the first event to avoid startup notification
udevadm monitor --udev --subsystem-match=power_supply | while read -r _; do
    check_status
done

