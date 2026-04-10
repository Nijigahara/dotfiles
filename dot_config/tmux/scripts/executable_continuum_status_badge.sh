#!/usr/bin/env bash

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value
	option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

interval="$(get_tmux_option "@continuum-save-interval" "15")"
last_saved="$(get_tmux_option "@continuum-save-last-timestamp" "")"
now="$(date +%s)"

if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
	interval=15
fi

if [ "$interval" -le 0 ]; then
	echo '#[fg=colour6,nobold] off'
	exit 0
fi

if ! [[ "$last_saved" =~ ^[0-9]+$ ]]; then
	echo '#[fg=colour6,nobold] pending'
	exit 0
fi

age="$((now - last_saved))"

if [ "$age" -lt 60 ]; then
	age_display='now'
elif [ "$age" -lt 3600 ]; then
	age_display="$((age / 60))m ago"
else
	age_display="$((age / 3600))h ago"
fi

echo "#[fg=colour6,nobold] ${age_display}"
