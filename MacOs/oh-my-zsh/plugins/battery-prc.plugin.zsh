
#Setting default values for the icons to display in each case
: ${ZSH_BATTERY_CHARGING:="🔋"}
: ${ZSH_BATTERY_DISCHARGING:="🪫"}
: ${ZSH_BATTERY_CHARGED:="🔋⚡️"}
: ${ZSH_BATTERY_UNKNOWN:="🔋❓"}
: ${ZSH_BATTERY_ESTIMATING:="⏳"}

function battery_pct_prompt() {
  local raw_line percent_part status_part time_part
  local percent bat_status time hours output

  # Get the line with battery info
  raw_line=$(pmset -g batt | grep "InternalBattery")

  # Split by ';' using read with IFS
  IFS=';' read -r percent_part status_part time_part _ <<< "$raw_line"

  # Clean up values
  percent=$(echo "$percent_part" | grep -o '[0-9]\+%')
  percent=${percent%\%}
  bat_status=$(echo "$status_part" | xargs)
  time=$(echo "$time_part" | xargs)

  # Format output
  if [[ "$bat_status" == "discharging" ]]; then
    if [[ "$time" =~ ^[0-9]+:[0-9]+ ]]; then
      hours=${time%%:*}
      output="${ZSH_BATTERY_DISCHARGING}[${percent}%% (${hours}h)]"
    else
      output="${ZSH_BATTERY_DISCHARGING}${ZSH_BATTERY_ESTIMATING}"
    fi
  elif [[ "$bat_status" == "charging" ]]; then
    if [[ "$time" =~ ^[0-9]+:[0-9]+ ]]; then
      hours=$(( ${time%%:*} + 1 ))
      output="${ZSH_BATTERY_CHARGING}[${percent}%% (${hours}h)]"
    else
      output="${ZSH_BATTERY_CHARGING}${ZSH_BATTERY_ESTIMATING}"
    fi
  elif [[ "$bat_status" == "charged" ]]; then
    output="${ZSH_BATTERY_CHARGED}"
  else
    output="${ZSH_BATTERY_UNKNOWN}"
  fi

  echo "$output"
}
