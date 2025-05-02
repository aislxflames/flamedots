#!/bin/sh

# Continuous Battery Monitoring Script with Charging Start/Stop Detection

export XAUTHORITY=~/.Xauthority
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Battery thresholds
WARNING_LEVEL=20
CRITICAL_LEVEL=5

# Variables to track the last state
PREVIOUS_CHARGING_STATE=-1
PREVIOUS_BATTERY_LEVEL=-1

# Log file for debugging
LOG_FILE="/tmp/battery_monitor.log"

# Check that environment variables are set for notifications
echo "Checking environment variables..." > $LOG_FILE
echo "DISPLAY=$DISPLAY" >> $LOG_FILE
echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" >> $LOG_FILE

# Start background monitoring loop
while true; do
    # Fetch battery information
    BATTERY_INFO=$(acpi -b | grep "Battery 0")
    BATTERY_LEVEL=$(echo "$BATTERY_INFO" | grep -P -o '[0-9]+(?=%)')
    BATTERY_STATE=$(echo "$BATTERY_INFO" | grep -o "Charging\|Discharging\|Full")

    # Log battery information to file
    echo "$(date) - BATTERY_STATE: $BATTERY_STATE, BATTERY_LEVEL: $BATTERY_LEVEL" >> $LOG_FILE

    # Determine charging state: 1 = charging, 0 = discharging
    if [ "$BATTERY_STATE" = "Charging" ]; then
        CHARGING_STATE=1
    else
        CHARGING_STATE=0
    fi

    # Detect changes in charging state
    if [ "$CHARGING_STATE" -ne "$PREVIOUS_CHARGING_STATE" ]; then
        if [ "$CHARGING_STATE" -eq 1 ]; then
            echo "$(date) - Battery started charging" >> $LOG_FILE
            notify-send "Battery Charging" "Battery is now charging at ${BATTERY_LEVEL}%." -i "battery-charging" -r 9991
        elif [ "$CHARGING_STATE" -eq 0 ] && [ "$PREVIOUS_CHARGING_STATE" -eq 1 ]; then
            echo "$(date) - Battery stopped charging" >> $LOG_FILE
            notify-send "Battery Stopped Charging" "Battery is no longer charging." -i "battery-discharging" -r 9991
        fi
    fi

    # Notify when battery level is full (and still charging)
    if [ "$BATTERY_LEVEL" -gt 99 ] && [ "$CHARGING_STATE" -eq 1 ]; then
        echo "$(date) - Battery is fully charged" >> $LOG_FILE
        notify-send "Battery Charged" "Battery is fully charged." -i "battery-full" -r 9991
    fi

    # Notify for low battery level
    if [ "$BATTERY_LEVEL" -le "$WARNING_LEVEL" ] && [ "$CHARGING_STATE" -eq 0 ]; then
        echo "$(date) - Battery is low" >> $LOG_FILE
        notify-send "Low Battery" "${BATTERY_LEVEL}% of battery remaining." -u critical -i "battery-low" -r 9991
    fi

    # Notify for critically low battery
    if [ "$BATTERY_LEVEL" -le "$CRITICAL_LEVEL" ] && [ "$CHARGING_STATE" -eq 0 ]; then
        echo "$(date) - Battery is critically low" >> $LOG_FILE
        notify-send "Battery Critical" "Battery level critically low (${BATTERY_LEVEL}%). The system may shut down soon." -u critical -i "battery-critical" -r 9991
    fi

    # Update previous states
    PREVIOUS_CHARGING_STATE=$CHARGING_STATE
    PREVIOUS_BATTERY_LEVEL=$BATTERY_LEVEL

    # Wait for 10 seconds before checking again
    sleep 1
done
