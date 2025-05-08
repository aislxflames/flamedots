#!/bin/sh

# Increment, decrement, or mute the volume using Pipewire and send a notification

ICON_PATH="$HOME/.local/share/icons/volume-icon/"

case $1 in
up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+
	;;
down)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%-
	;;
mute)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	;;
esac

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | tr -dc '0-9' | sed 's/^0\{1,2\}//')

send_notification() {
	if [ "$1" = "mute" ]; then
		ICON="mute"
	elif [ "$VOLUME" -lt 33 ]; then
		ICON="low"
	elif [ "$VOLUME" -lt 66 ]; then
		ICON="medium"
	else
		ICON="high"
	fi

	notify-send -c "Volume" -r 9993 -h int:value:"$VOLUME" -i "$HOME/.local/share/icons/volume-icon/volume-$ICON.svg" "Volume: $VOLUME%" "$TEXT" -t 2000 --hint=string:x-canonical-private-synchronous:volume
}

case $1 in
mute)
	case "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)" in
	*MUTED*) send_notification mute ;;
	*) send_notification ;;
	esac
	;;
*)
	send_notification
	;;
esac
