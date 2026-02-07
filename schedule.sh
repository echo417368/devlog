#!/bin/bash
# Runs daily, schedules 6-8 autocommit runs at random PST hours
# Server is UTC, so offset by +8 hours for PST scheduling

NUM_RUNS=$(( RANDOM % 3 + 6 ))

HOURS=()
while [ ${#HOURS[@]} -lt $NUM_RUNS ]; do
  # Pick random PST hour between 8am-11pm PST = 16:00-07:00 UTC (next day)
  pst_h=$(( RANDOM % 16 + 8 ))
  dup=0
  for existing in "${HOURS[@]}"; do
    [ "$existing" -eq "$pst_h" ] && dup=1 && break
  done
  [ $dup -eq 0 ] && HOURS+=($pst_h)
done

for pst_h in "${HOURS[@]}"; do
  # Convert PST to UTC: add 8 hours
  utc_h=$(( (pst_h + 8) % 24 ))
  m=$(( RANDOM % 60 ))

  # If UTC hour wraps past midnight, schedule for tomorrow
  if [ $pst_h -ge 16 ]; then
    echo "/bin/bash /opt/devlog/autocommit.sh >> /opt/devlog/autocommit.log 2>&1" | at $(printf "%02d:%02d tomorrow" $utc_h $m) 2>/dev/null
  else
    echo "/bin/bash /opt/devlog/autocommit.sh >> /opt/devlog/autocommit.log 2>&1" | at $(printf "%02d:%02d today" $utc_h $m) 2>/dev/null
  fi
done

echo "$(TZ=America/Los_Angeles date): scheduled $NUM_RUNS runs at PST hours: ${HOURS[*]}" >> /opt/devlog/autocommit.log
