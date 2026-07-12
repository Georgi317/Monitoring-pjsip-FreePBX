#!/usr/bin/env bash
#
# Использование:
#   zabbix_asterisk_pjsip.sh discovery  -> массив для LLD
#   zabbix_asterisk_pjsip.sh data	-> объект {peer:status} для мастер-айтема
#
# По умолчанию (без аргумента) выдаёт data.

MODE="${1:-data}"

output=$(sudo -u asterisk asterisk -rx "pjsip show endpoints" 2>/dev/null)

first=1

case "$MODE" in
  discovery)
    echo -n "["
    ;;
  data)
    echo -n "{"
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 1
    ;;
esac

while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*Endpoint:[[:space:]]+([^[:space:]/]+)[^[:space:]]*[[:space:]]+(Not\ in\ use|Unavailable|In\ use|Busy|Ringing|Available) ]]; then
    peer="${BASH_REMATCH[1]}"
    status="${BASH_REMATCH[2]}"

    if [[ -n "$peer" && "$peer" != "<Endpoint" ]]; then
      [[ $first -eq 1 ]] && first=0 || echo -n ","

      if [[ "$MODE" == "discovery" ]]; then
        printf '{"{#PEER}":"%s","{#STATUS}":"%s"}' "$peer" "$status"
      else
	printf '"%s":"%s"' "$peer" "$status"
      fi
    fi
  fi
done <<< "$output"

case "$MODE" in
  discovery)
    echo "]"
    ;;
  data)
    echo "}"
    ;;
