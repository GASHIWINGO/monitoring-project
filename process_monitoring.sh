#!/bin/bash

PROCESS_NAME="test"
API_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
PREV_PID_FILE="/var/run/monitoring_test.pid"

log() {
	echo "$(/usr/bin/date '+%Y-%m-%d %H:%M:%S') - $1\n" >> "$LOG_FILE"
}

CURRENT_PID=$(pgrep -x "$PROCESS_NAME")

if [ -f "$PREV_PID_FILE" ]; then
	LAST_PID=$(cat "$PREV_PID_FILE")
else
	LAST_PID=""
fi

if [ -n "$CURRENT_PID" ]; then
	
	if [ "$CURRENT_PID" != "$LAST_PID" ]; then
		log "Процесс '$PROCESS_NAME' был перезапущен. Новый PID: $CURRENT_PID"
		echo "$CURRENT_PID" > "$PREV_PID_FILE"
	fi

	HOST=$(echo "$API_URL" | sed -e 's|https://||' -e 's|/.*||')
	PATH=$(echo "$API_URL" | sed -e 's|https://[^/]*||' -e 's|.*|/&|' -e 's|//|/|' )

	HTTP_REQUEST="GET $PATH HTTP/1.1\r\nHost: $HOST\r\nConnection: close\r\n\r\n"

	RESPONSE_CHECK=$(printf "$HTTP_REQUEST" | openssl s_client -quiet -connect "$HOST:443" 2>/dev/null | /usr/bin/grep "HTTP/1.1 200")

	if [ -z "$RESPONSE_CHECK" ]; then
		log "Ошибка: Сервер мониторинга $HOST недоступен или вернул ошибку."
	fi

else
	if [ -f "$PREV_PID_FILE" ]; then
	log "Процесс '$PROCESS_NAME' остановлен."
	rm "$PREV_PID_FILE"
	fi
fi
